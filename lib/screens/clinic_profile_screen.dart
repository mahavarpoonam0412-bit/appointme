import 'package:flutter/material.dart';
import 'clinic_edit_profile_screen.dart';

class ClinicProfileScreen extends StatelessWidget {

  const ClinicProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
        title: const Text(
          "Clinic Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.local_hospital,
                size: 55,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 25),

            Card(
              child: ListTile(
                leading: const Icon(Icons.local_hospital),
                title: const Text(
                  "Clinic Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("ABC Clinic"),
              ),
            ),


            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text(
                  "Doctor Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Dr. Patel"),
              ),
            ),


            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text(
                  "Address",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Dahod"),
              ),
            ),


            const SizedBox(height:25),


            SizedBox(
              width: double.infinity,
              height:50,

              child: ElevatedButton(

                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ClinicEditProfileScreen(),
                    ),
                  );

                },

                child: const Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontSize:17,
                  ),
                ),
              ),
            ),


            const SizedBox(height:15),


            SizedBox(
              width: double.infinity,
              height:50,

              child: ElevatedButton(

                onPressed: () {

                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );

                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),

                child: const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize:17,
                  ),
                ),

              ),
            ),

          ],
        ),
      ),
    );
  }
}