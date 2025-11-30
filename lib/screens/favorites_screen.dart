import 'package:flutter/material.dart';
import '../models/favorite_meal.dart';
import '../models/meal.dart';
import '../services/firebase_service.dart';
import '../widgets/meal_grid_item.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Омилени рецепти'),
      ),
      body: StreamBuilder<List<FavoriteMeal>>(
        stream: FirebaseService.getFavoritesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final favorites = snapshot.data ?? [];

          if (favorites.isEmpty) {
            return const Center(
              child: Text('Немаш додадено омилени рецепти.'),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final fav = favorites[index];
              final meal = Meal(
                idMeal: fav.idMeal,
                strMeal: fav.strMeal,
                strMealThumb: fav.strMealThumb,
              );
              return MealGridItem(meal: meal);
            },
          );
        },
      ),
    );
  }
}
