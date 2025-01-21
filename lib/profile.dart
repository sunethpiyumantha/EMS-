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
              // You can add an image here using backgroundImage: AssetImage(...),
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
            _buildProfileListItem(Icons.feedback, 'Feedback', () {
              Navigator.pushNamed(context, '/showfeed');
            }),
          ],
        ),
      ),
    );
  }

  // Helper function to build profile list items with a card-like design
  Widget _buildProfileListItem(IconData icon, String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(icon, color: Colors.blue),
              ),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
