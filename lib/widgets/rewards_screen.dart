import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                // Handle search logic if needed
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
            const RewardList(),
          ],
        ),
      ),
    );
  }
}

class RewardList extends StatelessWidget {
  const RewardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rewards = [
      {
        "title": "\$3 off CHAGEE order!",
        "expiry": "Expires 31 December 2024",
        "image":
            "https://marketing-interactive-assets.b-cdn.net/article_images/chagee-returns-to-singapore-revitalised-as-a-modern-tea-bar/1721891441_chagee%20%282%29.jpg", // Replace with actual image URL
      },
      {
        "title": "20% off Happy Sharing Box B",
        "expiry": "Expires 26 December 2024",
        "image":
            "https://cdn.singpromos.com/wp-content/uploads/2020/11/Happy-Sharing-Box.jpg",
      },
      {
        "title": "20% off Fresh Produce",
        "expiry": "Expires 20 December 2024",
        "image":
            "https://cdn.shopify.com/s/files/1/0574/6340/6792/files/Story_Page-01-Tanglin_Mall.jpg?v=1631813153",
      },
    ];

    return Column(
      children: rewards.map((reward) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: GestureDetector(
            onTap: () {
              // Handle reward selection logic
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.systemGrey5),
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
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      reward["image"]!,
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
                          reward["title"]!,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reward["expiry"]!,
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
        );
      }).toList(),
    );
  }
}
