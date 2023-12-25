import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essential_app/components/my_button.dart';
import 'package:essential_app/components/my_textfield.dart';
import 'package:essential_app/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text field controllers
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Create a user credential and collect in Firestore
  Future<void> createUserDocument(UserCredential? UserCredential) async {
    if (UserCredential != null && UserCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(UserCredential.user!.email)
          .set({
        'email': UserCredential.user!.email,
        'username': usernameController.text
      });
    }
  }

  // Register method
  void registerUser() async {
    // Show loading circle
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ));

    // Ensure passwords match
    if (passwordController.text != confirmPasswordController.text) {
      // Pop loading circle
      Navigator.pop(context);

      // Display error message to user
      displayMessageToUser('Passwords do not match', context);
    }

    // Try to create the user
    else {
      try {
        // Create the user
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        // Create a user document and add to firestore
        createUserDocument(userCredential);

        // Pop loading circle
        if (context.mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // Pop loading circle
        if (context.mounted) Navigator.pop(context);

        // Display error message to user
        if (context.mounted) displayMessageToUser(e.code, context);
      }
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

              MyTextField(
                  hintText: 'Username',
                  obscureText: false,
                  controller: usernameController),

              const SizedBox(height: 10),

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

              // Confirm password  text field
              MyTextField(
                  hintText: 'Confirm Password',
                  obscureText: true,
                  controller: confirmPasswordController),

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
              MyButton(label: 'Register', onTap: registerUser),

              const SizedBox(height: 25),

              // Register option
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Have have an account?'),
                  GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        ' Login',
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
