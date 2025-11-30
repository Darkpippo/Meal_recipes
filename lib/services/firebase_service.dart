import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/favorite_meal.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> get _favoritesCollection =>
      _firestore.collection('favorites');

  static Future<void> addFavorite(FavoriteMeal meal) async {
    try {
      print('Adding favorite ${meal.idMeal}');
      await _favoritesCollection.doc(meal.idMeal).set(meal.toJson());
      print('Favorite added');
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }

  static Future<void> removeFavorite(String mealId) async {
    try {
      print('Removing favorite $mealId');
      await _favoritesCollection.doc(mealId).delete();
      print('Favorite removed');
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

  static Future<bool> isFavorite(String mealId) async {
    try {
      final doc = await _favoritesCollection.doc(mealId).get();
      print('isFavorite $mealId: ${doc.exists}');
      return doc.exists;
    } catch (e) {
      print('Error checking favorite: $e');
      return false;
    }
  }

  static Stream<List<FavoriteMeal>> getFavoritesStream() {
    return _favoritesCollection
        .orderBy('addedDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => FavoriteMeal.fromJson(doc.data()))
          .toList(),
    );
  }
}
