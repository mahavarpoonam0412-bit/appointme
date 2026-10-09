import 'package:flutter/material.dart';

import 'patient_home_screen.dart';
import 'clinics_screen.dart';
import 'my_appointment_screen.dart';
import 'profile_screen.dart';

class PatientNavigation extends StatefulWidget {
  const PatientNavigation({super.key});

  @override
  State<PatientNavigation> createState() =>
      _PatientNavigationState();
}

class _PatientNavigationState
    extends State<PatientNavigation> {
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
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),

      bottomNavigationBar: Container(
        height: 75,
        color: const Color(0xFF0B1F3A),

        child: Row(
          children: [
            _buildNavigationItem(
              index: 0,
              icon: Icons.home,
              label: "Home",
            ),

            _buildNavigationItem(
              index: 1,
              icon: Icons.local_hospital,
              label: "Clinics",
            ),

            _buildNavigationItem(
              index: 2,
              icon: Icons.calendar_month,
              label: "My Appointments",
            ),

            _buildNavigationItem(
              index: 3,
              icon: Icons.person,
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool selected = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            currentIndex = index;
          });
        },

        child: Container(
          height: 75,
          color: selected
              ? const Color(0xFF1565C0)
              : const Color(0xFF0B1F3A),

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              Icon(
                icon,
                size: 25,
                color: Colors.white,
              ),

              const SizedBox(height: 4),

              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}