import 'package:emergency_system/about.dart';
import 'package:emergency_system/adddriver.dart';
import 'package:emergency_system/editprofile.dart';
import 'package:emergency_system/helpcenter.dart';
import 'package:emergency_system/home.dart';
import 'package:emergency_system/hospitalMap.dart';
import 'package:emergency_system/login.dart';
import 'package:emergency_system/news.dart';
import 'package:emergency_system/passmgt.dart';
import 'package:emergency_system/passwordreset.dart';
import 'package:emergency_system/pharmacyMap.dart';
import 'package:emergency_system/privacy.dart';
import 'package:emergency_system/profileseting.dart';
import 'package:emergency_system/registration.dart';
import 'package:emergency_system/setting.dart';
import 'package:emergency_system/showfeedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:emergency_system/welcome.dart';
import 'profile.dart';
import 'package:emergency_system/feedback.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/registration': (context) => const RegistrationScreen(),
        '/home': (context) => const HomeScreen(),
        '/profiles': (context) => const ProfileScreen(),
        '/privacy': (context) => const PrivacyPolicyScreen(),
        '/setting': (context) => const SettingsScreen(),
        '/helpcenter': (context) => const HelpCenterScreen(),
        '/passmgt': (context) => const PasswordManagerScreen(),
        '/feedback': (context) => const FeedbackPage(
              driverName: '',
              senderUsername: '',
            ),
        '/about': (context) => const About(),
        '/news': (context) => const NewsScreen(),
        '/reset': (context) => Passwordreset(),
        '/profileset': (context) => const UserProfileScreen(),
        '/editprofile': (context) => const ProfileEdit(),
        '/adddriver': (context) => const AddDriverScreen(),
        '/hospitalmap': (context) => const HospitalMap(),
        '/pharmacymap': (context) => const PharmacyMap(),
        '/showfeed': (context) => const ShowFeedback(
              driverName: '',
              senderUsername: '',
            ),
      },
    );
  }
}
