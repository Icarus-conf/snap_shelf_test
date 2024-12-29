class Recipe {
  final bool? vegetarian;
  final bool? vegan;
  final bool? glutenFree;
  final bool? dairyFree;
  final bool? veryHealthy;
  final bool? cheap;
  final bool? veryPopular;
  final bool? sustainable;
  final bool? lowFodmap;
  final num? weightWatcherSmartPoints;
  final String? gaps;
  final num? preparationMinutes;
  final num? cookingMinutes;
  final num? aggregateLikes;
  final num? healthScore;
  final String? creditsText;
  final String? license;
  final String? sourceName;
  final num? pricePerServing;
  final List<Ingredient>? extendedIngredients;
  final num? id;
  final String? title;
  final num? readyInMinutes;
  final num? servings;
  final String? sourceUrl;
  final String? image;
  final String? imageType;
  final String? summary;
  final List<String>? dishTypes;
  final List<String>? cuisines;
  final List<String>? diets;
  final List<String>? occasions;
  final String? instructions;

  final num? spoonacularScore;
  final String? spoonacularSourceUrl;

  Recipe({
    this.vegetarian,
    this.vegan,
    this.glutenFree,
    this.dairyFree,
    this.veryHealthy,
    this.cheap,
    this.veryPopular,
    this.sustainable,
    this.lowFodmap,
    this.weightWatcherSmartPoints,
    this.gaps,
    this.preparationMinutes,
    this.cookingMinutes,
    this.aggregateLikes,
    this.healthScore,
    this.creditsText,
    this.license,
    this.sourceName,
    this.pricePerServing,
    this.extendedIngredients,
    this.id,
    this.title,
    this.readyInMinutes,
    this.servings,
    this.sourceUrl,
    this.image,
    this.imageType,
    this.summary,
    this.dishTypes,
    this.cuisines,
    this.diets,
    this.occasions,
    this.instructions,
    this.spoonacularScore,
    this.spoonacularSourceUrl,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      vegetarian: json['vegetarian'],
      vegan: json['vegan'],
      glutenFree: json['glutenFree'],
      dairyFree: json['dairyFree'],
      veryHealthy: json['veryHealthy'],
      cheap: json['cheap'],
      veryPopular: json['veryPopular'],
      sustainable: json['sustainable'],
      lowFodmap: json['lowFodmap'],
      weightWatcherSmartPoints: json['weightWatcherSmartPoints']?.toDouble(),
      gaps: json['gaps'],
      preparationMinutes: json['preparationMinutes'],
      cookingMinutes: json['cookingMinutes'],
      aggregateLikes: json['aggregateLikes'],
      healthScore: json['healthScore'],
      creditsText: json['creditsText'],
      license: json['license'],
      sourceName: json['sourceName'],
      pricePerServing: json['pricePerServing']?.toDouble(),
      extendedIngredients: json['extendedIngredients'] != null
          ? (json['extendedIngredients'] as List)
              .map((e) => Ingredient.fromJson(e))
              .toList()
          : null,
      id: json['id'],
      title: json['title'],
      readyInMinutes: json['readyInMinutes'],
      servings: json['servings'],
      sourceUrl: json['sourceUrl'],
      image: json['image'],
      imageType: json['imageType'],
      summary: json['summary'],
      dishTypes: json['dishTypes'] != null
          ? List<String>.from(json['dishTypes'])
          : null,
      cuisines:
          json['cuisines'] != null ? List<String>.from(json['cuisines']) : null,
      diets: json['diets'] != null ? List<String>.from(json['diets']) : null,
      occasions: json['occasions'] != null
          ? List<String>.from(json['occasions'])
          : null,
      instructions: json['instructions'],
      spoonacularScore: json['spoonacularScore']?.toDouble(),
      spoonacularSourceUrl: json['spoonacularSourceUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vegetarian': vegetarian,
      'vegan': vegan,
      'glutenFree': glutenFree,
      'dairyFree': dairyFree,
      'veryHealthy': veryHealthy,
      'cheap': cheap,
      'veryPopular': veryPopular,
      'sustainable': sustainable,
      'lowFodmap': lowFodmap,
      'weightWatcherSmartPoints': weightWatcherSmartPoints,
      'gaps': gaps,
      'preparationMinutes': preparationMinutes,
      'cookingMinutes': cookingMinutes,
      'aggregateLikes': aggregateLikes,
      'healthScore': healthScore,
      'creditsText': creditsText,
      'license': license,
      'sourceName': sourceName,
      'pricePerServing': pricePerServing,
      'extendedIngredients':
          extendedIngredients?.map((e) => e.toJson()).toList(),
      'id': id,
      'title': title,
      'readyInMinutes': readyInMinutes,
      'servings': servings,
      'sourceUrl': sourceUrl,
      'image': image,
      'imageType': imageType,
      'summary': summary,
      'dishTypes': dishTypes,
      'cuisines': cuisines,
      'diets': diets,
      'occasions': occasions,
      'instructions': instructions,
      'spoonacularScore': spoonacularScore,
      'spoonacularSourceUrl': spoonacularSourceUrl,
    };
  }
}

class Ingredient {
  final num? id;
  final String? aisle;
  final String? image;
  final String? consistency;
  final String? name;
  final String? nameClean;
  final String? original;
  final String? originalName;
  final num? amount;
  final String? unit;
  final List<String>? meta;
  final Measures? measures;

  Ingredient({
    this.id,
    this.aisle,
    this.image,
    this.consistency,
    this.name,
    this.nameClean,
    this.original,
    this.originalName,
    this.amount,
    this.unit,
    this.meta,
    this.measures,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      aisle: json['aisle'],
      image: json['image'],
      consistency: json['consistency'],
      name: json['name'],
      nameClean: json['nameClean'],
      original: json['original'],
      originalName: json['originalName'],
      amount: json['amount'],
      unit: json['unit'],
      meta: json['meta'] != null ? List<String>.from(json['meta']) : null,
      measures:
          json['measures'] != null ? Measures.fromJson(json['measures']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'aisle': aisle,
      'image': image,
      'consistency': consistency,
      'name': name,
      'nameClean': nameClean,
      'original': original,
      'originalName': originalName,
      'amount': amount,
      'unit': unit,
      'meta': meta,
      'measures': measures?.toJson(),
    };
  }
}

class Measures {
  final Measure? us;
  final Measure? metric;

  Measures({this.us, this.metric});

  factory Measures.fromJson(Map<String, dynamic> json) {
    return Measures(
      us: json['us'] != null ? Measure.fromJson(json['us']) : null,
      metric: json['metric'] != null ? Measure.fromJson(json['metric']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'us': us?.toJson(),
      'metric': metric?.toJson(),
    };
  }
}

class Measure {
  final num? amount;
  final String? unitShort;
  final String? unitLong;

  Measure({this.amount, this.unitShort, this.unitLong});

  factory Measure.fromJson(Map<String, dynamic> json) {
    return Measure(
      amount: json['amount'],
      unitShort: json['unitShort'],
      unitLong: json['unitLong'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'unitShort': unitShort,
      'unitLong': unitLong,
    };
  }
}
