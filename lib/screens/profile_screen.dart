import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 20),

            // Profile Image
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Patient Name",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            Card(
              elevation: 3,
              child: Column(
                children: [

                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("Name"),
                    subtitle: const Text("Poonam"),
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.cake),
                    title: const Text("Age"),
                    subtitle: const Text("20 Years"),
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text("Mobile Number"),
                    subtitle: const Text("XXXXXXXXXX"),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
               onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const EditProfileScreen(),
    ),
  );
},
                icon: const Icon(Icons.edit),
                label: const Text("Edit Profile"),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Logout"),
        content: const Text(
          "Are you sure you want to logout?"
        ),

        actions: [

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () {

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false,
              );

            },
            child: const Text("Logout"),
          ),

        ],
      );
    },
  );

},
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
              ),
            ),

          ],
        ),
      ),
     ) 
    );
  }
}