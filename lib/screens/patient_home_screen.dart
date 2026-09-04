import 'package:flutter/material.dart';
import 'clinics_screen.dart';
import 'live_queue _screen.dart';
class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        title: const Text(
          "AppointMe",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "Hello Patient 👋",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Find clinic and book your appointment",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 20),

              // Search Clinic
              TextField(
                decoration: InputDecoration(
                  hintText: "Search Clinic...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Available Clinics",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Clinic Card
              Card(
                elevation: 3,
                child: ListTile(
                  leading: const Icon(
                    Icons.local_hospital,
                    color: Colors.blue,
                    size: 40,
                  ),
                  title: const Text("ABC Clinic"),
                  subtitle: const Text(
                    "Dahod\nAvailable Today",
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
    MaterialPageRoute(
      builder: (context) => const ClinicsScreen(),
    ),
  );
},
                    child: const Text("Book"),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Your Current Appointment",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Card(
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(
                    Icons.confirmation_number,
                    color: Colors.green,
                    size: 40,
                  ),
                  title: const Text("Token Number: 18"),
                  subtitle: const Text(
                    "Currently Serving: 14\n4 Patients Before You",
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Row(
                children: [

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ClinicsScreen(),
    ),
  );
},
                      icon: const Icon(Icons.calendar_month),
                      label: const Text("Book Appointment"),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const LiveQueueScreen(),
    ),
  );
},
                      icon: const Icon(Icons.queue),
                      label: const Text("Live Queue"),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
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
            label: "My Appointments",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),

        ],
      ),
    );
  }
}