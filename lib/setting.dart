import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/news');
              // Handle notification button action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Password Manager Setting
            ListTile(
              leading: const Icon(Icons.password, color: Colors.blue),
              title: const Text('Password Manager',
                  style: TextStyle(color: Colors.blue)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
              onTap: () {
                Navigator.pushNamed(context, '/passmgt');
                // Handle navigation to Password Manager screen
                // Navigator.pushNamed(context, '/passwordManager');
              },
            ),
            // Add more settings items here as needed
          ],
        ),
      ),
    );
  }
}
