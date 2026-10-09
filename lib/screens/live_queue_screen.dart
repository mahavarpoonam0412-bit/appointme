import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveQueueScreen extends StatefulWidget {
  const LiveQueueScreen({super.key});

  @override
  State<LiveQueueScreen> createState() => _LiveQueueScreenState();
}

class _LiveQueueScreenState extends State<LiveQueueScreen> {
  bool isLoading = true;

  String clinicName = "Clinic";
  String doctorName = "Doctor";
  String address = "Address not available";

  int yourToken = 0;
  int currentServing = 0;

  List<int> waitingTokens = [];

  @override
  void initState() {
    super.initState();
    loadLiveQueue();
  }

  int getInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(
          value?.toString() ?? "0",
        ) ??
        0;
  }

  DateTime getCreatedAt(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    final createdAt = data["createdAt"];

    if (createdAt is Timestamp) {
      return createdAt.toDate();
    }

    return DateTime(2000);
  }

  Future<void> loadLiveQueue() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("Patient is not logged in.");
      }

      // Patient ki saari appointments
      final snapshot = await FirebaseFirestore.instance
          .collection("appointments")
          .where(
            "patientId",
            isEqualTo: user.uid,
          )
          .get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Sirf waiting appointments
      final waitingAppointments =
          snapshot.docs.where((doc) {
        final data = doc.data();

        final status =
            data["status"]?.toString().toLowerCase() ?? "";

        return status == "waiting";
      }).toList();

      if (waitingAppointments.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Sabse latest booked appointment
      waitingAppointments.sort((a, b) {
        return getCreatedAt(b).compareTo(
          getCreatedAt(a),
        );
      });

      final latestAppointment =
          waitingAppointments.first;

      final appointmentData =
          latestAppointment.data();

      final clinicId =
          appointmentData["clinicId"]?.toString() ?? "";

      yourToken =
          getInt(appointmentData["token"]);

      if (clinicId.isEmpty) {
        throw Exception(
          "Clinic information not found.",
        );
      }

      // Selected/latest clinic ki details
      final clinicDoc = await FirebaseFirestore.instance
          .collection("clinics")
          .doc(clinicId)
          .get();

      if (!clinicDoc.exists) {
        throw Exception("Clinic not found.");
      }

      final clinicData =
          clinicDoc.data() ?? {};

      clinicName =
          clinicData["clinicName"]?.toString() ??
              "Clinic";

      doctorName =
          clinicData["ownerName"]?.toString() ??
              "Doctor";

      address =
          clinicData["address"]?.toString() ??
              "Address not available";

      // Clinic ka current serving token
      currentServing =
          getInt(clinicData["currentToken"]);

      // Aaj ki date
      final now = DateTime.now();

      final today =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      // Agar currentToken nahi mila,
      // completed/served appointments se find karo
      if (currentServing == 0) {
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

          final appointmentDate =
              data["appointmentDate"]?.toString() ?? "";

          final status =
              data["status"]?.toString().toLowerCase() ?? "";

          if (appointmentDate == today &&
              (status == "completed" ||
                  status == "served")) {
            final token =
                getInt(data["token"]);

            if (token > currentServing) {
              currentServing = token;
            }
          }
        }
      }

      // Selected clinic ke aaj ke waiting tokens
      final clinicAppointments =
          await FirebaseFirestore.instance
              .collection("appointments")
              .where(
                "clinicId",
                isEqualTo: clinicId,
              )
              .get();

      waitingTokens = [];

      for (final doc in clinicAppointments.docs) {
        final data = doc.data();

        final appointmentDate =
            data["appointmentDate"]?.toString() ?? "";

        final status =
            data["status"]?.toString().toLowerCase() ?? "";

        final token =
            getInt(data["token"]);

        if (appointmentDate == today &&
            status == "waiting" &&
            token > currentServing) {
          waitingTokens.add(token);
        }
      }

      waitingTokens.sort();

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint(
        "Live Queue Error: $e",
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Unable to load live queue: $e",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor:
            const Color(0xFFF5F7FB),
        appBar: AppBar(
          backgroundColor:
              const Color(0xFF0B1F3A),
          foregroundColor: Colors.white,
          title: const Text(
            "Live Queue",
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

    if (yourToken == 0) {
      return Scaffold(
        backgroundColor:
            const Color(0xFFF5F7FB),
        appBar: AppBar(
          backgroundColor:
              const Color(0xFF0B1F3A),
          foregroundColor: Colors.white,
          title: const Text(
            "Live Queue",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: loadLiveQueue,
          child: ListView(
            children: const [
              SizedBox(height: 180),
              Icon(
                Icons.queue,
                size: 70,
                color: Colors.blue,
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "No active appointment found.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Text(
                  "Book an appointment to view the live queue.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final beforeYou = waitingTokens
        .where(
          (token) =>
              token < yourToken &&
              token > currentServing,
        )
        .length;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
        title: const Text(
          "Live Queue",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: loadLiveQueue,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: loadLiveQueue,

        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              const SizedBox(height: 15),

              const Icon(
                Icons.queue,
                size: 70,
                color: Colors.blue,
              ),

              const SizedBox(height: 15),

              Text(
                clinicName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                doctorName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                address,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 25),

              // TOKEN CARD
              Card(
                elevation: 4,
                child: Padding(
                  padding:
                      const EdgeInsets.all(22),

                  child: Column(
                    children: [
                      const Text(
                        "Your Token",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        "$yourToken",
                        style: const TextStyle(
                          fontSize: 55,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              Color(0xFF0B1F3A),
                        ),
                      ),

                      const Divider(),

                      const SizedBox(height: 15),

                      const Text(
                        "Currently Serving",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        "$currentServing",
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight:
                              FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // BEFORE YOU
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(18),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceAround,
                    children: [
                      Column(
                        children: [
                          const Icon(
                            Icons.people,
                            size: 32,
                            color:
                                Colors.orange,
                          ),

                          const SizedBox(
                            height: 5,
                          ),

                          Text(
                            "$beforeYou",
                            style:
                                const TextStyle(
                              fontSize: 25,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const Text(
                            "Before You",
                          ),
                        ],
                      ),

                      Column(
                        children: [
                          const Icon(
                            Icons
                                .confirmation_number,
                            size: 32,
                            color: Colors.blue,
                          ),

                          const SizedBox(
                            height: 5,
                          ),

                          Text(
                            "$yourToken",
                            style:
                                const TextStyle(
                              fontSize: 25,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const Text(
                            "Your Token",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Align(
                alignment:
                    Alignment.centerLeft,
                child: Text(
                  "Queue",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // QUEUE
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading:
                          const CircleAvatar(
                        backgroundColor:
                            Colors.green,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      title: const Text(
                        "Currently Serving",
                      ),
                      trailing: Text(
                        "$currentServing",
                        style:
                            const TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    if (waitingTokens.isEmpty)
                      const Padding(
                        padding:
                            EdgeInsets.all(20),
                        child: Text(
                          "No patients waiting.",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),

                    ...waitingTokens.map(
                      (token) {
                        final isMyToken =
                            token == yourToken;

                        return Column(
                          children: [
                            const Divider(
                              height: 1,
                            ),

                            ListTile(
                              leading:
                                  CircleAvatar(
                                backgroundColor:
                                    isMyToken
                                        ? const Color(
                                            0xFF0B1F3A)
                                        : Colors
                                            .blue
                                            .shade100,

                                child: Text(
                                  "$token",
                                  style: TextStyle(
                                    color: isMyToken
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),

                              title: Text(
                                isMyToken
                                    ? "Your Token"
                                    : "Token $token",
                                style: TextStyle(
                                  fontWeight:
                                      isMyToken
                                          ? FontWeight
                                              .bold
                                          : FontWeight
                                              .normal,
                                ),
                              ),

                              trailing:
                                  isMyToken
                                      ? const Text(
                                          "You",
                                          style:
                                              TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                            color: Color(
                                              0xFF0B1F3A,
                                            ),
                                          ),
                                        )
                                      : null,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Please wait for your turn.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}