import 'package:flutter/material.dart';

class IllnessScreen extends StatelessWidget {
  final String petType;

  const IllnessScreen({super.key, required this.petType});

  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, String>> illnessInfo = {
      'bunny': {
        'symptom1': 'Lethargy',
        'symptom2': 'Loss of appetite',
        'symptom3': 'Diarrhea',
        'cause': 'Could be due to digestive issues or stress.',
        'treatment': 'Consult a vet for proper diagnosis and treatment.',
      },
      'hamster': {
        'symptom1': 'Hair loss',
        'symptom2': 'Wet tail',
        'symptom3': 'Loss of appetite',
        'cause': 'Wet tail is usually caused by stress or bacterial infection.',
        'treatment': 'Ensure a clean environment and consult a vet for medication.',
      },
      'cat': {
        'symptom1': 'Vomiting',
        'symptom2': 'Loss of appetite',
        'symptom3': 'Lethargy',
        'cause': 'Could be due to a variety of issues, including hairballs or infections.',
        'treatment': 'Keep the cat hydrated and take it to a vet for further diagnosis.',
      },
      'dog': {
        'symptom1': 'Excessive scratching',
        'symptom2': 'Vomiting',
        'symptom3': 'Lethargy',
        'cause': 'Could be allergies, infections, or parasites.',
        'treatment': 'Check for fleas and consult a vet for a proper treatment plan.',
      },
    };

    return Scaffold(
      appBar: AppBar(title: Text('Illness Symptoms for $petType')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Common Symptoms for $petType:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            if (illnessInfo[petType] != null) ...[
              Text(
                '1. ${illnessInfo[petType]!['symptom1']}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '2. ${illnessInfo[petType]!['symptom2']}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '3. ${illnessInfo[petType]!['symptom3']}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Possible Cause:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                illnessInfo[petType]!['cause']!,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Recommended Treatment:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                illnessInfo[petType]!['treatment']!,
                style: TextStyle(fontSize: 16),
              ),
            ] else ...[
              Text(
                'No illness data available for this pet type.',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
