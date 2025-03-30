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
      appBar: AppBar(title: Text('Pet Details')),
      body: FutureBuilder<DocumentSnapshot>(
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
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Pet not found'));
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
                Text(
                  'Pet Name: $petName',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 8),
                Text(
                  'Pet Type: $petType',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Text(
                  'Feeding Schedule:',
                  style: TextStyle(fontSize: 18),
                ),
                ...petFeedingSchedule.map((time) {
                  return Text(
                    time,
                    style: TextStyle(fontSize: 16),
                  );
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
                  child: Text('Update Feeding Schedule'),
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
                  child: Text('View Care Tips'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
