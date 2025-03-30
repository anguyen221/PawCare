import 'package:flutter/material.dart';

class IllnessScreen extends StatefulWidget {  // Rename here
  @override
  _IllnessScreenState createState() => _IllnessScreenState();  // Rename here
}

class _IllnessScreenState extends State<IllnessScreen> {  // Rename here
  String? selectedPet;
  final Map<String, List<Map<String, String>>> petIllnesses = {
    'Bunny': [],
    'Hamster': [],
    'Dog': [],
    'Cat': [],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Illness Symptoms')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedPet,
              hint: Text('Select a pet'),
              isExpanded: true,
              items: petIllnesses.keys.map((String pet) {
                return DropdownMenuItem<String>(
                  value: pet,
                  child: Text(pet),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedPet = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            selectedPet == null
                ? Text('Select a pet to view illnesses')
                : Expanded(
                    child: ListView(
                      children: petIllnesses[selectedPet]!
                          .map((illness) => ExpansionTile(
                                title: Text(illness['symptom'] ?? 'Unknown'),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Cause: ${illness['cause']}'),
                                        SizedBox(height: 5),
                                        Text(
                                            'Treatment: ${illness['treatment']}'),
                                      ],
                                    ),
                                  )
                                ],
                              ))
                          .toList(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
