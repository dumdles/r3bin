import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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

          // Convert int fields to String for display
          if (_userData?['totalContributions'] is int) {
            _userData?['totalContributions'] =
                "${_userData?['totalContributions']} kg";
          }
          if (_userData?['rewardsEarned'] is int) {
            _userData?['rewardsEarned'] = "${_userData?['rewardsEarned']} pts";
          }

          // Convert Timestamp to String if necessary
          if (_userData?['dateJoined'] is Timestamp) {
            _userData?['dateJoined'] = (_userData?['dateJoined'] as Timestamp)
                .toDate()
                .toIso8601String();
          }
        });
      } else {
        print("User document does not exist");
      }
    }
  }

  Future<void> _updateUserData(String field, String value) async {
    if (_currentUser != null) {
      await _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .update({field: value});
      setState(() {
        _userData?[field] = value;
      });
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate back to the login screen
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      // Show an error dialog if sign-out fails
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("Sign Out Failed"),
          content: Text(e.toString()),
          actions: [
            CupertinoDialogAction(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Profile", style: TextStyle(color: Colors.black)),
      ),
      child: SafeArea(
        child: _userData == null
            ? const Center(child: CupertinoActivityIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Profile Header
                  ProfileHeader(
                    name: _userData?['name'] ?? "Unknown",
                    email: _currentUser?.email ?? "Unknown",
                  ),
                  const SizedBox(height: 20),

                  // Composting Statistics Section
                  const SectionHeader(title: "Composting Statistics"),
                  const SizedBox(height: 5),
                  CompostingStatistics(
                    dateJoined: _userData?['dateJoined'] ?? "Unknown",
                    totalContributions:
                        _userData?['totalContributions'] ?? "0 kg",
                    rewardsEarned: _userData?['rewardsEarned'] ?? "0 pts",
                  ),
                  const SizedBox(height: 20),

                  // Editable User Details
                  const SectionHeader(title: "Your Details"),
                  const SizedBox(height: 5),
                  UserDetails(
                    name: _userData?['name'] ?? "",
                    address: _userData?['address'] ?? "",
                    onUpdate: _updateUserData,
                  ),
                  const SizedBox(height: 20),

                  // Logout Button
                  CupertinoButton.filled(
                    onPressed: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) => CupertinoAlertDialog(
                          title: const Text("Log Out"),
                          content:
                              const Text("Are you sure you want to log out?"),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text("Cancel"),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              child: const Text("Log Out"),
                              onPressed: () => _signOut(context),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text("Log Out"),
                  ),
                ],
              ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;

  const ProfileHeader({Key? key, required this.name, required this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: CupertinoColors.systemGrey4,
          child: Icon(
            Icons.person_rounded,
            size: 50,
            color: CupertinoColors.white,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: CupertinoTheme.of(context)
                  .textTheme
                  .navLargeTitleTextStyle
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: CupertinoTheme.of(context)
                  .textTheme
                  .textStyle
                  .copyWith(color: CupertinoColors.systemGrey),
            ),
          ],
        ),
      ],
    );
  }
}

class CompostingStatistics extends StatelessWidget {
  final String dateJoined;
  final dynamic totalContributions;
  final dynamic rewardsEarned;

  const CompostingStatistics({
    Key? key,
    required this.dateJoined,
    required this.totalContributions,
    required this.rewardsEarned,
  }) : super(key: key);

  String _formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatCard(title: "Date Joined", value: _formatDate(dateJoined)),
        StatCard(title: "Total Contributions", value: totalContributions),
        StatCard(title: "Rewards Earned", value: rewardsEarned),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;

  const StatCard({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 48) / 3,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5),
        boxShadow: const [
          BoxShadow(
            color: CupertinoColors.systemGrey6,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(color: CupertinoColors.systemGrey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.black),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}

class UserDetails extends StatelessWidget {
  final String name;
  final String address;
  final Function(String field, String value) onUpdate;

  const UserDetails({
    Key? key,
    required this.name,
    required this.address,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EditableDetailRow(
          label: "Name",
          value: name,
          onChanged: (newValue) => onUpdate("name", newValue),
        ),
        const SizedBox(height: 12),
        EditableDetailRow(
          label: "Address",
          value: address,
          onChanged: (newValue) => onUpdate("address", newValue),
        ),
      ],
    );
  }
}

class EditableDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Function(String) onChanged;

  const EditableDetailRow({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: CupertinoColors.systemGrey4,
          width: 1,
        ),
      ),
      child: CupertinoTextFormFieldRow(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 16,
        ),
        prefix: Text(
          label,
          style: const TextStyle(
            color: CupertinoColors.systemGrey,
            fontSize: 16,
          ),
        ),
        initialValue: value,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        placeholder: "Enter your $label",
        onChanged: onChanged,
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: CupertinoColors.black),
    );
  }
}
