import 'package:flutter/material.dart';

class IllnessScreen extends StatelessWidget {
  final String petType;

  const IllnessScreen({super.key, required this.petType});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, String>>> illnessData = {
      'bunny': [
        {'symptom': 'Loss of Appetite', 'cause': 'GI Stasis', 'treatment': 'Provide hay, consult vet'},
        {'symptom': 'Runny Nose', 'cause': 'Respiratory Infection', 'treatment': 'Visit vet for antibiotics'},
      ],
      'hamster': [
        {'symptom': 'Wet Tail', 'cause': 'Bacterial Infection', 'treatment': 'Hydration, vet care needed'},
        {'symptom': 'Hair Loss', 'cause': 'Mites or Diet Issue', 'treatment': 'Improve diet, consult vet'},
      ],
      'dog': [
        {'symptom': 'Itchy Skin', 'cause': 'Allergies or Fleas', 'treatment': 'Check for fleas, vet consultation'},
        {'symptom': 'Vomiting', 'cause': 'Diet Issue or Illness', 'treatment': 'Withhold food temporarily, visit vet if severe'},
      ],
      'cat': [
        {'symptom': 'Sneezing', 'cause': 'Upper Respiratory Infection', 'treatment': 'Hydration, vet checkup'},
        {'symptom': 'Lethargy', 'cause': 'Illness or Stress', 'treatment': 'Monitor, consult vet if persistent'},
      ],
    };

    final petSymptoms = illnessData[petType] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('$petType Illness Symptoms')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: petSymptoms.map((illness) {
          return ExpansionTile(
            title: Text(illness['symptom']!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cause: ${illness['cause']}', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 5),
                    Text('Treatment: ${illness['treatment']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
