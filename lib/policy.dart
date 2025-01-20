import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 54, 244, 139),
        title: const Text('Privacy Policy'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button action (e.g., Navigator.pop(context))
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification button action
            },
          ),
        ],
      ),
      body: const SingleChildScrollView(
        // Make content scrollable
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last updated: MM/DD/YYYY', // Replace with actual date
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                // Replace with your actual privacy policy content
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                'Praesent pellentesque congue lorem, vel tincidunt tortor '
                'placerat a. Proin orci diam quam. Aenean in sagittis magna, '
                'ut feugiat diam. Fusce ac ipsum eros. Maecenas semper '
                'ultricies lorem, sed accumsan mi.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 24.0),
              Text(
                'Terms & Conditions',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                // Replace with your actual terms and conditions content
                '1. Ut ac pretium odio. Donec viverra, '
                'enim sit amet pretium sodales, arcu eros '
                'malesuada mauris, eu pharetra eros eros vitae '
                'orci. Morbi pellentesque malesuada eros semper '
                'ultricies. Vestibulum lobortis nisi vel neque '
                'auctor, ultricies orci a. Mauris ut lacinia '
                'justo, sed suscipit tortor. Nam egestas nulla '
                'posuere neque tincidunt porta.\n\n'
                // ... add more terms and conditions ...
                ,
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
