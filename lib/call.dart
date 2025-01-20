import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import for making calls

class EmergencyCallScreen extends StatelessWidget {
  const EmergencyCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB05E5E), // Background color
      body: Center(
        child: ElevatedButton(
          onPressed: _makeEmergencyCall, // Call function on press
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(30),
          ),
          child: const Icon(
            Icons.call,
            size: 40,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  // Function to make the emergency call
  Future<void> _makeEmergencyCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '1990', // Replace with your country's emergency number
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // Handle error: Could not launch the URL
      print('Could not launch emergency call');
      // You might want to show a Snackbar or Dialog to the user
    }
  }
}
