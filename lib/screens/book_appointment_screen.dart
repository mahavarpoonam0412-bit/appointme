import 'package:flutter/material.dart';
import 'token_screen.dart';

class BookAppointmentScreen extends StatelessWidget {
  const BookAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
        title: const Text(
          "Book Appointment",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Clinic Details",
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

                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Color(0xFFE3F2FD),
                          child: Icon(
                            Icons.local_hospital,
                            color: Color(0xFF1565C0),
                            size: 30,
                          ),
                        ),

                        SizedBox(width: 15),

                        Expanded(
                          child: Text(
                            "ABC Clinic",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "👨‍⚕️ Dr. Patel",
                      style: TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "📍 Dahod",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Appointment Details",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    ListTile(
                      leading: const Icon(
                        Icons.calendar_today,
                        color: Colors.blue,
                      ),
                      title: const Text("Appointment Date"),
                      subtitle: const Text(
                        "Today - 04 September 2026",
                      ),
                    ),

                    const Divider(),

                    const ListTile(
                      leading: Icon(
                        Icons.confirmation_number,
                        color: Colors.green,
                      ),
                      title: Text("Token"),
                      subtitle: Text(
                        "Token will be generated after confirmation",
                      ),
                    ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TokenScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.check_circle),
                label: const Text(
                  "Confirm Appointment",
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