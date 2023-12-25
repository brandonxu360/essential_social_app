import 'package:essential_app/components/my_button.dart';
import 'package:essential_app/components/my_textfield.dart';
import 'package:essential_app/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text field controllers
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  // Login method
  void login() async {
    // Display loading circle
    showDialog(
        context: context,
        builder: (context) => Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            )));

    // Try to sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      // Pop loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseException catch (e) {
      // Pop loading circle
      if (context.mounted) Navigator.pop(context);

      // Display error message
      if (context.mounted) displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),

              const SizedBox(height: 25),

              // App name
              const Text(
                'E S S E N T I A L',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 50),

              // Email text field
              MyTextField(
                  hintText: 'Email',
                  obscureText: false,
                  controller: emailController),

              const SizedBox(height: 10),

              // Password text field
              MyTextField(
                  hintText: 'Password',
                  obscureText: true,
                  controller: passwordController),

              const SizedBox(height: 10),

              // Forgot password
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Forgot Password?'),
                ],
              ),

              const SizedBox(height: 25),

              // Sign in button
              MyButton(label: 'Login', onTap: login),

              const SizedBox(height: 25),

              // Register option
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?'),
                  GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        ' Register',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
