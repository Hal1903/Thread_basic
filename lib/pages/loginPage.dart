import 'package:flutter/material.dart';
import 'package:sns/components/my_button.dart';
import 'package:sns/components/squareTile.dart';
import '../components/my_textfield.dart';
import '../components/DividerPlusText.dart';
import 'package:firebase_auth/firebase_auth.dart';
// !D/EGL, !I/, !E/, !W/, !D/

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async{
    // loading circle
    print("SignIn Initiated");
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    // dealing with incorrect email or password
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    // topmost component stacked will be popped (opposite of push)
      Navigator.pop(context);
    } 
    // on FirebaseAuthException catch (e) {
    //   print('catching, the error code is "${e.code}"'); // --> add a print here
    //   Navigator.pop(context);
    //   if (e.code == 'user-not-found') {
    //     print('wrong user');
    //   }
    // }
    on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == "invalid-credential"){
        print('Invalid credential');
        errorMessage('Invalid credential');
      } else if (e.code == 'invalid-email') {
        print('Invalid Email');
        errorMessage('Invalid Email');
      }
    }
  }

  void errorMessage(String s) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.deepPurple,
            title: Center(
              child: Text(s, style: const TextStyle(color: Colors.white),),
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
              hintText: 'Username',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            // password
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
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
            // sign in
            MyButton(onTap: signIn, text: "Sign In"),
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
                  Text("Not a member? "),
                  Text(
                    "Sign Up",
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