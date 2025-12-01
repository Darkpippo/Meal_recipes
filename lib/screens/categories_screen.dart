import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';
import 'meal_detail_screen.dart';
import 'favorites_screen.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late Future<List<Category>> futureCategories;
  List<Category> allCategories = [];
  List<Category> filteredCategories = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureCategories = ApiService.getCategories();
    futureCategories.then((categories) {
      setState(() {
        allCategories = categories;
        filteredCategories = categories;
      });
    });
  }

  void filterCategories(String query) {
    setState(() {
      filteredCategories = allCategories
          .where((cat) =>
          cat.strCategory.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _openRandomMeal() async {
    final randomMeal = await ApiService.getRandomMeal();
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MealDetailScreen(mealId: randomMeal.idMeal),
      ),
    );
  }

  void _openFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const FavoritesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Категории на рецепти'),
        actions: [
          IconButton(
            tooltip: 'Рандом рецепт',
            icon: const Icon(Icons.casino),
            onPressed: _openRandomMeal,
          ),
          IconButton(
            tooltip: 'Омилени рецепти',
            icon: const Icon(Icons.favorite),
            onPressed: _openFavorites,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Пребарај категорија...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: filterCategories,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Category>>(
              future: futureCategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Грешка: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                    itemCount: filteredCategories.length,
                    itemBuilder: (ctx, i) => CategoryCard(
                      category: filteredCategories[i],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
