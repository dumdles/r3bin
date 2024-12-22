import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'rewards_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _currentUser = _auth.currentUser;

    if (_currentUser != null) {
      final userDoc =
          await _firestore.collection('users').doc(_currentUser!.uid).get();

      if (userDoc.exists) {
        setState(() {
          _userData = userDoc.data();
        });
      } else {
        print("User document does not exist");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          _userData != null ? 'Welcome, ${_userData?['name']}!' : 'Welcome!',
          style: const TextStyle(fontSize: 16, color: CupertinoColors.black),
        ),
      ),
      child: SafeArea(
        child: _userData == null
            ? const Center(child: CupertinoActivityIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  AddressHeader(address: _userData?['address']),
                  const SizedBox(height: 20),
                  PointsCard(points: _userData?['rewardsEarned']),
                  const SizedBox(height: 20),
                  const SectionHeader(
                      title: 'Find your nearest Community Deposit Bin'),
                  const SizedBox(height: 10),
                  const InfoCard(),
                  const SizedBox(height: 20),
                  const SectionHeader(title: 'Latest rewards'),
                  const SizedBox(height: 10),
                  const RewardsList(),
                  const SizedBox(height: 20),
                  const SectionHeader(title: 'Recent transactions'),
                  const TransactionList(),
                ],
              ),
      ),
    );
  }
}

class AddressHeader extends StatelessWidget {
  final String? address;

  const AddressHeader({Key? key, this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        children: [
          const Icon(Icons.location_city_rounded, size: 20),
          const SizedBox(width: 8),
          Text(
            address ?? 'No address available',
            style: const TextStyle(fontSize: 16, color: CupertinoColors.black),
          ),
        ],
      ),
    );
  }
}

class PointsCard extends StatelessWidget {
  final dynamic points; // Accept dynamic type to handle both int and String

  const PointsCard({Key? key, this.points}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Current Points',
              style: TextStyle(color: CupertinoColors.white)),
          const SizedBox(height: 8),
          Text(
            points?.toString() ?? '0', // Convert points to String safely
            style: const TextStyle(
                fontSize: 36,
                color: CupertinoColors.white,
                fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text('Keep it up! You\'re doing great!',
              style: TextStyle(color: CupertinoColors.white)),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: NetworkImage(
              'https://unsplash.com/photos/body-of-water-near-trees-and-high-rise-buildings-during-daytime-M5seQ7ZuKJ4'), // Replace with your actual image URL
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(16),
      child: const Text(
        'Find your nearest Community Deposit Bin',
        style: TextStyle(
            color: CupertinoColors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.black)),
        const Text('View all',
            style: TextStyle(color: CupertinoColors.activeGreen)),
      ],
    );
  }
}

class TransactionList extends StatelessWidget {
  const TransactionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TransactionCard(
            title: 'Nanyang Community Centre',
            details: '835 grams • 1 day ago'),
        TransactionCard(
            title: 'Jurong Green Community Centre',
            details: '344 grams • 5 days ago'),
        TransactionCard(
            title: 'Points Redemption', details: '200 points • 1 week ago'),
      ],
    );
  }
}

class TransactionCard extends StatelessWidget {
  final String title;
  final String details;
  const TransactionCard({Key? key, required this.title, required this.details})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: CupertinoColors.systemGrey5),
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: CupertinoColors.systemGrey6,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.square_rounded,
              size: 60, color: CupertinoColors.systemGrey5),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: CupertinoColors.black),
              ),
              const SizedBox(height: 4),
              Text(details,
                  style: const TextStyle(color: CupertinoColors.systemGrey)),
            ],
          ),
        ],
      ),
    );
  }
}
