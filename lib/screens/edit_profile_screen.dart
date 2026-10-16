
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final mobileController = TextEditingController();

  bool isLoading = true;
  bool isSaving = false;
  String email = '';

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('Please login again.');
      }

      email = user.email ?? '';

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;

        nameController.text = data['name']?.toString() ?? '';
        ageController.text = data['age']?.toString() ?? '';
        mobileController.text = data['mobile']?.toString() ?? '';
        email = user.email ?? data['email']?.toString() ?? '';
      }

      if (mounted) {
        setState(() => isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not load profile: $e')),
        );
      }
    }
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login again.')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'name': nameController.text.trim(),
        'age': ageController.text.trim(),
        'mobile': mobileController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not update profile: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 45,
                      backgroundColor: Color(0xFF1565C0),
                      child: Icon(
                        Icons.person,
                        size: 55,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 25),

                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        prefixIcon: Icon(Icons.cake),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final age = int.tryParse(value?.trim() ?? '');
                        if (age == null || age < 1 || age > 120) {
                          return 'Enter a valid age';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: const InputDecoration(
                        labelText: 'Mobile Number',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                        counterText: '',
                      ),
                      validator: (value) {
                        if (!RegExp(r'^[0-9]{10}$')
                            .hasMatch(value?.trim() ?? '')) {
                          return 'Enter a valid 10-digit mobile number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0B1F3A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(15),
                        ),
                        onPressed: isSaving ? null : saveProfile,
                        icon: isSaving
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.save),
                        label: Text(
                          isSaving ? 'Saving...' : 'Save Changes',
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
