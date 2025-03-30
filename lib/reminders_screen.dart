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
      setState(() {});
      Navigator.pop(context);
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
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set a Reminder', style: TextStyle(fontFamily: 'Fredoka')),
        backgroundColor: Colors.pink.shade100,
      ),
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
                  backgroundColor: Colors.pink.shade100,
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
                  backgroundColor: Colors.pink.shade100,
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
                  backgroundColor: Colors.pink.shade100,
                ),
                child: Text('✅ Save Reminder'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .collection('reminders')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final reminders = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: reminders.length,
                      itemBuilder: (context, index) {
                        final reminder = reminders[index];
                        final reminderId = reminder.id;
                        final reminderText = reminder['text'];
                        final reminderDate = DateTime.parse(reminder['date']);
                        final reminderTime = reminder['time'];

                        return Card(
                          color: Colors.pink.shade50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(reminderText, style: TextStyle(fontFamily: 'Fredoka')),
                            subtitle: Text(
                              '${reminderDate.toLocal().toString().split(' ')[0]} at $reminderTime',
                              style: TextStyle(fontFamily: 'Fredoka'),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.pink),
                              onPressed: () => _deleteReminder(reminderId),
                            ),
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
      ),
    );
  }
}
