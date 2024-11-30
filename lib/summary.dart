import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart.dart';

class Summary extends StatelessWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Summary",
          style: TextStyle(color: Colors.brown, fontSize: 30),
        ),
        backgroundColor: Colors.brown[50],
        elevation: 0,
        toolbarHeight: 100,
      ),
      body: cart.items.isEmpty
          ? const Center(
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
            child: Image.asset('assets/image.png'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                ...cart.items.map(
                  (item) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(
                        item.name,
                        style: const TextStyle(color: Colors.brown, fontSize: 20),
                      ),
                      subtitle: Text(
                        "Size: ${item.size} | Sugar: ${item.sugar}% | Quantity: ${item.quantity}",
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          cart.removeItemAt(cart.items.indexOf(item));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${item.name} removed from cart!"),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                summaryDisplay("Total", "\$${cart.totalPrice.toStringAsFixed(2)}"),
                summaryDisplay("Tax", "\$${(cart.totalPrice * 0.1).toStringAsFixed(2)}"),
                summaryDisplay("Discount", "\$0.00"),
                const SizedBox(height: 50),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => showPaymentChoiceDialog(context, cart),
            child: submitButton("Pay"),
          ),
          const SizedBox(height: 20),
          // Menampilkan nama pengguna dan nomor telepon yang melakukan pembayaran
          if (cart.user != null && cart.phoneNumber != null)
            Text(
              "Paid by: ${cart.user} | ${cart.phoneNumber}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget summaryDisplay(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.brown, fontSize: 20)),
        Text(value, style: const TextStyle(color: Colors.brown, fontSize: 20)),
      ],
    );
  }

  Widget submitButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.brown,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 20)),
    );
  }

  void showPaymentChoiceDialog(BuildContext context, CartModel cart) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Choose Payment Method"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Direct Cash"),
                onTap: () {
                  _showUserDetailsDialog(context, cart, "Direct Cash");
                },
              ),
              ListTile(
                title: const Text("Bank Transfer"),
                onTap: () {
                  Navigator.pop(context);
                  _showBankTransferInstructions(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showUserDetailsDialog(BuildContext context, CartModel cart, String paymentMethod) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Your Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text;
                final phoneNumber = phoneController.text;
                cart.setPaymentMethod(paymentMethod);
                cart.setUser(name, phoneNumber); // Set name and phone number
                Navigator.pop(context); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Payment successful!")),
                );
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void _showBankTransferInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Bank Transfer Instructions"),
          content: const Text("Transfer to account 123-456-789. Include your name in the reference."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
