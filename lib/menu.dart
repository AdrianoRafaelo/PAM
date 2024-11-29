import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:learning/summary.dart';
import 'details.dart';
import 'MenuProvider.dart';
import 'auth/login.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Welcome",
          style: TextStyle(
            color: Colors.brown,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.brown[50],
        toolbarHeight: 100,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.brown),
            onPressed: () {
              // Tampilkan dialog konfirmasi logout
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Tutup dialog
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.brown),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Logout dan kembali ke halaman login
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text(
                          "Logout",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: menuProvider.menuItems.isEmpty
          ? Center(
              child: Text(
                "No items available!",
                style: TextStyle(fontSize: 20, color: Colors.brown),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Favorite",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: menuProvider.menuItems.length,
                        itemBuilder: (context, index) {
                          final item = menuProvider.menuItems[index];
                          return favoriteItem(item);
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Recommended",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: menuProvider.menuItems.length,
                      itemBuilder: (context, index) {
                        final item = menuProvider.menuItems[index];
                        return recommendedItem(item, context);
                      },
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ""),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Summary()),
            );
          }
        },
      ),
    );
  }

  Widget favoriteItem(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/coffee_cup.png',
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item['name'],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text("\$${item['price']}"),
        ],
      ),
    );
  }

  Widget recommendedItem(Map<String, dynamic> item, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/coffee_cup.png',
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            item['name'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("\$${item['price']}"),
          trailing: IconButton(
            icon: const Icon(Icons.keyboard_arrow_right),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Details(
                    name: item['name'],
                    basePrice: item['price'],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
