class RecipeDetailModel {
  final num id;
  final String title;
  final String image;
  final String imageType;
  final num servings;
  final num readyInMinutes;
  final String license;
  final String sourceName;
  final String sourceUrl;
  final String spoonacularSourceUrl;
  final num aggregateLikes;
  final num healthScore;
  final num spoonacularScore;
  final num pricePerServing;
  final List<dynamic> analyzedInstructions;
  final bool cheap;
  final String creditsText;
  final List<dynamic> cuisines;
  final bool dairyFree;
  final List<dynamic> diets;
  final String gaps;
  final bool glutenFree;
  final String instructions;
  final bool ketogenic;
  final bool lowFodmap;
  final List<dynamic> occasions;
  final bool sustainable;
  final bool vegan;
  final bool vegetarian;
  final bool veryHealthy;
  final bool veryPopular;
  final bool whole30;
  final int weightWatcherSmartPoints;
  final List<String> dishTypes;
  final List<ExtendedIngredient> extendedIngredients;
  final String summary;
  final WinePairing winePairing;

  RecipeDetailModel({
    required this.id,
    required this.title,
    required this.image,
    required this.imageType,
    required this.servings,
    required this.readyInMinutes,
    required this.license,
    required this.sourceName,
    required this.sourceUrl,
    required this.spoonacularSourceUrl,
    required this.aggregateLikes,
    required this.healthScore,
    required this.spoonacularScore,
    required this.pricePerServing,
    required this.analyzedInstructions,
    required this.cheap,
    required this.creditsText,
    required this.cuisines,
    required this.dairyFree,
    required this.diets,
    required this.gaps,
    required this.glutenFree,
    required this.instructions,
    required this.ketogenic,
    required this.lowFodmap,
    required this.occasions,
    required this.sustainable,
    required this.vegan,
    required this.vegetarian,
    required this.veryHealthy,
    required this.veryPopular,
    required this.whole30,
    required this.weightWatcherSmartPoints,
    required this.dishTypes,
    required this.extendedIngredients,
    required this.summary,
    required this.winePairing,
  });

  factory RecipeDetailModel.fromJson(Map<String, dynamic> json) {
    return RecipeDetailModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      imageType: json['imageType'],
      servings: json['servings'],
      readyInMinutes: json['readyInMinutes'],
      license: json['license'],
      sourceName: json['sourceName'],
      sourceUrl: json['sourceUrl'],
      spoonacularSourceUrl: json['spoonacularSourceUrl'],
      aggregateLikes: json['aggregateLikes'],
      healthScore: json['healthScore'],
      spoonacularScore: json['spoonacularScore'],
      pricePerServing: json['pricePerServing'] as num,
      analyzedInstructions: json['analyzedInstructions'],
      cheap: json['cheap'],
      creditsText: json['creditsText'],
      cuisines: json['cuisines'],
      dairyFree: json['dairyFree'],
      diets: json['diets'],
      gaps: json['gaps'],
      glutenFree: json['glutenFree'],
      instructions: json['instructions'],
      ketogenic: json['ketogenic'],
      lowFodmap: json['lowFodmap'],
      occasions: json['occasions'],
      sustainable: json['sustainable'],
      vegan: json['vegan'],
      vegetarian: json['vegetarian'],
      veryHealthy: json['veryHealthy'],
      veryPopular: json['veryPopular'],
      whole30: json['whole30'],
      weightWatcherSmartPoints: json['weightWatcherSmartPoints'],
      dishTypes: List<String>.from(json['dishTypes']),
      extendedIngredients: (json['extendedIngredients'] as List)
          .map((e) => ExtendedIngredient.fromJson(e))
          .toList(),
      summary: json['summary'],
      winePairing: WinePairing.fromJson(json['winePairing']),
    );
  }
}

class ExtendedIngredient {
  final String aisle;
  final num amount;
  final String consitency;
  final num id;
  final String image;
  final Measures measures;
  final List<String> meta;
  final String name;
  final String original;
  final String originalName;
  final String unit;

  ExtendedIngredient({
    required this.aisle,
    required this.amount,
    required this.consitency,
    required this.id,
    required this.image,
    required this.measures,
    required this.meta,
    required this.name,
    required this.original,
    required this.originalName,
    required this.unit,
  });

  factory ExtendedIngredient.fromJson(Map<String, dynamic> json) {
    return ExtendedIngredient(
      aisle: json['aisle'],
      amount: (json['amount'] as num).toDouble(),
      consitency: json['consitency'],
      id: json['id'],
      image: json['image'],
      measures: Measures.fromJson(json['measures']),
      meta: List<String>.from(json['meta']),
      name: json['name'],
      original: json['original'],
      originalName: json['originalName'],
      unit: json['unit'],
    );
  }
}

class Measures {
  final Measure metric;
  final Measure us;

  Measures({
    required this.metric,
    required this.us,
  });

  factory Measures.fromJson(Map<String, dynamic> json) {
    return Measures(
      metric: Measure.fromJson(json['metric']),
      us: Measure.fromJson(json['us']),
    );
  }
}

class Measure {
  final num amount;
  final String unitLong;
  final String unitShort;

  Measure({
    required this.amount,
    required this.unitLong,
    required this.unitShort,
  });

  factory Measure.fromJson(Map<String, dynamic> json) {
    return Measure(
      amount: json['amount'] as num,
      unitLong: json['unitLong'],
      unitShort: json['unitShort'],
    );
  }
}

class WinePairing {
  final List<String> pairedWines;
  final String pairingText;
  final List<ProductMatch> productMatches;

  WinePairing({
    required this.pairedWines,
    required this.pairingText,
    required this.productMatches,
  });

  factory WinePairing.fromJson(Map<String, dynamic> json) {
    return WinePairing(
      pairedWines: List<String>.from(json['pairedWines']),
      pairingText: json['pairingText'],
      productMatches: (json['productMatches'] as List)
          .map((e) => ProductMatch.fromJson(e))
          .toList(),
    );
  }
}

class ProductMatch {
  final num id;
  final String title;
  final String description;
  final String price;
  final String imageUrl;
  final num averageRating;
  final num ratingCount;
  final num score;
  final String link;

  ProductMatch({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.averageRating,
    required this.ratingCount,
    required this.score,
    required this.link,
  });

  factory ProductMatch.fromJson(Map<String, dynamic> json) {
    return ProductMatch(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      averageRating: json['averageRating'] as num,
      ratingCount: json['ratingCount'],
      score: json['score'] as num,
      link: json['link'],
    );
  }
}
