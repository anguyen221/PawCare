import 'package:flutter/material.dart';

class CareTipsScreen extends StatelessWidget {
  final String petType;

  const CareTipsScreen({super.key, required this.petType});

  @override
  Widget build(BuildContext context) {
    String careTips = _getCareTipsForPetType(petType);

    return Scaffold(
      appBar: AppBar(title: Text('$petType Care Tips')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            careTips,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  String _getCareTipsForPetType(String petType) {
    switch (petType) {
      case 'Bunny':
        return '''Bunnies need plenty of space to hop around, so consider giving them a large exercise pen or a designated bunny room.

Diet: Bunnies need a constant supply of fresh hay (such as timothy hay) to keep their digestive system healthy. You can also give them fresh vegetables like leafy greens (but avoid iceberg lettuce).

Exercise: They need daily exercise and time outside of their cage to hop around and explore.

Grooming: Long-haired bunnies need regular grooming to prevent their fur from matting. Even short-haired bunnies benefit from occasional brushing.

Litter Training: Most bunnies can be litter trained, so provide a litter box with rabbit-safe litter.

Socialization: Bunnies are social animals and benefit from interaction. Be gentle and patient, as they can be skittish.''';
      case 'Hamster':
        return '''Hamsters are small and relatively low-maintenance pets, but they do need proper care to thrive.

Habitat: Make sure to provide a hamster cage with plenty of bedding for burrowing and a wheel for exercise.

Diet: Hamsters enjoy a diet of hamster pellets, fresh fruits, and vegetables (avoid citrus fruits and garlic). Offer them fresh water every day.

Exercise: Hamsters are nocturnal, so give them opportunities to exercise during the evening or night. A hamster wheel is essential for their health.

Handling: Hamsters are small and delicate, so handle them gently and avoid waking them during their sleep hours.

Cleaning: Clean their cage once a week to prevent odor buildup and bacteria. Make sure they have fresh bedding to burrow in.''';
      case 'Dog':
        return '''Dogs are loyal companions and require regular care to stay healthy and happy.

Diet: Provide high-quality dog food that is appropriate for their age, size, and breed. Fresh water should always be available.

Exercise: Dogs need daily exercise to stay healthy and burn energy. This can include walks, runs, and playtime.

Training: Start training your dog early with basic commands like sit, stay, and come. Positive reinforcement works best.

Socialization: Dogs benefit from socializing with other dogs and people. Try to expose them to different environments and situations.

Grooming: Depending on the breed, dogs may need regular grooming. Short-haired breeds typically need less grooming, while long-haired breeds require regular brushing.

Health: Keep up with regular veterinary visits for check-ups and vaccinations. Also, ensure your dog gets flea, tick, and heartworm prevention.''';
      case 'Cat':
        return '''Cats are independent yet affectionate pets that need proper care to stay healthy and comfortable.

Diet: Feed your cat high-quality cat food based on their age, health, and dietary needs. Fresh water should be available at all times.

Litter Box: Keep the litter box clean and in a quiet area. Scoop it daily to maintain hygiene.

Exercise: While cats are less demanding than dogs when it comes to exercise, they still need playtime. Provide toys like feathers, balls, and laser pointers.

Grooming: Long-haired cats need regular brushing to prevent tangles and mats, while short-haired cats generally need less grooming.

Scratching: Cats need scratching posts or pads to keep their claws healthy and prevent damage to furniture.

Health: Cats should be taken for regular check-ups and vaccinations. Make sure they are spayed/neutered to avoid health and behavioral issues.

Socialization: Some cats love being around people and other pets, while others prefer solitude. Pay attention to their individual needs.''';
      default:
        return 'Care tips are unavailable for this pet type.';
    }
  }
}
