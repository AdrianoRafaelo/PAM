import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart.dart';

class Details extends StatefulWidget {
  final String name;
  final double basePrice;

  const Details({required this.name, required this.basePrice, super.key});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int _quantity = 1;
  String _selectedSize = 'Medium';
  int _selectedSugar = 0;
  String _selectedTemperature = 'Hot';

  final Map<String, double> sizePrice = {
    'Small': 0.0,
    'Medium': 1000.0,
    'Large': 1500.0,
  };

  final Map<String, double> temperaturePrice = {
    'Hot': 0.0,
    'Cold': 2000.0,
  };

  double get totalPrice {
    // Mengonversi semua operasi ke tipe double untuk memastikan konsistensi
    double basePrice = widget.basePrice;
    double sizeAddition = sizePrice[_selectedSize] ?? 0.0;
    double tempAddition = temperaturePrice[_selectedTemperature] ?? 0.0;

    // Perhitungan total dengan faktor quantity
    return basePrice + sizeAddition + tempAddition + (basePrice * 0.1 * (_quantity - 1).toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gambar utama
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/coffee_cup.png',
                  height: 220,
                  width: 220,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Informasi produk
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "\$${widget.basePrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Rating (dummy)
                  Row(
                    children: List.generate(
                      4,
                      (index) => const Icon(Icons.star, color: Colors.amber, size: 20),
                    )..add(
                        const Icon(Icons.star_half, color: Colors.amber, size: 20),
                      ),
                  ),
                  const SizedBox(height: 16),

                  // Deskripsi produk
                  const Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                    "Suspendisse faucibus placerat neque, vel luctus orci.",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Pilihan ukuran
                  const Text(
                    "Size",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSizeOption("Small"),
                      _buildSizeOption("Medium"),
                      _buildSizeOption("Large"),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Pilihan jumlah gula
                  const Text(
                    "Sugar",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _buildSugarOptions(),
                  ),
                  const SizedBox(height: 24),

                  // Pilihan suhu
                  const Text(
                    "Temperature",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTemperatureOption("Hot"),
                      _buildTemperatureOption("Cold"),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Kontrol jumlah produk
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Quantity",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, color: Colors.brown),
                            onPressed: () {
                              setState(() {
                                if (_quantity > 1) _quantity--;
                              });
                            },
                          ),
                          Text(
                            "$_quantity",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.brown),
                            onPressed: () {
                              setState(() {
                                if (_quantity < 10) _quantity++;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Total harga
                  Center(
                    child: Text(
                      "Total: \$${totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tombol tambah ke keranjang
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        final cart = Provider.of<CartModel>(
                          context,
                          listen: false,
                        );

                        cart.addItem(
                          CartItem(
                            name: widget.name,
                            quantity: _quantity,
                            price: totalPrice,
                            size: _selectedSize,
                            sugar: _selectedSugar,
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "$_quantity ${widget.name} added to cart!",
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.brown,
                          ),
                        );
                      },
                      child: const Text(
                        "Add to cart",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeOption(String size) {
    return GestureDetector(
      onTap: () => setState(() => _selectedSize = size),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: _selectedSize == size ? Colors.brown : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          size,
          style: TextStyle(
            color: _selectedSize == size ? Colors.white : Colors.brown,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildTemperatureOption(String temperature) {
    return GestureDetector(
      onTap: () => setState(() => _selectedTemperature = temperature),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: _selectedTemperature == temperature
              ? Colors.brown
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          temperature,
          style: TextStyle(
            color: _selectedTemperature == temperature
                ? Colors.white
                : Colors.brown,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSugarOptions() {
    const sugarOptions = [0, 25, 50, 100];
    return sugarOptions.map((sugar) {
      return GestureDetector(
        onTap: () => setState(() => _selectedSugar = sugar),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: _selectedSugar == sugar ? Colors.brown : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "$sugar%",
            style: TextStyle(
              color: _selectedSugar == sugar ? Colors.white : Colors.brown,
              fontSize: 16,
            ),
          ),
        ),
      );
    }).toList();
  }
}
