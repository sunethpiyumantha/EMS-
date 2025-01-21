import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact and About'),
        backgroundColor: const Color.fromARGB(255, 0, 159, 8),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CONTACT DETAILS SECTION
            Text(
              "CONTACT DETAILS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Divider(thickness: 2),
            SizedBox(height: 8),
            Text(
              "+94 112054128",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              "+94 712054128",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              "emergencymedicale@gmail.com",
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
            SizedBox(height: 24),

            // ABOUT SECTION
            Text(
              "ABOUT",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Divider(thickness: 2),
            SizedBox(height: 8),

            // VISION SECTION
            Text(
              "Vision of the EMS Locator App",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "To revolutionize emergency medical response by providing instant access to critical healthcare services, reducing response times, and ensuring the safety and well-being of every individual in need.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // MISSION SECTION
            Text(
              "Mission of the EMS Locator App",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Our mission is to provide a user-friendly platform for quick access to nearby medical facilities during emergencies, leveraging GPS and real-time data. We aim to enhance emergency response efficiency, ensure accessibility for all, prioritize data security, and collaborate with healthcare providers to build a reliable, scalable system that saves lives",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 40),

            // VERSION INFO
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.settings,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  "Version 1.0.0",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
