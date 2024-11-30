import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MenuProvider.dart';
import 'cart.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final cartProvider = Provider.of<CartModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        backgroundColor: Colors.brown,
        actions: [
          IconButton(
            icon: const Icon(Icons.payment),
            onPressed: () {
              _showPaymentReports(context, cartProvider);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: menuProvider.menuItems.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: menuProvider.menuItems.length,
              itemBuilder: (context, index) {
                final item = menuProvider.menuItems[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text("Price: \$${item['price']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditDialog(
                            context,
                            menuProvider,
                            index,
                            item['id'],
                            item['name'],
                            item['price'],
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          menuProvider.deleteMenuItem(index, item['id']);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context, menuProvider);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.brown,
      ),
    );
  }

  void _showPaymentReports(BuildContext context, CartModel cart) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Payment Reports"),
          content: cart.items.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("User: ${cart.user ?? 'Unknown'}"), // Menampilkan pengguna
                    Text("Phone Number: ${cart.phoneNumber ?? 'Unknown'}"), // Menampilkan nomor telepon
                    Text("Payment Method: ${cart.paymentMethod ?? 'Unknown'}"),
                    Text("Total Items: ${cart.items.length}"),
                    Text("Total Price: \$${cart.totalPrice.toStringAsFixed(2)}"),
                  ],
                )
              : const Text("No payment reports available."),
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

  void _showAddDialog(BuildContext context, MenuProvider menuProvider) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Menu Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
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
                final price = double.tryParse(priceController.text) ?? 0.0;
                menuProvider.addMenuItem(name, price);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, MenuProvider menuProvider, int index, String id, String name, double price) {
    final nameController = TextEditingController(text: name);
    final priceController = TextEditingController(text: price.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Menu Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
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
                final updatedName = nameController.text;
                final updatedPrice = double.tryParse(priceController.text) ?? 0.0;
                menuProvider.updateMenuItem(index, id, updatedName, updatedPrice);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.of(context).pushReplacementNamed('/'); // Redirect to login page
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  // Function to manually set user name and phone number
  void _showUserDetailsDialog(BuildContext context, CartModel cart) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter User Details"),
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
                final phone = phoneController.text;
                cart.setUser(name, phone); // Save name and phone
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
