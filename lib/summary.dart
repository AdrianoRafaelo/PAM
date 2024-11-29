import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart.dart'; // Ganti dengan path file model Cart Anda

class Summary extends StatelessWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Summary",
          style: TextStyle(
            color: Colors.brown,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.brown[50],
        elevation: 0,
        toolbarHeight: 100,
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Text(
                "Your cart is empty!",
                style: TextStyle(color: Colors.brown, fontSize: 20),
              ),
            )
          : content(context, cart),
    );
  }

  Widget content(BuildContext context, CartModel cart) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            child: Image.asset('assets/image.png'), // Ganti dengan path gambar Anda
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                ...cart.items.map(
                  (item) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(
                        item.name,
                        style: TextStyle(color: Colors.brown, fontSize: 20),
                      ),
                      subtitle: Text(
                        "Size: ${item.size} | Sugar: ${item.sugar}% | Quantity: ${item.quantity}",
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          cart.removeItemAt(cart.items.indexOf(item));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${item.name} removed from cart!"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Divider(color: Colors.brown),
                SizedBox(height: 20),
                summaryDisplay("Total", "\$${cart.totalPrice.toStringAsFixed(2)}"),
                summaryDisplay("Tax", "\$${(cart.totalPrice * 0.1).toStringAsFixed(2)}"),
                summaryDisplay("Discount", "\$0.00"),
                SizedBox(height: 50),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              showPaymentChoiceDialog(context, cart); // Tampilkan dialog pilihan pembayaran
            },
            child: submitButton("Pay"),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget summaryDisplay(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.brown,
            fontSize: 20,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.brown,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget submitButton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.brown,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  Future<void> showPaymentChoiceDialog(BuildContext context, CartModel cart) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose Payment Method"),
          content: Text("How would you like to pay?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                processCashPayment(context, cart); // Proses pembayaran tunai
              },
              child: Text("Pay Directly"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                showTransferInstructions(context, cart); // Tampilkan instruksi transfer
              },
              child: Text("Transfer"),
            ),
          ],
        );
      },
    );
  }

  void processCashPayment(BuildContext context, CartModel cart) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Processing cash payment..."),
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment successful! Thank you for paying directly."),
          duration: Duration(seconds: 3),
        ),
      );

      cart.clearCart(); // Bersihkan keranjang setelah pembayaran berhasil
    });
  }

  Future<void> showTransferInstructions(BuildContext context, CartModel cart) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Bank Transfer Instructions"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Please transfer the amount of \$${cart.totalPrice.toStringAsFixed(2)} to the following account:",
              ),
              SizedBox(height: 10),
              Text(
                "Bank: XYZ Bank\nAccount No: 123-456-789\nAccount Name: Flutter Store",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Transfer instructions sent."),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
