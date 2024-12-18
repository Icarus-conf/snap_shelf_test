import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(IngredientDetectorApp());
}

class IngredientDetectorApp extends StatelessWidget {
  const IngredientDetectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ingredient Detector',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: IngredientDetectorScreen(),
    );
  }
}

class IngredientDetectorScreen extends StatefulWidget {
  const IngredientDetectorScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IngredientDetectorScreenState createState() =>
      _IngredientDetectorScreenState();
}

class _IngredientDetectorScreenState extends State<IngredientDetectorScreen> {
  File? _image; // To hold the selected image
  List<String> _detectedIngredients = []; // Detected ingredients list
  List<Map<String, dynamic>> _recipes =
      []; // Recipes list (now includes details)
  final ImagePicker _picker = ImagePicker(); // Image picker instance
  final String _geminiApiKey =
      'AIzaSyAPt4e_jvFypNsVpmEoBK9dUUDvzYzu4Oo'; // Replace with your Gemini API key
  final String _recipeApiKey =
      '9c176314446a453abee3974c4af45676'; // Replace with your Recipe API key (e.g., Spoonacular)

  // Method to pick an image (Camera/Gallery)
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _detectedIngredients = [];
        _recipes = [];
      });
      await _processImageAndGenerateText(_image!);
    }
  }

  // Method to process image and generate text using Gemini
  Future<void> _processImageAndGenerateText(File image) async {
    final bytes = await image.readAsBytes();

    try {
      // Use Gemini model to generate a response based on detected ingredients
      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: _geminiApiKey,
      );

      // Create a text prompt for the model
      final prompt = 'Identify the ingredients in this image.';

      // Prepare Content.data with mimeType and bytes
      final contentData = Content.data('image/jpeg', bytes);

      // Send the image and the prompt to Gemini for content generation
      final response =
          await model.generateContent([contentData, Content.text(prompt)]);

      log('Response: ${response.text}');

      // Extract ingredient names from the response
      setState(() {
        _detectedIngredients = _extractIngredientNames(response.text ?? '');
      });

      // Now fetch recipes based on detected ingredients
      await _fetchRecipes(_detectedIngredients);
    } catch (error) {
      log('Error: $error');
      setState(() {
        _detectedIngredients = ['Error generating recipe. Try again.'];
      });
    }
  }

  // Method to extract ingredient names from the Gemini response
  List<String> _extractIngredientNames(String responseText) {
    final regex = RegExp(r'\b([A-Za-z]+(?: [A-Za-z]+)*)\b');
    final matches = regex.allMatches(responseText);
    final ingredients = matches.map((match) => match.group(0) ?? '').toList();

    final filteredIngredients = ingredients.where((ingredient) {
      return ingredient != 'a' && ingredient != 'of' && ingredient.isNotEmpty;
    }).toList();

    return filteredIngredients;
  }

  // Method to fetch recipes based on detected ingredients
  Future<void> _fetchRecipes(List<String> ingredients) async {
    final ingredientsStr = ingredients.join(',');

    log(ingredientsStr);

    final url = Uri.parse(
        'https://api.spoonacular.com/recipes/findByIngredients?ingredients=$ingredientsStr&number=5&apiKey=$_recipeApiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> recipesData = jsonDecode(response.body);

      // Explicitly cast the list of recipes to List<Map<String, dynamic>>
      setState(() {
        _recipes = recipesData
            .map((recipe) {
              // Ensure each recipe is a Map<String, dynamic>
              if (recipe is Map<String, dynamic>) {
                return {
                  'id': recipe['id'],
                  'title': recipe['title'],
                  'image': recipe['image'],
                };
              } else {
                return {}; // Return an empty map if the recipe is not of the expected type
              }
            })
            .toList()
            .cast<
                Map<String,
                    dynamic>>(); // Cast the final list to the correct type
      });
    } else {
      setState(() {
        _recipes = [];
      });
    }
  }

  // Method to fetch detailed recipe information using its id
  Future<void> _fetchRecipeDetails(int recipeId) async {
    final url = Uri.parse(
        'https://api.spoonacular.com/recipes/$recipeId/information?apiKey=$_recipeApiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final recipeDetails = jsonDecode(response.body);
      setState(() {
        _recipes.firstWhere((recipe) => recipe['id'] == recipeId)['details'] =
            recipeDetails;
      });
    } else {
      setState(() {
        _recipes.firstWhere((recipe) => recipe['id'] == recipeId)['details'] =
            'Error fetching recipe details.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ingredient Detector')),
      body: Center(
        child: SingleChildScrollView(
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
                    child: Text('Take Photo'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: Text('Upload Photo'),
                  ),
                ],
              ),
              if (_detectedIngredients.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Detected Ingredients:\n${_detectedIngredients.join(', ')}',
                    textAlign: TextAlign.center,
                  ),
                ),
              if (_recipes.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _recipes.map((recipe) {
                      return GestureDetector(
                        onTap: () => _fetchRecipeDetails(recipe['id']),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe['title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              if (recipe['details'] != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Details: ${recipe['details'] ?? ''}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
