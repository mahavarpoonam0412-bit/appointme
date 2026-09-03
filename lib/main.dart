import 'package:flutter/material.dart';

void main() {
  runApp(const AppointMe());
}

class AppointMe extends StatelessWidget {
  const AppointMe({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        
        backgroundColor: const Color(0xFF0B1F3A),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/WhatsApp Image 2026-08-21 at 7.27.27 PM.jpeg',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 20),

              const Text(
                'AppointMe',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Smart Clinic Appointment',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}