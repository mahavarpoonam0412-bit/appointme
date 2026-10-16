import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../token_service.dart';
import 'clinic_profile_screen.dart';

class ClinicHomeScreen extends StatefulWidget {
  const ClinicHomeScreen({super.key});

  @override
  State<ClinicHomeScreen> createState() => _ClinicHomeScreenState();
}

class _ClinicHomeScreenState extends State<ClinicHomeScreen> {
  bool isServing = false;
  bool isAddingOffline = false;

  String get todayKey => TokenService.todayKey();

  Future<void> addOfflinePatient() async {
    if (isAddingOffline || isServing) return;

    final nameController = TextEditingController();
    final mobileController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Offline Patient'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Patient Name (Optional)',
                      hintText: 'Enter patient name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: const InputDecoration(
                      labelText: 'Mobile Number (Optional)',
                      hintText: 'Enter 10-digit number',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                    validator: (value) {
                      final mobile = value?.trim() ?? '';
                      if (mobile.isNotEmpty &&
                          !RegExp(r'^[0-9]{10}$').hasMatch(mobile)) {
                        return 'Enter a valid 10-digit number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Patient does not need an AppointMe account.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(dialogContext, true);
                }
              },
              child: const Text('Generate Token'),
            ),
          ],
        );
      },
    );

    if (result != true || !mounted) {
      nameController.dispose();
      mobileController.dispose();
      return;
    }

    setState(() => isAddingOffline = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Please log in again.');
      }

      final db = FirebaseFirestore.instance;
      final clinicSnapshot = await db.collection('clinics').doc(user.uid).get();

      if (!clinicSnapshot.exists) {
        throw Exception('Clinic details not found.');
      }

      final clinicData = clinicSnapshot.data()!;

      final token = await TokenService.createOfflineAppointment(
        clinicId: user.uid,
        patientName: nameController.text.trim().isEmpty
            ? 'Walk-in Patient'
            : nameController.text.trim(),
        mobile: mobileController.text.trim(),
        clinicName: clinicData['clinicName']?.toString() ?? 'Clinic',
        doctorName: clinicData['ownerName']?.toString() ?? 'Doctor',
        address: clinicData['address']?.toString() ?? '',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Offline patient added. Token $token generated.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not add patient: ${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ),
      );
    } finally {
      nameController.dispose();
      mobileController.dispose();
      if (mounted) setState(() => isAddingOffline = false);
    }
  }

  Future<void> serveNextPatient(
    QueryDocumentSnapshot<Map<String, dynamic>> appointment,
  ) async {
    if (isServing || isAddingOffline) return;

    setState(() => isServing = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Please log in again.');
      }

      final db = FirebaseFirestore.instance;
      final appointmentRef = appointment.reference;
      final clinicRef = db.collection('clinics').doc(user.uid);

      await db.runTransaction((transaction) async {
        final appointmentSnapshot = await transaction.get(appointmentRef);
        final clinicSnapshot = await transaction.get(clinicRef);

        if (!appointmentSnapshot.exists) {
          throw Exception('Appointment not found.');
        }

        final data = appointmentSnapshot.data()!;

        if (data['status'] != 'waiting' ||
            data['clinicId'] != user.uid ||
            data['appointmentDate'] != todayKey) {
          throw Exception('This appointment is no longer waiting.');
        }

        final tokenValue = data['token'];
        final token = tokenValue is num ? tokenValue.toInt() : 0;

        transaction.update(appointmentRef, {
          'status': 'completed',
          'servedAt': FieldValue.serverTimestamp(),
        });

        if (clinicSnapshot.exists) {
          transaction.update(clinicRef, {'currentToken': token});
        }
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Patient with Token ${appointment.data()['token']} completed.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not serve patient: ${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => isServing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('Please log in again.')));
    }

    final clinicRef = FirebaseFirestore.instance
        .collection('clinics')
        .doc(user.uid);

    final appointmentsQuery = FirebaseFirestore.instance
        .collection('appointments')
        .where('clinicId', isEqualTo: user.uid)
        .where('appointmentDate', isEqualTo: todayKey);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
        title: const Text(
          'Clinic Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ClinicProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: clinicRef.snapshots(),
        builder: (context, clinicSnapshot) {
          final clinicData = clinicSnapshot.data?.data();

          final clinicName = clinicData?['clinicName']?.toString() ?? 'Clinic';
          final doctorName = clinicData?['ownerName']?.toString() ?? 'Doctor';

          final currentValue = clinicData?['currentToken'];
          final currentToken = currentValue is num ? currentValue.toInt() : 0;

          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: appointmentsQuery.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Could not load queue.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final allAppointments = snapshot.data!.docs.toList();

              allAppointments.sort((a, b) {
                final av = a.data()['token'];
                final bv = b.data()['token'];
                final aToken = av is num ? av.toInt() : 0;
                final bToken = bv is num ? bv.toInt() : 0;
                return aToken.compareTo(bToken);
              });

              final waitingAppointments = allAppointments
                  .where((doc) => doc.data()['status'] == 'waiting')
                  .toList();

              final nextPatient = waitingAppointments.isNotEmpty
                  ? waitingAppointments.first
                  : null;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Icon(
                      Icons.local_hospital,
                      size: 65,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      clinicName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      doctorName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 17, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: isAddingOffline || isServing
                            ? null
                            : addOfflinePatient,
                        icon: isAddingOffline
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.person_add),
                        label: Text(
                          isAddingOffline
                              ? 'Adding Patient...'
                              : 'Add Offline Patient',
                          style: const TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Today's Queue",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (waitingAppointments.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(12),
                                child: Text('No patients waiting today.'),
                              ),
                            ...waitingAppointments.map((appointment) {
                              final data = appointment.data();
                              final token = data['token'] ?? '-';
                              final patientName =
                                  data['patientName']?.toString() ?? 'Patient';
                              final bookingType =
                                  data['bookingType']?.toString() ?? 'online';
                              final mobile =
                                  data['patientMobile']?.toString() ?? '';

                              return ListTile(
                                leading: const Icon(
                                  Icons.confirmation_number,
                                  color: Colors.blue,
                                ),
                                title: Text('Token $token - $patientName'),
                                subtitle: Text(
                                  '${bookingType.toUpperCase()}'
                                  '${mobile.isNotEmpty ? ' • $mobile' : ''}',
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Text(
                              'Current Token',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '$currentToken',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0B1F3A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Card(
                      elevation: 3,
                      child: ListTile(
                        leading: const Icon(
                          Icons.people,
                          size: 35,
                          color: Colors.blue,
                        ),
                        title: const Text(
                          'Total Patients Today',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          '${allAppointments.length}',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Card(
                      elevation: 3,
                      child: ListTile(
                        leading: const Icon(
                          Icons.person,
                          size: 35,
                          color: Colors.orange,
                        ),
                        title: const Text(
                          'Next Patient',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          nextPatient == null
                              ? 'None'
                              : 'Token ${nextPatient.data()['token']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed:
                            nextPatient == null || isServing || isAddingOffline
                            ? null
                            : () => serveNextPatient(nextPatient),
                        icon: isServing
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.skip_next),
                        label: const Text(
                          'Serve Next Patient',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
