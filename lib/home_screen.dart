// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('Home Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user?.email ?? 'User'}!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Text('Log Out'),
            ),
            
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addPet');
              },
              child: Text('Add Pet'),
            ),
            
            SizedBox(height: 20),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .collection('pets')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final pets = snapshot.data?.docs ?? [];

                  if (pets.isEmpty) {
                    return Center(child: Text('No pets found'));
                  }

                  return ListView.builder(
                    itemCount: pets.length,
                    itemBuilder: (context, index) {
                      final pet = pets[index];
                      final petName = pet['name'];
                      final petType = pet['type'];
                      final petId = pet.id;

                      return ListTile(
                        title: Text(petName),
                        subtitle: Text(petType),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/petDetail',
                            arguments: petId, 
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
