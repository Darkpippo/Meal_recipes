class FavoriteMeal {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;
  final DateTime addedDate;

  FavoriteMeal({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    required this.addedDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'idMeal': idMeal,
      'strMeal': strMeal,
      'strMealThumb': strMealThumb,
      'addedDate': addedDate.toIso8601String(),
    };
  }

  factory FavoriteMeal.fromJson(Map<String, dynamic> json) {
    return FavoriteMeal(
      idMeal: json['idMeal'] as String,
      strMeal: json['strMeal'] as String,
      strMealThumb: json['strMealThumb'] as String,
      addedDate: DateTime.parse(json['addedDate'] as String),
    );
  }
}
