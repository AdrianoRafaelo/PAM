import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _menuItems = [];

  List<Map<String, dynamic>> get menuItems => _menuItems;

  MenuProvider() {
    fetchMenuItems(); // Load data saat diinisialisasi
  }

  Future<void> fetchMenuItems() async {
    try {
      final snapshot = await _firestore.collection('menu').get();
      _menuItems = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'],
          'price': data['price'],
        };
      }).toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching menu items: $e");
    }
  }

  Future<void> addMenuItem(String name, double price) async {
    try {
      final docRef = await _firestore.collection('menu').add({
        'name': name,
        'price': price,
      });
      _menuItems.add({
        'id': docRef.id,
        'name': name,
        'price': price,
      });
      notifyListeners();
    } catch (e) {
      print("Error adding menu item: $e");
    }
  }

  Future<void> updateMenuItem(int index, String id, String name, double price) async {
    try {
      await _firestore.collection('menu').doc(id).update({
        'name': name,
        'price': price,
      });
      _menuItems[index] = {
        'id': id,
        'name': name,
        'price': price,
      };
      notifyListeners();
    } catch (e) {
      print("Error updating menu item: $e");
    }
  }

  Future<void> deleteMenuItem(int index, String id) async {
    try {
      await _firestore.collection('menu').doc(id).delete();
      _menuItems.removeAt(index);
      notifyListeners();
    } catch (e) {
      print("Error deleting menu item: $e");
    }
  }
}
