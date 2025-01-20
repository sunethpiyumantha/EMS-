import 'package:emergency_system/ambulance.dart';
import 'package:emergency_system/call.dart';
import 'package:emergency_system/home.dart';
import 'package:emergency_system/location.dart';
import 'package:emergency_system/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Declare the list of screens for navigation
  final List<Widget> _screens = [
    const HomeScreen(), // Home screen
    const LocationScreen(), // Location screen
    const EmergencyCallScreen(),
    const Ambulance(), // Ambulance screen
    const ProfileScreen(), // Profile screen
  ];

  // Current active index for the bottom navigation
  int activeIndex = 0;

  // Method to handle item tap
  void onItemTapped(int i) {
    setState(() {
      activeIndex = i; // Update the active screen index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[activeIndex], // Display the currently selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: activeIndex, // Highlight the active tab
        onTap: onItemTapped, // Handle tab selection
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        unselectedItemColor: const Color.fromARGB(255, 227, 6, 6),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/home.svg',
              width: 24,
              height: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/location.svg',
              width: 24,
              height: 24,
            ),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/phone.svg',
              width: 50,
              height: 50,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/ambulance.svg',
              width: 24,
              height: 24,
            ),
            label: 'Ambulance',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/profile.svg',
              width: 24,
              height: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
