import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B11),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Image.asset('assets/logos/honey_badger_logo.png', width: 110, height: 110),
              const SizedBox(height: 20),
              const Text('Commander Jonny', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const Text('Rank: Honey Badger Rookie', style: TextStyle(color: Color(0xFFD4AF37))),
              const SizedBox(height: 30),
              const ProfileCard(title: 'Level', value: '1'),
              const ProfileCard(title: 'XP', value: '120'),
              const ProfileCard(title: 'Decoded Messages', value: '0'),
              const ProfileCard(title: 'Crypto Moves', value: '0'),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String title;
  final String value;

  const ProfileCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD4AF37)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value, style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
