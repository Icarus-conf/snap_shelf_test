import 'dart:developer';
import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';

class IngredientDetectorService {
  static const String geminiApiKey = 'AIzaSyAPt4e_jvFypNsVpmEoBK9dUUDvzYzu4Oo';

  static Future<List<String>> getIngredientsFromImage(
      List<int> imageBytes) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: geminiApiKey,
    );

    try {
      final response = await model.generateContent([
        Content.data('image/jpeg', Uint8List.fromList(imageBytes)),
        Content.text(
            'Identify the ingredients in this image. Return back on your response only the ingredient names. without any other words from your side.'),
      ]);

      // If the response text is null, use an empty string to avoid type errors
      final responseText = response.text ?? '';
      log("API Response: $responseText");

      return _extractIngredientNames(responseText);
    } catch (error) {
      log("Error in API call: $error");
      throw Exception('Failed to process image');
    }
  }

  static List<String> _extractIngredientNames(String responseText) {
    final regex = RegExp(r'\b([A-Za-z]+(?: [A-Za-z]+)*)\b');
    return regex
        .allMatches(responseText)
        .map((match) => match.group(0) ?? '')
        .where((ingredient) =>
            ingredient.isNotEmpty && ingredient != 'a' && ingredient != 'of')
        .toList();
  }
}
