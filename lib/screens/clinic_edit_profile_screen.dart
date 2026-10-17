
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClinicEditProfileScreen extends StatefulWidget {
  const ClinicEditProfileScreen({super.key});

  @override
  State<ClinicEditProfileScreen> createState() =>
      _ClinicEditProfileScreenState();
}

class _ClinicEditProfileScreenState
    extends State<ClinicEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _clinicNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _specialityController = TextEditingController();

  bool _loading = true;
  bool _saving = false;

  final Color navy = const Color(0xFF0B1F3A);

  @override
  void initState() {
    super.initState();
    _loadClinicDetails();
  }

  Future<void> _loadClinicDetails() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('Please login again.');
      }

      final doc = await FirebaseFirestore.instance
          .collection('clinics')
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        throw Exception('Clinic details not found.');
      }

      final data = doc.data()!;

      _clinicNameController.text =
          (data['clinicName'] ?? '').toString();

      _ownerNameController.text =
          (data['ownerName'] ?? data['doctorName'] ?? '').toString();

      _mobileController.text =
          (data['mobile'] ?? '').toString();

      _addressController.text =
          (data['address'] ?? '').toString();

      _qualificationController.text =
          (data['qualification'] ?? '').toString();

      _specialityController.text =
          (data['speciality'] ?? '').toString();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Details load nahi hui: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login again.')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      await FirebaseFirestore.instance
          .collection('clinics')
          .doc(user.uid)
          .update({
        'clinicName': _clinicNameController.text.trim(),
        'ownerName': _ownerNameController.text.trim(),
        'doctorName': _ownerNameController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'address': _addressController.text.trim(),
        'qualification': _qualificationController.text.trim(),
        'speciality': _specialityController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Clinic profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile update nahi hua: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Widget _buildField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool requiredField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: navy, width: 2),
          ),
        ),
        validator: (value) {
          if (requiredField &&
              (value == null || value.trim().isEmpty)) {
            return '$label is required';
          }

          if (label == 'Mobile Number' &&
              value != null &&
              value.trim().isNotEmpty &&
              !RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
            return 'Enter a valid 10-digit mobile number';
          }

          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    _clinicNameController.dispose();
    _ownerNameController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _qualificationController.dispose();
    _specialityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: const Text(
          'Edit Clinic Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.local_hospital,
                      size: 65,
                      color: Color(0xFF1565C0),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Update your clinic details',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 25),

                    _buildField(
                      label: 'Clinic Name',
                      icon: Icons.local_hospital,
                      controller: _clinicNameController,
                      requiredField: true,
                    ),
                    _buildField(
                      label: 'Doctor / Owner Name',
                      icon: Icons.person,
                      controller: _ownerNameController,
                      requiredField: true,
                    ),
                    _buildField(
                      label: 'Mobile Number',
                      icon: Icons.phone,
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                    ),
                    _buildField(
                      label: 'Clinic Address',
                      icon: Icons.location_on,
                      controller: _addressController,
                      maxLines: 2,
                      requiredField: true,
                    ),
                    _buildField(
                      label: 'Qualification',
                      icon: Icons.school,
                      controller: _qualificationController,
                    ),
                    _buildField(
                      label: 'Speciality',
                      icon: Icons.medical_services,
                      controller: _specialityController,
                    ),

                    const SizedBox(height: 10),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _saving ? null : _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: navy,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: _saving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.save),
                        label: Text(
                          _saving ? 'Saving...' : 'Save Changes',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
