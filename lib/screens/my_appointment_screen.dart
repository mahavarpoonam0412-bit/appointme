
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAppointmentScreen extends StatelessWidget {
  const MyAppointmentScreen({super.key});

  int getInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  String todayDate() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  String formatDate(String date) {
    final parts = date.split('-');
    if (parts.length != 3) return date;

    const months = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];

    final month = int.tryParse(parts[1]) ?? 0;
    if (month < 1 || month > 12) return date;

    return '${parts[2]} ${months[month - 1]} ${parts[0]}';
  }

  String statusText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'served':
        return 'Completed';
      case 'waiting':
        return 'Waiting';
      default:
        return status.isEmpty ? 'Unknown' : status;
    }
  }

  Color statusColor(String status) {
    final value = status.toLowerCase();
    if (value == 'completed' || value == 'served') {
      return Colors.green;
    }
    if (value == 'waiting') return Colors.orange;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in again.')),
      );
    }

    final today = todayDate();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
        title: const Text(
          'My Appointment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('patientId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text('Unable to load appointments:\n${snapshot.error}'),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final appointments = snapshot.data!.docs.toList();

          appointments.sort((a, b) {
            final aTime = a.data()['createdAt'];
            final bTime = b.data()['createdAt'];

            final aDate =
                aTime is Timestamp ? aTime.toDate() : DateTime(2000);
            final bDate =
                bTime is Timestamp ? bTime.toDate() : DateTime(2000);

            return bDate.compareTo(aDate);
          });

         final currentAppointments = appointments.where((doc) {
  final data = doc.data();
  final date = data['appointmentDate']?.toString() ?? '';
  final status = data['status']?.toString().toLowerCase() ?? '';

  return date == today &&
      status != 'completed' &&
      status != 'served';
}).toList();

          final history = appointments.where((doc) {
            final data = doc.data();
            final date = data['appointmentDate']?.toString() ?? '';
            final status = data['status']?.toString().toLowerCase() ?? '';

            return date != today ||
                status == 'completed' ||
                status == 'served';
          }).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Current Appointment',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              if (currentAppointments.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('No appointment booked for today.'),
                  ),
                )
              else
                ...currentAppointments.map((appointment) {
                  final data = appointment.data();
                  final clinicId = data['clinicId']?.toString() ?? '';
                  final token = getInt(data['token']);
                  final status = data['status']?.toString() ?? '';
                  final isCompleted = [
                    'completed',
                    'served',
                  ].contains(status.toLowerCase());

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 14),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🏥 ${data['clinicName'] ?? 'Clinic'}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('👨‍⚕️ ${data['doctorName'] ?? 'Doctor'}'),
                          const Divider(),
                          Text(
                            '📅 Appointment Date: ${formatDate(data['appointmentDate']?.toString() ?? '')}',
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '🎫 Token Number: $token',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Text(
                                'Appointment Status: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor(status)
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  statusText(status),
                                  style: TextStyle(
                                    color: statusColor(status),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Live Queue Status',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          if (clinicId.isEmpty)
                            const Text('Clinic queue is unavailable.')
                          else
                            StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection('clinics')
                                  .doc(clinicId)
                                  .snapshots(),
                              builder: (context, clinicSnapshot) {
                                if (clinicSnapshot.hasError) {
                                  return const Text(
                                    'Unable to load live queue.',
                                  );
                                }

                                if (!clinicSnapshot.hasData) {
                                  return const LinearProgressIndicator();
                                }

                                final clinicData =
                                    clinicSnapshot.data!.data() ?? {};
                                final serving =
                                    getInt(clinicData['currentToken']);

                                return StreamBuilder<
                                    QuerySnapshot<Map<String, dynamic>>>(
                                  stream: FirebaseFirestore.instance
                                      .collection('appointments')
                                      .where('clinicId', isEqualTo: clinicId)
                                      .where(
                                        'appointmentDate',
                                        isEqualTo: today,
                                      )
                                      .snapshots(),
                                  builder: (context, queueSnapshot) {
                                    if (queueSnapshot.hasError) {
                                      return const Text(
                                        'Unable to load queue details.',
                                      );
                                    }

                                    if (!queueSnapshot.hasData) {
                                      return const LinearProgressIndicator();
                                    }

                                    final queue = queueSnapshot.data!.docs;

                                    final waiting = queue.where((doc) {
                                      final otherStatus = doc
                                          .data()['status']
                                          ?.toString()
                                          .toLowerCase();
                                      return otherStatus == 'waiting';
                                    }).toList();

                                    final beforeYou = waiting.where((doc) {
                                      final otherToken =
                                          getInt(doc.data()['token']);
                                      return otherToken > serving &&
                                          otherToken < token;
                                    }).length;

                                    final isLastServedAppointment =
                                        isCompleted && token == serving;
                                    final noOneWaiting = waiting.isEmpty;

                                    if (noOneWaiting &&
                                        isLastServedAppointment) {
                                      return Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withValues(
                                            alpha: 0.08,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.green.withValues(
                                              alpha: 0.35,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    'Last Served: Token $serving',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              'Status: Completed',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            const Text(
                                              'No patients waiting',
                                            ),
                                          ],
                                        ),
                                      );
                                    }

                                    if (noOneWaiting) {
                                      return Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey.withValues(
                                            alpha: 0.08,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          serving > 0
                                              ? 'Last Served: Token $serving\nNo patients waiting'
                                              : 'No patients waiting',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    }

                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: const Icon(
                                        Icons.queue,
                                        color: Colors.blue,
                                        size: 32,
                                      ),
                                      title: Text(
                                        serving > 0
                                            ? 'Currently Serving: Token $serving'
                                            : 'Waiting for service to start',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '$beforeYou Patients Before You',
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  );
                }),

              const SizedBox(height: 12),
              const Text(
                'Previous Appointment History',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              if (history.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No previous appointments.'),
                  ),
                )
              else
                ...history.map((appointment) {
                  final data = appointment.data();
                  final status = data['status']?.toString() ?? '';

                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(
                        data['clinicName']?.toString() ?? 'Clinic',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${formatDate(data['appointmentDate']?.toString() ?? '')} • ${statusText(status)}',
                      ),
                      trailing: Icon(
                        status.toLowerCase() == 'completed' ||
                                status.toLowerCase() == 'served'
                            ? Icons.check_circle
                            : Icons.schedule,
                        color: statusColor(status),
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}
