import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:snap_shelf/models/recipe_model.dart';

class RecipeService {
  static const String recipeApiKey = '9c176314446a453abee3974c4af45676';

  static Future<List<RecipeModel>> fetchRecipes(
      List<String> ingredients) async {
    final ingredientsStr = ingredients.join(',');
    final url = Uri.parse(
      'https://api.spoonacular.com/recipes/findByIngredients?ingredients=$ingredientsStr&number=10&apiKey=$recipeApiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> recipesData = jsonDecode(response.body);

      // Map the response to RecipeModel objects
      return recipesData.map((recipe) => RecipeModel.fromJson(recipe)).toList();
    } else {
      throw Exception('Failed to fetch recipes');
    }
  }

  static Future<Map<String, dynamic>> fetchRecipeDetails(int recipeId) async {
    final url = Uri.parse(
      'https://api.spoonacular.com/recipes/$recipeId/information?apiKey=$recipeApiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch recipe details');
    }
  }
}
