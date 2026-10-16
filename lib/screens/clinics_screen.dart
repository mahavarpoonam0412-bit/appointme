import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'book_appointment_screen.dart';

class ClinicsScreen extends StatefulWidget {
  const ClinicsScreen({super.key});

  @override
  State<ClinicsScreen> createState() => _ClinicsScreenState();
}

class _ClinicsScreenState extends State<ClinicsScreen> {
  String searchText = "";

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
            TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("clinics")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No clinics available.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  final clinics = snapshot.data!.docs.where((doc) {
                    final data =
                        doc.data() as Map<String, dynamic>;

                    final clinicName =
                        (data["clinicName"] ?? "")
                            .toString()
                            .toLowerCase();

                    final address =
                        (data["address"] ?? "")
                            .toString()
                            .toLowerCase();

                    return clinicName.contains(searchText) ||
                        address.contains(searchText);
                  }).toList();

                  if (clinics.isEmpty) {
                    return const Center(
                      child: Text(
                        "No clinic found.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: clinics.length,
                    itemBuilder: (context, index) {
                      final data =
                          clinics[index].data()
                              as Map<String, dynamic>;

                      final clinicName =
                          (data["clinicName"] ?? "Clinic")
                              .toString();

                      final ownerName =
                          (data["ownerName"] ?? "")
                              .toString();

                      final qualification =
    (data["qualification"] ?? "Qualification not added").toString();

final speciality =
    (data["speciality"] ?? "Speciality not added").toString();
debugPrint("Clinic Data: $data");
debugPrint("Qualification: $qualification");
debugPrint("Speciality: $speciality");
                      final address =
                          (data["address"] ?? "Address not available")
                              .toString();

                      return Card(
                        elevation: 3,
                        margin:
                            const EdgeInsets.only(bottom: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 28,
                                    backgroundColor:
                                        Color(0xFFE3F2FD),
                                    child: Icon(
                                      Icons.local_hospital,
                                      color:
                                          Color(0xFF1565C0),
                                      size: 30,
                                    ),
                                  ),

                                  const SizedBox(width: 15),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Text(
                                          clinicName,
                                          style:
                                              const TextStyle(
                                            fontSize: 20,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 5),

                                        Text(
  ownerName,
  style: const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  ),
),

const SizedBox(height: 5),

Text(
  "Qualification: $qualification",
  style: const TextStyle(
    fontSize: 13,
    color: Colors.grey,
  ),
),

const SizedBox(height: 4),

Text(
  "Speciality: $speciality",
  style: const TextStyle(
    fontSize: 13,
    color: Color(0xFF1565C0),
    fontWeight: FontWeight.w500,
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
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 15),

                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 20,
                                    color: Colors.grey,
                                  ),

                                  const SizedBox(width: 5),

                                  Expanded(
                                    child: Text(
                                      address,
                                      style:
                                          const TextStyle(
                                        color: Colors.grey,
                                      ),
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
                                        builder: (context) =>
                                            BookAppointmentScreen(
                                              clinicId: clinics[index].id,
                                              clinicName: clinicName,
                                              doctorName: ownerName,
                                              address: address,
                                           ),
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
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}