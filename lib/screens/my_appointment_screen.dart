import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAppointmentScreen extends StatefulWidget {
  const MyAppointmentScreen({super.key});

  @override
  State<MyAppointmentScreen> createState() =>
      _MyAppointmentScreenState();
}

class _MyAppointmentScreenState
    extends State<MyAppointmentScreen> {
  bool isLoading = true;

  Map<String, dynamic>? currentAppointment;
  int currentServing = 0;
  int patientsBeforeYou = 0;

  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    loadAppointments();
  }

  int getInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? "") ?? 0;
  }

  String todayDate() {
    final now = DateTime.now();

    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  String formatDate(String date) {
    try {
      final parts = date.split("-");

      if (parts.length == 3) {
        return "${parts[2]} ${monthName(int.parse(parts[1]))} ${parts[0]}";
      }
    } catch (_) {}

    return date;
  }

  String monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    if (month < 1 || month > 12) {
      return "";
    }

    return months[month - 1];
  }

  DateTime getCreatedAt(Map<String, dynamic> appointment) {
    final createdAt = appointment["createdAt"];

    if (createdAt is Timestamp) {
      return createdAt.toDate();
    }

    return DateTime(2000);
  }

  Future<void> loadAppointments() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final today = todayDate();

      final snapshot = await FirebaseFirestore.instance
          .collection("appointments")
          .where(
            "patientId",
            isEqualTo: user.uid,
          )
          .get();

      List<Map<String, dynamic>> allAppointments = [];

      for (final doc in snapshot.docs) {
        final data = doc.data();

        allAppointments.add({
          ...data,
          "documentId": doc.id,
        });
      }

      // --------------------------------------------------
      // TODAY KI WAITING APPOINTMENTS
      // --------------------------------------------------

      List<Map<String, dynamic>> waitingAppointments =
          allAppointments.where((appointment) {
        final appointmentDate =
            appointment["appointmentDate"]?.toString() ?? "";

        final status =
            appointment["status"]?.toString().toLowerCase() ?? "";

        return appointmentDate == today &&
            status == "waiting";
      }).toList();

      // IMPORTANT:
      // Highest token nahi,
      // LAST BOOKED APPOINTMENT select hoga.
      waitingAppointments.sort((a, b) {
        return getCreatedAt(b).compareTo(
          getCreatedAt(a),
        );
      });

      Map<String, dynamic>? activeAppointment;

      if (waitingAppointments.isNotEmpty) {
        activeAppointment = waitingAppointments.first;
      }

      int servingToken = 0;
      int beforeYou = 0;

      // --------------------------------------------------
      // SELECTED / LATEST APPOINTMENT KA QUEUE
      // --------------------------------------------------

      if (activeAppointment != null) {
        final clinicId =
            activeAppointment["clinicId"]?.toString() ?? "";

        final myToken =
            getInt(activeAppointment["token"]);

        if (clinicId.isNotEmpty) {
          // Clinic ka current token
          final clinicDoc = await FirebaseFirestore.instance
              .collection("clinics")
              .doc(clinicId)
              .get();

          if (clinicDoc.exists) {
            final clinicData =
                clinicDoc.data() ?? {};

            servingToken =
                getInt(clinicData["currentToken"]);
          }

          // Agar currentToken available nahi hai
          // to completed/served appointments se calculate
          if (servingToken == 0) {
            final clinicAppointments =
                await FirebaseFirestore.instance
                    .collection("appointments")
                    .where(
                      "clinicId",
                      isEqualTo: clinicId,
                    )
                    .get();

            for (final doc in clinicAppointments.docs) {
              final data = doc.data();

              if (data["appointmentDate"]?.toString() !=
                  today) {
                continue;
              }

              final status =
                  data["status"]?.toString().toLowerCase() ?? "";

              if (status == "completed" ||
                  status == "served") {
                final token =
                    getInt(data["token"]);

                if (token > servingToken) {
                  servingToken = token;
                }
              }
            }
          }

          // Is selected clinic ke kitne patients
          // mere token se pehle hain
          final clinicAppointments =
              await FirebaseFirestore.instance
                  .collection("appointments")
                  .where(
                    "clinicId",
                    isEqualTo: clinicId,
                  )
                  .get();

          for (final doc in clinicAppointments.docs) {
            final data = doc.data();

            if (data["appointmentDate"]?.toString() !=
                today) {
              continue;
            }

            final status =
                data["status"]?.toString().toLowerCase() ?? "";

            final token =
                getInt(data["token"]);

            if (status == "waiting" &&
                token > servingToken &&
                token < myToken) {
              beforeYou++;
            }
          }
        }
      }

      // --------------------------------------------------
      // PREVIOUS HISTORY
      // --------------------------------------------------

      List<Map<String, dynamic>> previousAppointments =
          allAppointments.where((appointment) {
        final appointmentDate =
            appointment["appointmentDate"]?.toString() ?? "";

        final status =
            appointment["status"]?.toString().toLowerCase() ?? "";

        return appointmentDate != today ||
            status == "completed" ||
            status == "served";
      }).toList();

      previousAppointments.sort((a, b) {
        return getCreatedAt(b).compareTo(
          getCreatedAt(a),
        );
      });

      setState(() {
        currentAppointment = activeAppointment;
        currentServing = servingToken;
        patientsBeforeYou = beforeYou;
        history = previousAppointments;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("My Appointment Error: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Unable to load appointments: $e",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
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
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
        actions: [
          IconButton(
            onPressed: loadAppointments,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: loadAppointments,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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

              if (currentAppointment == null)
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        children: const [
                          Icon(
                            Icons.event_busy,
                            size: 50,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "No current appointment",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Book an appointment to see it here.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          "🏥 ${currentAppointment!["clinicName"] ?? "Clinic"}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "👨‍⚕️ ${currentAppointment!["doctorName"] ?? "Doctor"}",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),

                        const Divider(),

                        Text(
                          "📅 Appointment Date: ${formatDate(currentAppointment!["appointmentDate"]?.toString() ?? "")}",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          "🎫 Token Number: ${getInt(currentAppointment!["token"])}",
                          style: const TextStyle(
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

              if (currentAppointment != null)
                Card(
                  elevation: 3,
                  child: ListTile(
                    leading: const Icon(
                      Icons.queue,
                      color: Colors.blue,
                      size: 35,
                    ),
                    title: Text(
                      "Currently Serving: Token $currentServing",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "$patientsBeforeYou Patients Before You",
                    ),
                  ),
                )
              else
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "No live queue available.",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
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

              if (history.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        "No previous appointments.",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                )
              else
                Column(
                  children: history.map((appointment) {
                    final clinic =
                        appointment["clinicName"]
                                ?.toString() ??
                            "Clinic";

                    final date =
                        appointment["appointmentDate"]
                                ?.toString() ??
                            "";

                    final rawStatus =
                        appointment["status"]
                                ?.toString() ??
                            "completed";

                    final status =
                        rawStatus.isEmpty
                            ? "Completed"
                            : rawStatus[0].toUpperCase() +
                                rawStatus.substring(1);

                    return Card(
                      child: ListTile(
                        leading:
                            const Icon(Icons.history),
                        title: Text(
                          clinic,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "$status - ${formatDate(date)}",
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}