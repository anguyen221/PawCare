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
      _reminderController.clear();
      setState(() {
        _selectedDate = null;
        _selectedTime = null;
      });
    }
  }

  Future<void> _deleteReminder(String reminderId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('reminders')
          .doc(reminderId)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('Reminders')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _reminderController,
              decoration: InputDecoration(labelText: 'Reminder Text'),
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _pickDate, child: Text('Select Date')),
            Text(_selectedDate != null ? _selectedDate!.toLocal().toString().split(' ')[0] : 'No date selected'),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _pickTime, child: Text('Select Time')),
            Text(_selectedTime != null ? _selectedTime!.format(context) : 'No time selected'),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveReminder, child: Text('Save Reminder')),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .collection('reminders')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final reminders = snapshot.data?.docs ?? [];

                  if (reminders.isEmpty) {
                    return Center(child: Text('No reminders set.'));
                  }

                  return ListView.builder(
                    itemCount: reminders.length,
                    itemBuilder: (context, index) {
                      final reminder = reminders[index];
                      return ListTile(
                        title: Text(reminder['text']),
                        subtitle: Text('${reminder['date']} at ${reminder['time']}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteReminder(reminder.id),
                        ),
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