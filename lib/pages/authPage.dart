import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homePage.dart';
import 'login_or_register_page.dart';
/*
Purpose: signed in -> display home page
         otherwise -> display login page again
*/

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
// constantly taking the state of FirebaseAuth.instance
        stream: FirebaseAuth.instance.authStateChanges(),
        builder:(context, snapshot) {
// if authenticated state detected by ontap, return HomePage
          if (snapshot.hasData){
            return HomePage();
          } else {
// if not, display LoginPage
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}