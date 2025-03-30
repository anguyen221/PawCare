// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'care_tips_screen.dart';
import 'update_feeding_schedule_screen.dart';

class PetDetailScreen extends StatelessWidget {
  const PetDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final petId = ModalRoute.of(context)?.settings.arguments as String;
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('🐾 Pet Details', style: TextStyle(fontFamily: 'Fredoka')),
        backgroundColor: Colors.pink.shade100,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade100, Colors.grey.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          image: DecorationImage(
            image: AssetImage('assets/paw_prints.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.2),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('pets')
              .doc(petId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(fontFamily: 'Fredoka')));
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text('Pet not found', style: TextStyle(fontFamily: 'Fredoka')));
            }

            final petData = snapshot.data!;
            final petName = petData['name'];
            final petType = petData['type'];
            final petFeedingSchedule = List<String>.from(petData['feedingSchedule'] ?? []);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🐶 Name: $petName', style: TextStyle(fontSize: 24, fontFamily: 'Fredoka')),
                  SizedBox(height: 8),
                  Text('📌 Type: $petType', style: TextStyle(fontSize: 20, fontFamily: 'Fredoka')),
                  SizedBox(height: 20),
                  Text('🍽 Feeding Schedule:', style: TextStyle(fontSize: 18, fontFamily: 'Fredoka', fontWeight: FontWeight.bold)),
                  ...petFeedingSchedule.map((time) {
                    return Text('⏰ $time', style: TextStyle(fontSize: 16, fontFamily: 'Fredoka'));
                  }),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateFeedingScheduleScreen(petId: petId),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.grey.shade200,
                    ),
                    child: Text('📝 Update Feeding Schedule', style: TextStyle(fontFamily: 'Fredoka')),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CareTipsScreen(petType: petType),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.pink.shade100,
                    ),
                    child: Text('📖 View Care Tips', style: TextStyle(fontFamily: 'Fredoka')),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}