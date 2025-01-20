// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  Future<void> _registerUser(BuildContext context, String username,
      String email, String password) async {
    try {
      // Create user with Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user details to Firestore
      await FirebaseFirestore.instance
          .collection('user')
          .doc(userCredential.user?.uid)
          .set({
        'username': username,
        'email': email,
        'createdAt': DateTime.now(),
      });

      // Navigate to login screen or main screen on success
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Registration successful!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Close the dialog
                Navigator.pushNamed(context, '/login'); // Navigate to login
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'email-already-in-use') {
        message = 'This email is already registered.';
      } else if (e.code == 'weak-password') {
        message = 'Password should be at least 6 characters.';
      } else {
        message = 'Registration failed. Please try again.';
      }
      _showErrorDialog(context, message);
    } catch (e) {
      _showErrorDialog(context, 'An unexpected error occurred.');
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      // Initialize Google Sign-In
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Check if the user exists in Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(userCredential.user?.uid)
          .get();

      if (!userDoc.exists) {
        // Save new user details to Firestore
        await FirebaseFirestore.instance
            .collection('user')
            .doc(userCredential.user?.uid)
            .set({
          'username': userCredential.user?.displayName ?? 'Google User',
          'email': userCredential.user?.email,
          'createdAt': DateTime.now(),
        });
      }

      // Navigate to the main screen
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      _showErrorDialog(context, 'Google Sign-In failed. Please try again.');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(0, 49, 163, 4), // Transparent app bar
        elevation: 0, // No shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_circle_left_outlined,
              color: Color(0xFF30C702)),
          iconSize: 40, // Black back arrow
          onPressed: () {
            Navigator.pop(context); // Handle back button action
          },
        ),
      ),
      extendBodyBehindAppBar: true, // Extend body behind app bar
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/s05.jpg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Hello!',
                  style: TextStyle(
                    fontSize: 42.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Create an account',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          hintText: 'User Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email ID',
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: () {
                          final username = usernameController.text.trim();
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();

                          if (username.isEmpty ||
                              email.isEmpty ||
                              password.isEmpty) {
                            _showErrorDialog(
                                context, 'All fields are required.');
                          } else {
                            _registerUser(context, username, email, password);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF30C702),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          textStyle: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        child: const Text('REGISTER'),
                      ),
                      const SizedBox(height: 24.0),
                      const Text(
                        'OR',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => _signInWithGoogle(context),
                            child: const CircleAvatar(
                              radius: 20.0,
                              backgroundImage: AssetImage('assets/goo.png'),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          _buildSocialLoginButton('assets/facebook.png'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                const Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 17, 0),
                          decoration: TextDecoration.underline,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton(String imagePath) {
    return GestureDetector(
      onTap: () {
        // Handle social login button action
      },
      child: CircleAvatar(
        radius: 20.0,
        backgroundImage: AssetImage(imagePath),
      ),
    );
  }
}
