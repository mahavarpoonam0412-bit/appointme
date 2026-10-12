
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../token_service.dart';
import 'token_screen.dart';

class BookAppointmentScreen extends StatefulWidget {
  final String clinicId;
  final String clinicName;
  final String doctorName;
  final String address;

  const BookAppointmentScreen({
    super.key,
    required this.clinicId,
    required this.clinicName,
    required this.doctorName,
    required this.address,
  });

  @override
  State<BookAppointmentScreen> createState() =>
      _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  bool isLoading = false;

  Future<void> confirmAppointment() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('Patient is not logged in.');
      }

      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      String patientName = 'Patient';

      if (userData.exists) {
        final data = userData.data();
        patientName = data?['name']?.toString() ?? 'Patient';
      }

      // Common token service se token aur appointment create karna.
      final generatedToken = await TokenService.createAppointment(
        clinicId: widget.clinicId,
        patientName: patientName,
        clinicName: widget.clinicName,
        doctorName: widget.doctorName,
        address: widget.address,
        bookingType: 'online',
        patientId: user.uid,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Appointment confirmed. Token $generatedToken generated.',
          ),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TokenScreen(
            tokenNumber: generatedToken,
            clinicName: widget.clinicName,
            doctorName: widget.doctorName,
            appointmentDate: TokenService.todayKey(),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final today =
        '${now.day.toString().padLeft(2, '0')} '
        '${_monthName(now.month)} ${now.year}';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
        title: const Text(
          'Book Appointment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Clinic Details',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
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
                        Expanded(
                          child: Text(
                            widget.clinicName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      '👨‍⚕️ ${widget.doctorName}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '📍 ${widget.address}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Appointment Details',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                      title: const Text('Appointment Date'),
                      subtitle: Text('Today - $today'),
                    ),
                    const Divider(),
                    const ListTile(
                      leading: Icon(
                        Icons.confirmation_number,
                        color: Colors.green,
                      ),
                      title: Text('Token'),
                      subtitle: Text(
                        'Token will be generated after confirmation',
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
                onPressed: isLoading ? null : confirmAppointment,
                icon: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.check_circle),
                label: Text(
                  isLoading ? 'Confirming...' : 'Confirm Appointment',
                  style: const TextStyle(fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }
}
