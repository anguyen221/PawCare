import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  _RemindersScreenState createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final _reminderController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> _saveReminder() async {
    if (_reminderController.text.isEmpty || _selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete all fields.')),
      );
      return;
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('reminders')
          .add({
        'text': _reminderController.text,
        'date': _selectedDate!.toIso8601String(),
        'time': _selectedTime!.format(context),
        'createdAt': FieldValue.serverTimestamp(),
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set a Reminder', style: TextStyle(fontFamily: 'Fredoka')),
        backgroundColor: Colors.pink.shade200,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade50, Colors.purple.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _reminderController,
                decoration: InputDecoration(
                  labelText: 'Reminder Text',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickDate,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.pink.shade300,
                ),
                child: Text('📅 Select Date'),
              ),
              Text(
                _selectedDate != null ? _selectedDate!.toLocal().toString().split(' ')[0] : 'No date selected',
                style: TextStyle(fontFamily: 'Fredoka'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickTime,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.purple.shade300,
                ),
                child: Text('⏰ Select Time'),
              ),
              Text(
                _selectedTime != null ? _selectedTime!.format(context) : 'No time selected',
                style: TextStyle(fontFamily: 'Fredoka'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveReminder,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.blue.shade300,
                ),
                child: Text('✅ Save Reminder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
