import 'package:flutter/material.dart';

class MyAppointmentScreen extends StatelessWidget {
  const MyAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
        title: const Text(
          "My Appointment",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Current Appointment",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "🏥 ABC Clinic",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "👨‍⚕️ Dr. Patel",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),

                    const Divider(),

                    const Text(
                      "📅 Appointment Date: 04 September 2026",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "🎫 Token Number: 18",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Live Queue Status",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Card(
              elevation: 3,
              child: ListTile(

                leading: const Icon(
                  Icons.queue,
                  color: Colors.blue,
                  size: 35,
                ),

                title: const Text(
                  "Currently Serving: Token 14",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: const Text(
                  "4 Patients Before You",
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Previous Appointment History",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: ListTile(
                leading: const Icon(Icons.history),

                title: const Text(
                  "ABC Clinic",
                ),

                subtitle: const Text(
                  "Completed - 20 August 2026",
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}