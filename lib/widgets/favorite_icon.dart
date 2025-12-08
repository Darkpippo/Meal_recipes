import 'package:flutter/material.dart';
import '../models/favorite_meal.dart';
import '../services/firebase_service.dart';

class FavoriteIcon extends StatefulWidget {
  final String mealId;
  final String mealName;
  final String mealThumb;

  const FavoriteIcon({
    super.key,
    required this.mealId,
    required this.mealName,
    required this.mealThumb,
  });

  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  bool _isFavorite = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final isFav = await FirebaseService.isFavorite(widget.mealId);
    if (!mounted) return;
    setState(() {
      _isFavorite = isFav;
    });
  }

  Future<void> _toggleFavorite() async {
    if (_loading) return;
    setState(() => _loading = true);

    if (_isFavorite) {
      await FirebaseService.removeFavorite(widget.mealId);
    } else {
      final fav = FavoriteMeal(
        idMeal: widget.mealId,
        strMeal: widget.mealName,
        strMealThumb: widget.mealThumb,
        addedDate: DateTime.now(),
      );
      await FirebaseService.addFavorite(fav);
    }

    if (!mounted) return;
    setState(() {
      _isFavorite = !_isFavorite;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return GestureDetector(
      onTap: _toggleFavorite,
      child: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: _isFavorite ? Colors.red : Colors.white,
        size: 28,
      ),
    );
  }
}
