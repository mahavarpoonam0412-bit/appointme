import 'package:flutter/material.dart';

class ClinicHomeScreen extends StatelessWidget {
  const ClinicHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
        title: const Text(
          "Clinic Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const SizedBox(height: 10),

            const Icon(
              Icons.local_hospital,
              size: 65,
              color: Colors.blue,
            ),

            const SizedBox(height: 10),

            const Text(
              "ABC Clinic",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Dr. Patel",
              style: TextStyle(
                fontSize: 17,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            // Current Token
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    const Text(
                      "Current Token",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "14",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B1F3A),
                      ),
                    ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Total Patients
            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(
                  Icons.people,
                  size: 35,
                  color: Colors.blue,
                ),
                title: const Text(
                  "Total Patients Today",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Text(
                  "18",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Next Patient
            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(
                  Icons.person,
                  size: 35,
                  color: Colors.orange,
                ),
                title: const Text(
                  "Next Patient",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Text(
                  "Token 15",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Serve Next Patient
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Next Patient: Token 15",
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.skip_next),
                label: const Text(
                  "Serve Next Patient",
                  style: TextStyle(
                    fontSize: 17,
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