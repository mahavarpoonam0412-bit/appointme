
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'clinics_screen.dart';
import 'live_queue_screen.dart';
import 'book_appointment_screen.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login again.')),
      );
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, userSnapshot) {
        final patientName =
            userSnapshot.data?.data()?['name']?.toString() ?? 'Patient';

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FB),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0B1F3A),
            foregroundColor: Colors.white,
            title: const Text('AppointMe'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello $patientName 👋',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Find clinic and book your appointment',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    onChanged: (value) {
                      setState(() {
                        searchText = value.trim().toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search Clinic...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchText.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  searchText = '';
                                });
                              },
                              icon: const Icon(Icons.clear),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Available Clinics',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('clinics')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Unable to load clinics.',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'No clinics available.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      final clinics = snapshot.data!.docs.where((clinic) {
                        final data = clinic.data();

                        final clinicName =
                            (data['clinicName'] ?? '')
                                .toString()
                                .toLowerCase();

                        final ownerName =
                            (data['ownerName'] ?? '')
                                .toString()
                                .toLowerCase();

                        final address =
                            (data['address'] ?? '')
                                .toString()
                                .toLowerCase();

                        final speciality =
                            (data['speciality'] ?? '')
                                .toString()
                                .toLowerCase();

                        return searchText.isEmpty ||
                            clinicName.contains(searchText) ||
                            ownerName.contains(searchText) ||
                            address.contains(searchText) ||
                            speciality.contains(searchText);
                      }).toList();

                      if (clinics.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: Text(
                              'No clinic found.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: clinics.map((clinic) {
                          final data = clinic.data();

                          final clinicName =
                              (data['clinicName'] ?? 'Clinic').toString();

                          final ownerName =
                              (data['ownerName'] ?? 'Doctor').toString();

                          final qualification =
                              (data['qualification'] ?? 'Not added')
                                  .toString();

                          final speciality =
                              (data['speciality'] ?? 'Not added').toString();

                          final address =
                              (data['address'] ?? 'Address not available')
                                  .toString();

                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.local_hospital,
                                        color: Color(0xFF1565C0),
                                        size: 40,
                                      ),

                                      const SizedBox(width: 12),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              clinicName,
                                              style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            const SizedBox(height: 5),

                                            Text(
                                              ownerName,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),

                                            const SizedBox(height: 4),

                                            Text(
                                              'Qualification: $qualification',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey,
                                              ),
                                            ),

                                            const SizedBox(height: 4),

                                            Text(
                                              'Speciality: $speciality',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFF1565C0),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),

                                            const SizedBox(height: 4),

                                            Text(
                                              address,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey,
                                              ),
                                            ),

                                            const SizedBox(height: 4),

                                            const Text(
                                              'Available Today',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BookAppointmentScreen(
                                              clinicId: clinic.id,
                                              clinicName: clinicName,
                                              doctorName: ownerName,
                                              address: address,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.calendar_month),
                                      label: const Text('Book Appointment'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Your Current Appointment',
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
                      title: const Text('Token Number: 18'),
                      subtitle: const Text(
                        'Currently Serving: 14\n'
                        '4 Patients Before You',
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
                                builder: (context) =>
                                    const ClinicsScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.calendar_month),
                          label: const Text('Book Appointment'),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LiveQueueScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.queue),
                          label: const Text('Live Queue'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
