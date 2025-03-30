import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Feeding Schedule Updated!')));
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
      appBar: AppBar(title: Text('Update Feeding Schedule')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
              onPressed: _updateFeedingSchedule,
              child: Text('Save Feeding Schedule'),
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
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _removeFeedingTime(index);
                        _updateFeedingSchedule();
                      },
                    ),
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
