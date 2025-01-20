import 'package:emergency_system/adddriver.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'news.dart';
import 'about.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  // ignore: unused_element
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 159, 8),
        title: const Text('Admin Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.dehaze),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const About()),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
              child: const CircleAvatar(
                radius: 20,
                child: Icon(Icons.logout_rounded,
                    color: Color.fromARGB(255, 235, 9, 9)),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Full-screen background image
          Positioned.fill(
            child: Image.asset(
              'assets/s05.jpg', // Replace with your background image path
              fit: BoxFit.cover,
            ),
          ),
          // Foreground content
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: 200,
                  alignment: Alignment.topRight,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/so5.jpg'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 3, // Distance from the bottom
                        left: 25, // Distance from the left
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Text(
                            "Admin User",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _buildDashboardCard(
                          context, 'Driver', 'assets/driver.png'),
                      _buildDashboardCard(context, 'News', 'assets/news.png'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
      BuildContext context, String title, String imagePath) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          _navigateToScreen(context, title);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, String title) {
    if (title == 'Driver') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const AddDriverScreen()));
    } else if (title == 'News') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AdminNews()));
    }
  }
}
