import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _menuItems = [];

  List<Map<String, dynamic>> get menuItems => _menuItems;

  MenuProvider() {
    fetchMenuItems(); // Load data saat diinisialisasi
  }

  // Fungsi untuk mengambil data menu items dari Firestore
  Future<void> fetchMenuItems() async {
    try {
      final snapshot = await _firestore.collection('menu').get();
      _menuItems = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,       // Ambil id dokumen
          'name': data['name'],  // Ambil nama item
          'price': data['price'],  // Ambil harga item
        };
      }).toList();
      notifyListeners();  // Notifikasi perubahan data
    } catch (e) {
      print("Error fetching menu items: $e");
    }
  }

  // Fungsi untuk menambah item baru ke menu
  Future<void> addMenuItem(String name, double price) async {
    try {
      final docRef = await _firestore.collection('menu').add({
        'name': name,  // Nama item yang akan ditambahkan
        'price': price,  // Harga item yang akan ditambahkan
      });
      _menuItems.add({
        'id': docRef.id,  // Menambahkan id yang dihasilkan oleh Firestore
        'name': name,
        'price': price,
      });
      notifyListeners();  // Notifikasi perubahan data
    } catch (e) {
      print("Error adding menu item: $e");
    }
  }

  // Fungsi untuk memperbarui item menu
  Future<void> updateMenuItem(int index, String id, String name, double price) async {
    try {
      await _firestore.collection('menu').doc(id).update({
        'name': name,  // Perbarui nama item
        'price': price,  // Perbarui harga item
      });
      _menuItems[index] = {
        'id': id,       // Update item pada index yang sesuai
        'name': name,
        'price': price,
      };
      notifyListeners();  // Notifikasi perubahan data
    } catch (e) {
      print("Error updating menu item: $e");
    }
  }

  // Fungsi untuk menghapus item menu
  Future<void> deleteMenuItem(int index, String id) async {
    try {
      await _firestore.collection('menu').doc(id).delete();  // Hapus item dari Firestore
      _menuItems.removeAt(index);  // Hapus item dari list lokal
      notifyListeners();  // Notifikasi perubahan data
    } catch (e) {
      print("Error deleting menu item: $e");
    }
  }
}
