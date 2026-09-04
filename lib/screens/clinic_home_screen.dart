import 'package:flutter/material.dart';
import 'clinic_profile_screen.dart';

class ClinicHomeScreen extends StatefulWidget {
  const ClinicHomeScreen({super.key});

  @override
  State<ClinicHomeScreen> createState() => _ClinicHomeScreenState();
}

class _ClinicHomeScreenState extends State<ClinicHomeScreen> {
  int currentToken = 14;
  int totalPatients = 18;

  @override
  Widget build(BuildContext context) {
    int nextPatient = currentToken + 1;

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
        actions: [
  IconButton(
    icon: const Icon(Icons.person),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ClinicProfileScreen(),
        ),
      );
    },
  ),
],
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
            // Today's Queue

Card(
  elevation: 3,
  child: Padding(
    padding: const EdgeInsets.all(16),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        const Text(
          "Today's Queue",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 15),

        ListTile(
          leading: const Icon(
            Icons.confirmation_number,
            color: Colors.blue,
          ),
          title: const Text("Token 15 - Rahul"),
        ),

        ListTile(
          leading: const Icon(
            Icons.confirmation_number,
            color: Colors.blue,
          ),
          title: const Text("Token 16 - Amit"),
        ),

        ListTile(
          leading: const Icon(
            Icons.confirmation_number,
            color: Colors.blue,
          ),
          title: const Text("Token 17 - Poonam"),
        ),

        ListTile(
          leading: const Icon(
            Icons.confirmation_number,
            color: Colors.blue,
          ),
          title: const Text("Token 18 - Patient"),
        ),

      ],
    ),
  ),
),

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

                    Text(
                      "$currentToken",
                      style: const TextStyle(
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

                trailing: Text(
                  "$totalPatients",
                  style: const TextStyle(
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

                trailing: Text(
                  "Token $nextPatient",
                  style: const TextStyle(
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
                  if (currentToken < totalPatients) {
                    setState(() {
                      currentToken++;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Now serving Token $currentToken",
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "No more patients in today's queue.",
                        ),
                      ),
                    );
                  }
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