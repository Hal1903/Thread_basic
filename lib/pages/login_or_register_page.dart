import 'package:flutter/material.dart';
import 'package:sns/pages/loginPage.dart';
import './register.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  // initially login page
  bool showLoginPage = true;

  // toggle b/w login and register
  void toggle(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return LoginPage(onTap: toggle,);
    }
    else {
      return RegisterPage(onTap: toggle,);
    }
  }
}