import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        title: const Text("Claim Reward?"),
        content: Column(
          children: [
            const SizedBox(height: 5),
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
            Text(reward['name'],
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 5),
            Text(reward['description']),
            const SizedBox(height: 16),
            Text(
              "Merchant: ${reward['merchant']}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
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
      final rewardDoc = _firestore
          .collection('rewards')
          .doc(reward['name']); // Use a unique ID
      await rewardDoc.update({'claimed': true});
      Navigator.of(context).pop(); // Close the dialog
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("Success"),
          content: const Text("You have claimed the reward!"),
          actions: [
            CupertinoDialogAction(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
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
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: rewards.map((reward) {
              return GestureDetector(
                onTap: () => _showRewardDetails(reward),
                child: RewardCard(
                  title: reward['name'],
                  subtitle: reward['merchant'],
                  imageUrl: reward['imageUrl'],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class RewardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;

  const RewardCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 170,
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: CupertinoColors.systemGrey5),
        boxShadow: const [
          BoxShadow(
            color: CupertinoColors.systemGrey5,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: CupertinoColors.black),
                ),
                Text(subtitle,
                    style: const TextStyle(color: CupertinoColors.systemGrey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
