import 'package:flutter/material.dart';

class IllnessScreen extends StatefulWidget {
  final String? petType;

  const IllnessScreen({super.key, this.petType});

  @override
  _IllnessScreenState createState() => _IllnessScreenState();
}

class _IllnessScreenState extends State<IllnessScreen> {
  String? selectedPetType;
  final Map<String, Map<String, List<String>>> illnessData = {
    'Dog': {
      'Symptoms': ['Coughing', 'Vomiting', 'Lethargy', 'Loss of appetite'],
      'Causes': ['Infections', 'Parasites', 'Allergies', 'Indigestion'],
      'Treatments': ['Rest', 'Hydration', 'Vet consultation', 'Medication'],
    },
    'Cat': {
      'Symptoms': ['Sneezing', 'Runny nose', 'Weight loss', 'Diarrhea'],
      'Causes': ['Viral infection', 'Poor diet', 'Worms', 'Stress'],
      'Treatments': ['Antibiotics', 'Proper nutrition', 'Deworming', 'Comfort'],
    },
    'Bunny': {
      'Symptoms': ['Overgrown teeth', 'Diarrhea', 'Hair loss', 'Lethargy'],
      'Causes': ['Poor diet', 'Bacterial infection', 'Parasites', 'Stress'],
      'Treatments': ['Proper diet', 'Antibiotics', 'Grooming', 'Vet visit'],
    },
    'Hamster': {
      'Symptoms': ['Wet tail', 'Loss of fur', 'Eye discharge', 'Hunched posture'],
      'Causes': ['Dirty cage', 'Bacteria', 'Vitamin deficiency', 'Overcrowding'],
      'Treatments': ['Cage cleaning', 'Vet antibiotics', 'Diet improvement', 'Isolation'],
    },
  };

  @override
  void initState() {
    super.initState();
    selectedPetType = widget.petType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🩺 Illness Symptoms', style: TextStyle(fontFamily: 'Fredoka')),
        backgroundColor: Colors.pink.shade100,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade100, Colors.grey.shade200],
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🐾 Select Your Pet Type:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Fredoka'),
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedPetType,
                hint: Text('Choose a pet', style: TextStyle(fontFamily: 'Fredoka')),
                isExpanded: true,
                items: ['Dog', 'Cat', 'Bunny', 'Hamster'].map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type, style: TextStyle(fontFamily: 'Fredoka')),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPetType = newValue;
                  });
                },
              ),
              SizedBox(height: 20),
              if (selectedPetType != null) ...[
                _buildExpandableSection('🩺 Symptoms', illnessData[selectedPetType]!['Symptoms']!),
                _buildExpandableSection('⚠️ Causes', illnessData[selectedPetType]!['Causes']!),
                _buildExpandableSection('💊 Treatments', illnessData[selectedPetType]!['Treatments']!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableSection(String title, List<String> items) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey.shade200,
      child: ExpansionTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Fredoka')),
        children: items.map((item) => ListTile(title: Text(item, style: TextStyle(fontFamily: 'Fredoka')))).toList(),
      ),
    );
  }
}
