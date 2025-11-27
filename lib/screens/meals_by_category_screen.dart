import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../widgets/meal_grid_item.dart';

class MealsByCategoryScreen extends StatefulWidget {
  final String categoryName;

  MealsByCategoryScreen({required this.categoryName});

  @override
  _MealsByCategoryScreenState createState() => _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  late Future<List<Meal>> futureMeals;
  List<Meal> allMeals = [];
  List<Meal> filteredMeals = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureMeals = ApiService.getMealsByCategory(widget.categoryName);
    futureMeals.then((meals) {
      setState(() {
        allMeals = meals;
        filteredMeals = meals;
      });
    });
  }

  void filterMeals(String query) async {
    if (query.isEmpty) {
      setState(() {
        filteredMeals = allMeals;
      });
    } else {
      final searchResults = await ApiService.searchMeals(query);
      setState(() {
        filteredMeals = searchResults;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Пребарај јадење...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: filterMeals,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Meal>>(
              future: futureMeals,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Грешка: ${snapshot.error}'));
                } else {
                  return GridView.builder(
                    padding: EdgeInsets.all(12),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filteredMeals.length,
                    itemBuilder: (ctx, i) => MealGridItem(
                      meal: filteredMeals[i],
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
