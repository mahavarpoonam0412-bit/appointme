
import 'package:cloud_firestore/cloud_firestore.dart';

class TokenService {
  static String todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

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
}
