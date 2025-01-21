import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red, // Red app bar color
        title: const Text('Privacy Policy'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/news');
            },
          ),
        ],
      ),
      body: const SingleChildScrollView(
        // Add SingleChildScrollView for scrollable content
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last updated: 22/01/2025', // Replace with actual last updated date
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
                'At EMS Locator, we prioritize your privacy and are committed to safeguarding your personal information. This Privacy Policy outlines how we collect, use, share, and protect your data when you use our application. We collect information such as your name, email address, and phone number when you register, as well as your location data to provide emergency services and display nearby medical facilities. Additionally, we may gather app usage data, including device type and operating system, to enhance functionality and user experience.\n Your information is used to provide core app functionalities, such as locating medical facilities, facilitating real-time location sharing during emergencies, and delivering notifications. We do not sell or rent your personal data to third parties. However, we may share your information with emergency service providers to ensure timely response or comply with legal obligations. \n To protect your data, we employ advanced encryption and secure storage methods, though no system can guarantee absolute security.You have the right to access, update, or request the deletion of your data at any time. Should you wish to opt out of certain data practices, please contact us for assistance. This Privacy Policy may be updated periodically, and we encourage you to review it regularly to stay informed about how your data is managed. For questions or concerns, contact us at emergencymedical@gmail.com.',
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
                'By using the EMS Locator App, you agree to these terms and conditions. The app is designed to assist users in locating nearby medical facilities during emergencies. You are expected to use the app responsibly, ensuring that all information you provide is accurate and that your usage complies with applicable laws. The app must not be used for any illegal or harmful activities.\n While EMS Locator strives to provide reliable and accurate information, we are not liable for any direct, indirect, or consequential damages arising from the use of the app. This includes inaccuracies in third-party data, such as the availability of medical facilities or services. All content and materials in the app are the intellectual property of EMS Locator and must not be reproduced or distributed without authorization.',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
