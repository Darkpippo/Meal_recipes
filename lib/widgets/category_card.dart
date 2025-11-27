import 'package:flutter/material.dart';
import '../models/category.dart';
import '../screens/meals_by_category_screen.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        leading: Image.network(
          category.strCategoryThumb,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(
          category.strCategory,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          category.strCategoryDescription,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MealsByCategoryScreen(
                categoryName: category.strCategory,
              ),
            ),
          );
        },
      ),
    );
  }
}
