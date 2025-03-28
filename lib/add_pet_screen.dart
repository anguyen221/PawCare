// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  _AddPetScreenState createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _petNameController = TextEditingController();
  String? _selectedPetType;
  final _feedingTimeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<String> petTypes = ['Bunny', 'Hamster', 'Dog', 'Cat'];
  final List<String> feedingTimes = [];

  Future<void> _addPet() async {
    if (_formKey.currentState?.validate() ?? false) {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        final petRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('pets')
            .doc();

        await petRef.set({
          'name': _petNameController.text,
          'type': _selectedPetType,
          'feedingSchedule': feedingTimes, 
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pet added!')));

        Navigator.pop(context);
      }
    }
  }

  void _addFeedingTime() {
    if (_feedingTimeController.text.isNotEmpty) {
      setState(() {
        feedingTimes.add(_feedingTimeController.text);
        _feedingTimeController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Pet')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _petNameController,
                decoration: InputDecoration(labelText: 'Pet Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a pet name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedPetType,
                decoration: InputDecoration(labelText: 'Pet Type'),
                items: petTypes.map((petType) {
                  return DropdownMenuItem<String>(
                    value: petType,
                    child: Text(petType),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPetType = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a pet type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _feedingTimeController,
                decoration: InputDecoration(labelText: 'Feeding Time (e.g., 8:00 AM)'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addFeedingTime,
                child: Text('Add Feeding Time'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addPet,
                child: Text('Add Pet'),
              ),
              SizedBox(height: 20),
              Text(
                'Feeding Times:',
                style: TextStyle(fontSize: 18),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: feedingTimes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(feedingTimes[index]),
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
