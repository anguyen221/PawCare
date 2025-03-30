import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'add_pet_screen.dart';
import 'pet_details_screen.dart';
import 'illness_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Care App',
      initialRoute: '/',
      routes: {
        '/': (context) => _getInitialScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomeScreen(),
        '/addPet': (context) => AddPetScreen(),
        '/petDetail': (context) => PetDetailsScreen(),
        '/illnessSymptoms': (context) => IllnessScreen(),
      },
    );
  }

  Widget _getInitialScreen() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}
