import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateFeedingScheduleScreen extends StatefulWidget {
  final String petId;

  const UpdateFeedingScheduleScreen({super.key, required this.petId});

  @override
  _UpdateFeedingScheduleScreenState createState() =>
      _UpdateFeedingScheduleScreenState();
}

class _UpdateFeedingScheduleScreenState extends State<UpdateFeedingScheduleScreen> {
  final _feedingTimeController = TextEditingController();
  List<String> feedingTimes = [];

  @override
  void initState() {
    super.initState();
    _loadFeedingTimes();
  }

  Future<void> _loadFeedingTimes() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      final petRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('pets')
          .doc(widget.petId);

      final snapshot = await petRef.get();
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        setState(() {
          feedingTimes = List<String>.from(data['feedingSchedule'] ?? []);
        });
      }
    }
  }

  Future<void> _updateFeedingSchedule() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      final petRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('pets')
          .doc(widget.petId);

      await petRef.update({
        'feedingSchedule': feedingTimes,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feeding Schedule Updated! ✅')),
      );
      Navigator.pop(context);
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

  void _removeFeedingTime(int index) {
    setState(() {
      feedingTimes.removeAt(index);
    });
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
                'Update Feeding Schedule 🐾',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Fredoka',
                ),
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
                onPressed: _updateFeedingSchedule,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('💾 Save Feeding Schedule'),
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
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.grey.shade300),
                          onPressed: () {
                            _removeFeedingTime(index);
                            _updateFeedingSchedule();
                          },
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