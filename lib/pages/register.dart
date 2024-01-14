import 'package:flutter/material.dart';
import 'package:sns/components/my_button.dart';
import 'package:sns/components/squareTile.dart';
import '../components/my_textfield.dart';
import '../components/DividerPlusText.dart';
import 'package:firebase_auth/firebase_auth.dart';
// !D/EGL, !I/, !E/, !W/, !D/

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();
  
  void signUp() async{
    // loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    // dealing with incorrect email or password
    print("${passwordController.text} and ${passwordController2.text}");
    try {
      if (passwordController.text == passwordController2.text){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.pop(context);
      } else {
        //print("NOT MATCHED ERROR");
        Navigator.pop(context);
        errorMessage('Password not matched');
      }
      
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      errorMessage(e.code);
    }
  }


  void errorMessage(String s) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.deepPurple,
            title: Center(
              child: Text(
                s,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
            // logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
            const SizedBox(height: 50),
            // text
            Text(
              "Welcome Back",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
              ),
              const SizedBox(height: 25),
            // username
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            // password
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 10),
            MyTextField(
              controller: passwordController2,
              hintText: 'Confirm Password',
              obscureText: true,
            ),
            // forgot pass
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot Password",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            // sign up
            MyButton(onTap: signUp, text:"Sign Up"),
            const SizedBox(height: 25),
            
            // continue with
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: DividerPlusText(text: "or continue with"),
            ),
            
            const SizedBox(height: 40),
            
            // google and apple sign in
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // google 
                SquareTile(imagePath: './lib/images/google2.png', h: 56),
                // space
                SizedBox(width: 25),
                // apple
                SquareTile(imagePath: './lib/images/apple2.png', h: 56),
              ],
            ),
            // register
            const SizedBox(height: 50),
            GestureDetector(
              onTap: widget.onTap,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Log in",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                ],
              ),
            ),
            
              ],
            ),
          ),
        ),
      ),
      
    );
  }
}