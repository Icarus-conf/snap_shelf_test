import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snap_shelf/models/recipe_model.dart';
import 'package:snap_shelf/services/ingredient_detector_service.dart';
import 'package:snap_shelf/services/recipe_service.dart';

class IngredientDisplayScreen extends StatefulWidget {
  const IngredientDisplayScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IngredientDisplayScreenState createState() =>
      _IngredientDisplayScreenState();
}

class _IngredientDisplayScreenState extends State<IngredientDisplayScreen> {
  File? _image;
  List<String> _detectedIngredients = [];
  List<RecipeModel> _recipes = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _detectedIngredients = [];
        _recipes = [];
      });
      await _processImage();
    }
  }

  Future<void> _processImage() async {
    if (_image == null) return;

    try {
      final bytes = await _image!.readAsBytes();
      final ingredients =
          await IngredientDetectorService.getIngredientsFromImage(bytes);

      // Check if ingredients list is empty and handle accordingly
      if (ingredients.isEmpty) {
        setState(() =>
            _detectedIngredients = ['No ingredients detected. Try again.']);
      } else {
        setState(() => _detectedIngredients = ingredients);

        // Fetch recipes based on detected ingredients
        final recipes = await RecipeService.fetchRecipes(ingredients);
        setState(() => _recipes = recipes);
      }
    } catch (error) {
      setState(() {
        _detectedIngredients = ['Error processing image: $error'];
      });
      log("Error processing image: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detected Ingredients')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (_image != null)
              Image.file(
                _image!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  child: const Text('Take Photo'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: const Text('Upload Photo'),
                ),
              ],
            ),
            if (_detectedIngredients.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Detected Ingredients:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Text(
              _detectedIngredients.join(', '),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            if (_recipes.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _recipes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_recipes[index].title),
                      subtitle: Text(
                          'Used Ingredients: ${_recipes[index].usedIngredientCount}'),
                      leading: Image.network(
                        _recipes[index].image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
