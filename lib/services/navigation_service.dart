import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../screens/eco_action_screen.dart';
import '../screens/educational_hub_screen.dart';

class NavigationService {
  static int _currentIndex = 0;

  static final List<Widget> _screens = [
    const DashboardScreen(),
    const EcoActionScreen(),
    const Center(child: Text('Rewards')), // Placeholder for Rewards screen
    const EducationalHubScreen(),
    const Center(child: Text('Profile')), // Placeholder for Profile screen
  ];

  static Widget getCurrentScreen() {
    return _screens[_currentIndex];
  }

  static void updateIndex(int index) {
    _currentIndex = index;
  }

  static int getCurrentIndex() {
    return _currentIndex;
  }
}