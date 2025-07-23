import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/eco_action_screen.dart';
import 'screens/educational_hub_screen.dart';
import 'screens/rewards_screen.dart';
import '/screens/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import
import 'services/auth_service.dart'; // Add this import
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const LeafPrintApp());
}

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/dashboard': (context) => const DashboardScreen(),
  '/eco-action': (context) => const EcoActionScreen(),
  '/learn': (context) => const EducationalHubScreen(),
  '/rewards': (context) => const RewardsScreen(),
  '/profile': (context) => const ProfileScreen(),
  EducationalHubScreen.routeName: (context) => const EducationalHubScreen(),
  RewardsScreen.routeName: (context) => const RewardsScreen(),
};

class LeafPrintApp extends StatelessWidget {
  const LeafPrintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LeafPrint',
      debugShowCheckedModeBanner: false,
      // Remove initialRoute and routes
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/register':
            return MaterialPageRoute(builder: (context) => const RegisterScreen());
          case '/dashboard':
            return MaterialPageRoute(builder: (context) => const DashboardScreen());
          case '/eco-action':
            return MaterialPageRoute(builder: (context) => const EcoActionScreen());
          case '/learn':
            return MaterialPageRoute(builder: (context) => const EducationalHubScreen());
          case '/rewards':
            return MaterialPageRoute(builder: (context) => const RewardsScreen());
          case '/profile':
            return MaterialPageRoute(builder: (context) => const ProfileScreen());
          default:
            return MaterialPageRoute(builder: (context) => const LoginScreen());
        }
      },
      theme: ThemeData(
        primaryColor: const Color(0xFF4CAF50),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          primary: const Color(0xFF4CAF50),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4CAF50)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: StreamBuilder<User?>(
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return const DashboardScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
