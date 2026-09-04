import 'package:flutter/material.dart';
import 'screens/clinic_home_screen.dart';
void main() {
  runApp(const AppointMe());
}

class AppointMe extends StatelessWidget {
  const AppointMe({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ClinicHomeScreen(),
    );
  }
}