import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snap_shelf/models/recipe_model.dart';
import 'package:snap_shelf/recipe_detail_screen.dart';
import 'package:snap_shelf/services/ingredient_detector_service.dart';
import 'package:snap_shelf/services/recipe_service.dart';

class IngredientDisplayScreen extends StatefulWidget {
  const IngredientDisplayScreen({super.key});

  @override
  _IngredientDisplayScreenState createState() =>
      _IngredientDisplayScreenState();
}

class _IngredientDisplayScreenState extends State<IngredientDisplayScreen> {
  File? _image;
  List<String> _detectedIngredients = [];
  List<RecipeModel> _recipes = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _detectedIngredients = [];
        _recipes = [];
        _isLoading = true;
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

      if (ingredients.isEmpty) {
        setState(() =>
            _detectedIngredients = ['No ingredients detected. Try again.']);
      } else {
        setState(() => _detectedIngredients = ingredients);
        final recipes = await RecipeService.fetchRecipes(ingredients);
        setState(() => _recipes = recipes);
      }
    } catch (error) {
      setState(() {
        _detectedIngredients = ['Error processing image: $error'];
      });
      log("Error processing image: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detected Ingredients',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (_image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.file(
                    _image!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(
                      ImageSource.camera,
                    ),
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Take Photo',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(
                      Icons.photo_library,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Upload Photo',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_isLoading) const CircularProgressIndicator(),
              if (!_isLoading && _detectedIngredients.isNotEmpty)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Detected Ingredients:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _detectedIngredients.join(', '),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              if (!_isLoading && _recipes.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _recipes.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailScreen(
                              recipeId: _recipes[index].id,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8.0),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: _recipes[index].image,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          title: Text(_recipes[index].title),
                          subtitle: Text(
                              'Used Ingredients: ${_recipes[index].usedIngredientCount}'),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
