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

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pet added! ✅')));

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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade100, Colors.grey.shade300],
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
            children: [
              SizedBox(height: 50),
              Text(
                'Add Pet 🐶',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Fredoka',
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _petNameController,
                      decoration: InputDecoration(
                        labelText: 'Pet Name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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
                      decoration: InputDecoration(
                        labelText: 'Pet Type',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: petTypes.map((petType) {
                        return DropdownMenuItem<String>(
                          value: petType,
                          child: Text(petType, style: TextStyle(fontFamily: 'Fredoka')),
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
                      decoration: InputDecoration(
                        labelText: 'Feeding Time (e.g., 8:00 AM)',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _addFeedingTime,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('➕ Add Feeding Time'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addPet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('🐾 Add Pet'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Feeding Times:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Fredoka',
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: feedingTimes.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.pink.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          feedingTimes[index],
                          style: TextStyle(fontFamily: 'Fredoka'),
                        ),
                      ),
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
