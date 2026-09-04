import 'package:flutter/material.dart';

import 'patient_home_screen.dart';
import 'clinics_screen.dart';
import 'my_appointment_screen.dart';
import 'profile_screen.dart';

class PatientNavigation extends StatefulWidget {
  const PatientNavigation({super.key});

  @override
  State<PatientNavigation> createState() => _PatientNavigationState();
}

class _PatientNavigationState extends State<PatientNavigation> {

  int currentIndex = 0;

  final List<Widget> screens = [
    const PatientHomeScreen(),
    const ClinicsScreen(),
    const MyAppointmentScreen(),
    const ProfileScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: screens[currentIndex],

      bottomNavigationBar: SafeArea(
  child: BottomNavigationBar(
    currentIndex: currentIndex,

    type: BottomNavigationBarType.fixed,

    backgroundColor: Colors.white,

    selectedItemColor: const Color(0xFF0B1F3A),

    unselectedItemColor: Colors.grey,

    iconSize: 28,

    selectedFontSize: 13,

    unselectedFontSize: 12,

    onTap: (index) {
      setState(() {
        currentIndex = index;
      });
    },

    items: const [

      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: "Home",
      ),

      BottomNavigationBarItem(
        icon: Icon(Icons.local_hospital),
        label: "Clinics",
      ),

      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_month),
        label: "Appointment",
      ),

      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: "Profile",
      ),

       ],
      ),
     ),
    );
  }
} 