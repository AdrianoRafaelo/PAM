import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
 const LoginPage({super.key});

 @override
 _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
 final TextEditingController emailController = TextEditingController();
 final TextEditingController passwordController = TextEditingController();

 Future<void> _login() async {
   final email = emailController.text.trim();
   final password = passwordController.text.trim();

   if (email.isEmpty || password.isEmpty) {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Email dan Kata Sandi tidak boleh kosong!')),
     );
     return;
   }

   try {
     UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
       email: email,
       password: password,
     );

     final userDoc = await FirebaseFirestore.instance
         .collection('users')
         .doc(userCredential.user!.uid)
         .get();

     if (userDoc.exists) {
       final userData = userDoc.data() as Map<String, dynamic>;
       final userRole = userData['role'] ?? 'customer';

       if (userRole == 'admin') {
         Navigator.of(context).pushReplacementNamed("/admin");
       } else {
         Navigator.of(context).pushReplacementNamed("/menu");
       }
     } else {
       Navigator.of(context).pushReplacementNamed("/menu");
     }

   } on FirebaseAuthException catch (e) {
     String errorMessage;
     if (e.code == 'user-not-found') {
       errorMessage = 'Pengguna tidak ditemukan!';
     } else if (e.code == 'wrong-password') {
       errorMessage = 'Kata sandi salah!';
     } else {
       errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
     }

     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text(errorMessage)),
     );
   } catch (e) {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Terjadi kesalahan yang tidak diketahui')),
     );
   }
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.brown[50],
     body: Center(
       child: SingleChildScrollView(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Padding(
               padding: const EdgeInsets.all(20.0),
               child: Image.asset('assets/logo.png'),
             ),
             SizedBox(height: 30),
             Text(
               "CAFFEINATED",
               style: TextStyle(
                 color: Colors.brown,
                 fontSize: 45,
                 fontStyle: FontStyle.italic,
               ),
             ),
             SizedBox(height: 50),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 40.0),
               child: TextField(
                 controller: emailController,
                 decoration: InputDecoration(
                   labelText: "Email",
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(10),
                   ),
                 ),
               ),
             ),
             SizedBox(height: 20),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 40.0),
               child: TextField(
                 controller: passwordController,
                 obscureText: true,
                 decoration: InputDecoration(
                   labelText: "Kata Sandi",
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(10),
                   ),
                 ),
               ),
             ),
             SizedBox(height: 40),
             GestureDetector(
               onTap: _login,
               child: Container(
                 height: 50,
                 width: 150,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(20),
                   color: Colors.brown,
                 ),
                 child: Center(
                   child: Text(
                     "Masuk",
                     style: TextStyle(
                       color: Colors.white,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                 ),
               ),
             ),
             SizedBox(height: 20),
             GestureDetector(
               onTap: () => Navigator.of(context).pushNamed("/register"),
               child: Text(
                 "Belum punya akun? Daftar",
                 style: TextStyle(
                   color: Colors.brown,
                   decoration: TextDecoration.underline,
                 ),
               ),
             ),
           ],
         ),
       ),
     ),
   );
 }

 @override
 void dispose() {
   emailController.dispose();
   passwordController.dispose();
   super.dispose();
 }
}
