import 'package:flutter/material.dart';

class ClinicEditProfileScreen extends StatelessWidget {
  const ClinicEditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              decoration: InputDecoration(
                labelText: "Clinic Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height:20),

            TextField(
              decoration: InputDecoration(
                labelText: "Doctor Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height:20),

            TextField(
              decoration: InputDecoration(
                labelText: "Clinic Address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height:30),

            SizedBox(
              width: double.infinity,
              height:50,

              child: ElevatedButton(

                onPressed: () {

                  Navigator.pop(context);

                },

                child: const Text(
                  "Save Changes",
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