import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 159, 8),
        title: const Text('My Profile'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Navigator.pushNamed(context, '/about');
            // Handle menu button action (e.g., open a drawer)
          },
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
            // Profile Picture
            const CircleAvatar(
              radius: 50.0,
              backgroundColor: Color.fromARGB(255, 0, 51, 2),
              // You can add an image here using backgroundImage: AssetImage(...)
            ),
            const SizedBox(height: 24.0),

            // Profile List Items
            _buildProfileListItem(Icons.person, 'Profile', () {
              Navigator.pushNamed(context, '/editprofile');
              // Handle Profile navigation
            }),
            _buildProfileListItem(Icons.privacy_tip, 'Privacy Policy', () {
              Navigator.pushNamed(context, '/privacy');
              // Handle Privacy Policy navigation
            }),
            _buildProfileListItem(Icons.settings, 'Settings', () {
              Navigator.pushNamed(context, '/setting');
              // Handle Settings navigation
            }),
            _buildProfileListItem(Icons.help, 'Help', () {
              Navigator.pushNamed(context, '/helpcenter');
              // Handle Help navigation
            }),
            _buildProfileListItem(Icons.logout, 'FeedBack', () {
              Navigator.pushNamed(context, '/feedback');
              // Handle Logout action
            }),
          ],
        ),
      ),
    );
  }

  // Helper function to build profile list items
  Widget _buildProfileListItem(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(text, style: const TextStyle(color: Colors.blue)),
      onTap: onTap,
    );
  }
}
