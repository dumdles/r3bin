import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Rewards", style: TextStyle(color: Colors.black)),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CupertinoSearchTextField(
              placeholder: "Search activity",
              onChanged: (value) {
                // Implement search logic if needed
              },
            ),
            const SizedBox(height: 16),
            const Text(
              "Rewards",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 16),
            const RewardsList(),
          ],
        ),
      ),
    );
  }
}

class RewardsList extends StatefulWidget {
  const RewardsList({Key? key}) : super(key: key);

  @override
  State<RewardsList> createState() => _RewardsListState();
}

class _RewardsListState extends State<RewardsList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchRewards() async {
    final rewardsSnapshot = await _firestore.collection('rewards').get();
    return rewardsSnapshot.docs.map((doc) => doc.data()).toList();
  }

  void _showRewardDetails(Map<String, dynamic> reward) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Reward Details"),
        content: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CupertinoColors.systemGrey5),
              ),
              child: Image.network(
                reward['imageUrl'],
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              reward['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 5),
            Text(reward['description']),
            const SizedBox(height: 16),
            Text(
              "Merchant: ${reward['merchant']}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Points Required: ${reward['pointsRequired']}"),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text("Close"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          if (!reward['claimed'])
            CupertinoDialogAction(
              child: const Text("Claim Reward"),
              onPressed: () => _claimReward(reward),
            ),
        ],
      ),
    );
  }

  Future<void> _claimReward(Map<String, dynamic> reward) async {
    try {
      await _firestore.collection('rewards').doc(reward['name']).update({
        'claimed': true,
      });

      Navigator.of(context).pop();

      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("Success"),
          content: const Text("You have claimed this reward!"),
          actions: [
            CupertinoDialogAction(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      setState(() {});
    } catch (e) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("Error"),
          content: Text("Failed to claim reward: $e"),
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
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchRewards(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No rewards available."));
        }

        final rewards = snapshot.data!;

        return Column(
          children: rewards.map((reward) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Stack(
                children: [
                  Opacity(
                    opacity: reward['claimed'] ? 0.5 : 1.0, // Adjust opacity
                    child: GestureDetector(
                      onTap: () => _showRewardDetails(reward),
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: CupertinoColors.systemGrey5),
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: CupertinoColors.systemGrey6,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: Image.network(
                                reward['imageUrl'],
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reward['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: CupertinoColors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${reward['merchant']}",
                                    style: const TextStyle(
                                        color: CupertinoColors.systemGrey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (reward['claimed'])
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemRed,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "REDEEMED",
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
