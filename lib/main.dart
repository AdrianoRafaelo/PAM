import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'cart.dart';
import 'details.dart';
import 'menu.dart';
import 'summary.dart';
import 'auth/login.dart';
import 'auth/register.dart';
import 'firebase_options.dart';
import 'MenuProvider.dart';
import 'admin_page.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartModel()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => LoginPage());
          case '/menu':
            return MaterialPageRoute(builder: (_) => Menu());
          case '/details':
            try {
              final arguments = settings.arguments as Map<String, dynamic>;
              final name = arguments['name'] as String;
              final basePrice = arguments['basePrice'] as double;
              return MaterialPageRoute(
                builder: (_) => Details(name: name, basePrice: basePrice),
              );
            } catch (e) {
              return MaterialPageRoute(
                builder: (_) => Scaffold(
                  body: Center(
                    child: Text('Error: Invalid arguments for Details page'),
                  ),
                ),
              );
            }
          case '/summary':
            return MaterialPageRoute(builder: (_) => Summary());
          case '/admin':
            return MaterialPageRoute(builder: (_) => AdminPage());
          case '/register':
            return MaterialPageRoute(builder: (_) => RegisterPage());
          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(
                  child: Text(
                    '404: Page Not Found',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}
