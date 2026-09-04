import 'package:flutter/material.dart';

class LiveQueueScreen extends StatelessWidget {
  const LiveQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
        title: const Text(
          "Live Queue",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
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

            const Text(
              "ABC Clinic",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Dr. Patel",
              style: TextStyle(
                fontSize: 17,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(22),
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

                    const Text(
                      "18",
                      style: TextStyle(
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B1F3A),
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

                    const Text(
                      "14",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    Column(
                      children: [
                        const Icon(
                          Icons.people,
                          size: 32,
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "4",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
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
                          Icons.confirmation_number,
                          size: 32,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "18",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
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
              alignment: Alignment.centerLeft,
              child: Text(
                "Queue",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: Column(
                children: [

                  const ListTile(
                    leading: CircleAvatar(
                      child: Text("14"),
                    ),
                    title: Text(
                      "Currently Serving",
                    ),
                  ),

                  const Divider(height: 1),

                  const ListTile(
                    leading: CircleAvatar(
                      child: Text("15"),
                    ),
                    title: Text("Token 15"),
                  ),

                  const ListTile(
                    leading: CircleAvatar(
                      child: Text("16"),
                    ),
                    title: Text("Token 16"),
                  ),

                  const ListTile(
                    leading: CircleAvatar(
                      child: Text("17"),
                    ),
                    title: Text("Token 17"),
                  ),

                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF0B1F3A),
                      child: Text(
                        "18",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: const Text(
                      "Your Token",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
    );
  }
}