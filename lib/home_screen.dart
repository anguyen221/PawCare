import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Care', style: TextStyle(fontFamily: 'Fredoka')),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${user?.email ?? 'User'}!',
                style: TextStyle(fontSize: 24, fontFamily: 'Fredoka'),
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.grey.shade200,
                ),
                child: Text('🚪 Log Out'),
              ),
              
              SizedBox(height: 20),
              
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/addPet');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.pink.shade100,
                ),
                child: Text('🐶 Add Pet'),
              ),
              
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/illnessSymptoms');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.grey.shade200,
                ),
                child: Text('🩺 Illness Symptoms'),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/reminders');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.pink.shade100,
                ),
                child: Text('⏰ Reminders'),
              ),

              SizedBox(height: 20),
              
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user?.uid)
                      .collection('reminders')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final reminders = snapshot.data?.docs ?? [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (reminders.isNotEmpty) ...[
                          Text(
                            'Reminders:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Fredoka'),
                          ),
                          SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: reminders.length,
                            itemBuilder: (context, index) {
                              final reminder = reminders[index];
                              return ListTile(
                                title: Text(reminder['text'], style: TextStyle(fontFamily: 'Fredoka')),
                                subtitle: Text('${reminder['date']} at ${reminder['time']}'),
                              );
                            },
                          ),
                          SizedBox(height: 20),
                        ],
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
                                return Center(child: Text('No pets found', style: TextStyle(fontFamily: 'Fredoka')));
                              }

                              return ListView.builder(
                                itemCount: pets.length,
                                itemBuilder: (context, index) {
                                  final pet = pets[index];
                                  final petName = pet['name'];
                                  final petType = pet['type'];
                                  final petId = pet.id;

                                  return ListTile(
                                    title: Text(petName, style: TextStyle(fontFamily: 'Fredoka')),
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
