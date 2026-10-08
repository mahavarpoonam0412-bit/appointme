import 'package:flutter/material.dart';

class TokenScreen extends StatelessWidget {
  final int tokenNumber;
  final String clinicName;
  final String doctorName;
  final String appointmentDate;

  const TokenScreen({
    super.key,
    required this.tokenNumber,
    required this.clinicName,
    required this.doctorName,
    required this.appointmentDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
        title: const Text(
          "Appointment Confirmed",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80,
              ),

              const SizedBox(height: 15),

              const Text(
                "Appointment Confirmed!",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              Card(
                elevation: 4,

                child: Padding(
                  padding: const EdgeInsets.all(25),

                  child: Column(
                    children: [

                      const Text(
                        "Your Token Number",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "$tokenNumber",
                        style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B1F3A),
                        ),
                      ),

                      const Divider(),

                      const SizedBox(height: 10),

                      Text(
                        clinicName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        doctorName,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        "📅 Appointment Date: $appointmentDate",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Text(
                "Your Token: $tokenNumber",
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Please wait for your turn.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: const Text(
                    "Back to Clinics",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}