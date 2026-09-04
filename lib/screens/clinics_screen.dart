import 'package:flutter/material.dart';
import 'book_appointment_screen.dart';

class ClinicsScreen extends StatelessWidget {
  const ClinicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
        title: const Text(
          "Clinics",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // Search Clinic
            TextField(
              decoration: InputDecoration(
                hintText: "Search Clinic...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [

                  // Clinic 1
                  Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 28,
                                backgroundColor: Color(0xFFE3F2FD),
                                child: Icon(
                                  Icons.local_hospital,
                                  color: Color(0xFF1565C0),
                                  size: 30,
                                ),
                              ),

                              const SizedBox(width: 15),

                              const Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ABC Clinic",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    SizedBox(height: 5),

                                    Text(
                                      "Dr. Patel",
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Icon(
                                Icons.circle,
                                color: Colors.green,
                                size: 12,
                              ),

                              const SizedBox(width: 5),

                              const Text(
                                "Available",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          const Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 20,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Dahod",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BookAppointmentScreen(),
                                    ),
                                 );
                               },
                              icon: const Icon(
                                Icons.calendar_month,
                              ),
                              label: const Text(
                                "Book Appointment",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Clinic 2
                  Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 28,
                                backgroundColor: Color(0xFFE3F2FD),
                                child: Icon(
                                  Icons.local_hospital,
                                  color: Color(0xFF1565C0),
                                  size: 30,
                                ),
                              ),

                              const SizedBox(width: 15),

                              const Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "City Clinic",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    SizedBox(height: 5),

                                    Text(
                                      "Dr. Sharma",
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Icon(
                                Icons.circle,
                                color: Colors.green,
                                size: 12,
                              ),

                              const SizedBox(width: 5),

                              const Text(
                                "Available",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          const Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 20,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Dahod",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BookAppointmentScreen(),
                                  ),
                                 );
                                },
                              icon: const Icon(
                                Icons.calendar_month,
                              ),
                              label: const Text(
                                "Book Appointment",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}