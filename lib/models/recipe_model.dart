import 'dart:convert';

// Main Recipe Model
class RecipeModel {
  final int id;
  final String image;
  final String imageType;
  final int likes;
  final int missedIngredientCount;
  final List<Ingredient> missedIngredients;
  final String title;
  final List<Ingredient> unusedIngredients;
  final int usedIngredientCount;
  final List<Ingredient> usedIngredients;

  RecipeModel({
    required this.id,
    required this.image,
    required this.imageType,
    required this.likes,
    required this.missedIngredientCount,
    required this.missedIngredients,
    required this.title,
    required this.unusedIngredients,
    required this.usedIngredientCount,
    required this.usedIngredients,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'],
      image: json['image'],
      imageType: json['imageType'],
      likes: json['likes'],
      missedIngredientCount: json['missedIngredientCount'],
      missedIngredients: List<Ingredient>.from(
        json['missedIngredients'].map((x) => Ingredient.fromJson(x)),
      ),
      title: json['title'],
      unusedIngredients: List<Ingredient>.from(
        json['unusedIngredients'].map((x) => Ingredient.fromJson(x)),
      ),
      usedIngredientCount: json['usedIngredientCount'],
      usedIngredients: List<Ingredient>.from(
        json['usedIngredients'].map((x) => Ingredient.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'imageType': imageType,
      'likes': likes,
      'missedIngredientCount': missedIngredientCount,
      'missedIngredients': missedIngredients.map((x) => x.toJson()).toList(),
      'title': title,
      'unusedIngredients': unusedIngredients.map((x) => x.toJson()).toList(),
      'usedIngredientCount': usedIngredientCount,
      'usedIngredients': usedIngredients.map((x) => x.toJson()).toList(),
    };
  }
}

// Ingredient Model
class Ingredient {
  final String aisle;
  final double amount;
  final int id;
  final String image;
  final List<String> meta;
  final String name;
  final String original;
  final String originalName;
  final String unit;
  final String unitLong;
  final String unitShort;

  Ingredient({
    required this.aisle,
    required this.amount,
    required this.id,
    required this.image,
    required this.meta,
    required this.name,
    required this.original,
    required this.originalName,
    required this.unit,
    required this.unitLong,
    required this.unitShort,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      aisle: json['aisle'],
      amount: (json['amount'] as num).toDouble(),
      id: json['id'],
      image: json['image'],
      meta: List<String>.from(json['meta']),
      name: json['name'],
      original: json['original'],
      originalName: json['originalName'],
      unit: json['unit'],
      unitLong: json['unitLong'],
      unitShort: json['unitShort'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'aisle': aisle,
      'amount': amount,
      'id': id,
      'image': image,
      'meta': meta,
      'name': name,
      'original': original,
      'originalName': originalName,
      'unit': unit,
      'unitLong': unitLong,
      'unitShort': unitShort,
    };
  }
}

// Parse the JSON
List<RecipeModel> parseRecipeModels(String jsonString) {
  final List parsed = json.decode(jsonString);
  return parsed.map((json) => RecipeModel.fromJson(json)).toList();
}
