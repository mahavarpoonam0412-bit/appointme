
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'edit_profile_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login again.')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text('Profile details not found.'),
            );
          }

          final data = snapshot.data!.data()!;
          final name = data['name']?.toString() ?? '';
          final age = data['age']?.toString() ?? '';
          final mobile = data['mobile']?.toString() ?? '';
          final email = user.email ?? data['email']?.toString() ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),

                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF1565C0),
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  name.isEmpty ? 'Patient Name' : name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 25),

                Card(
                  elevation: 3,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Name'),
                        subtitle: Text(name.isEmpty ? 'Not added' : name),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.cake),
                        title: const Text('Age'),
                        subtitle: Text(
                          age.isEmpty ? 'Not added' : '$age Years',
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text('Mobile Number'),
                        subtitle: Text(
                          mobile.isEmpty ? 'Not added' : mobile,
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text('Email'),
                        subtitle: Text(email.isEmpty ? 'Not added' : email),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B1F3A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(14),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(14),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text(
                            'Are you sure you want to logout?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(dialogContext),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(dialogContext);

                                await FirebaseAuth.instance.signOut();

                                if (!context.mounted) return;

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
