import 'package:cloud_firestore/cloud_firestore.dart';

class TokenService {
  static String todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  // Online patient appointment
  static Future<int> createAppointment({
    required String clinicId,
    required String patientName,
    required String clinicName,
    required String doctorName,
    required String address,
    required String bookingType,
    String? patientId,
  }) async {
    final db = FirebaseFirestore.instance;
    final clinicRef = db.collection('clinics').doc(clinicId);
    final appointmentRef = db.collection('appointments').doc();
    final today = todayKey();

    if (patientId == null || patientId.isEmpty) {
      throw Exception('Please login again before booking.');
    }

    return db.runTransaction<int>((transaction) async {
      final clinicSnapshot = await transaction.get(clinicRef);

      if (!clinicSnapshot.exists) {
        throw Exception('Clinic not found.');
      }

      final existingAppointments = await db
          .collection('appointments')
          .where('patientId', isEqualTo: patientId)
          .where('clinicId', isEqualTo: clinicId)
          .where('appointmentDate', isEqualTo: today)
          .get();

      for (final appointment in existingAppointments.docs) {
        final status =
            appointment.data()['status']?.toString().toLowerCase() ?? '';

        if (status != 'completed' && status != 'served') {
          throw Exception(
            'You already have an active appointment at this clinic today.',
          );
        }
      }

      final data = clinicSnapshot.data()!;
      final lastDate = data['lastTokenDate']?.toString() ?? '';
      final lastValue = data['lastToken'];
      final lastToken = lastValue is num ? lastValue.toInt() : 0;

      final nextToken = lastDate == today ? lastToken + 1 : 1;

      transaction.update(clinicRef, {
        'lastTokenDate': today,
        'lastToken': nextToken,
      });

      transaction.set(appointmentRef, {
        'patientId': patientId,
        'patientName': patientName,
        'clinicId': clinicId,
        'clinicName': clinicName,
        'doctorName': doctorName,
        'address': address,
        'token': nextToken,
        'appointmentDate': today,
        'status': 'waiting',
        'bookingType': bookingType,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return nextToken;
    });
  }

  // Offline patient: AppointMe account is not required.
  static Future<int> createOfflineAppointment({
    required String clinicId,
    required String patientName,
    required String clinicName,
    required String doctorName,
    required String address,
    String? mobile,
  }) async {
    final db = FirebaseFirestore.instance;
    final clinicRef = db.collection('clinics').doc(clinicId);
    final appointmentRef = db.collection('appointments').doc();
    final today = todayKey();

    final cleanName = patientName.trim().isEmpty
        ? 'Walk-in Patient'
        : patientName.trim();

    final cleanMobile = mobile?.trim() ?? '';

    return db.runTransaction<int>((transaction) async {
      final clinicSnapshot = await transaction.get(clinicRef);

      if (!clinicSnapshot.exists) {
        throw Exception('Clinic not found.');
      }

      final data = clinicSnapshot.data()!;
      final lastDate = data['lastTokenDate']?.toString() ?? '';
      final lastValue = data['lastToken'];
      final lastToken = lastValue is num ? lastValue.toInt() : 0;

      final nextToken = lastDate == today ? lastToken + 1 : 1;

      transaction.update(clinicRef, {
        'lastTokenDate': today,
        'lastToken': nextToken,
      });

      transaction.set(appointmentRef, {
        'patientId': null,
        'patientName': cleanName,
        'patientMobile': cleanMobile.isEmpty ? null : cleanMobile,
        'clinicId': clinicId,
        'clinicName': clinicName,
        'doctorName': doctorName,
        'address': address,
        'token': nextToken,
        'appointmentDate': today,
        'status': 'waiting',
        'bookingType': 'offline',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return nextToken;
    });
  }
}
