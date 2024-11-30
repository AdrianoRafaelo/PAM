import 'package:flutter/foundation.dart';

class CartItem {
  final String name; // Nama produk
  final int quantity; // Jumlah produk
  final double price; // Harga produk
  final String size; // Ukuran produk
  final int sugar; // Tingkat gula

  CartItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.size,
    required this.sugar,
  });
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];
  String? _paymentMethod; // Menyimpan metode pembayaran
  String? _user; // Nama pengguna yang melakukan pembayaran
  String? _phoneNumber; // Nomor telepon pengguna yang melakukan pembayaran

  List<CartItem> get items => _items;
  String? get paymentMethod => _paymentMethod;
  String? get user => _user; // Getter untuk pengguna
  String? get phoneNumber => _phoneNumber; // Getter untuk nomor telepon

  void setUser(String userName, String userPhoneNumber) {
    _user = userName; // Set nama pengguna
    _phoneNumber = userPhoneNumber; // Set nomor telepon pengguna
    notifyListeners();
  }

  void addItem(CartItem item) {
    _items.add(item); 
    notifyListeners();
  }

  void removeItemAt(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index); 
      notifyListeners();
    }
  }

  double get totalPrice {
    return _items.fold(0.0, (double sum, CartItem item) {
      return sum + item.price * item.quantity;
    });
  }

  void clearCart() {
    _items.clear(); 
    _paymentMethod = null; // Reset metode pembayaran
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method; 
    notifyListeners();
  }
}
