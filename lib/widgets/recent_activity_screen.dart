import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecentActivityScreen extends StatelessWidget {
  const RecentActivityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Recent Activity", style: TextStyle(color: Colors.black)),
      ),
      child: SafeArea(
        child: ListView(
          children: const [
            DateSeparator(date: 'Today'),
            ActivityItem(
              title: 'Waste deposit',
              subtitle: 'Nanyang Community Centre',
              points: '+10',
              isCompost: true,
            ),
            ActivityItem(
              title: 'Redeemed \$3 Voucher',
              subtitle: '10:45 AM',
              points: '-300',
              isCompost: false,
            ),
            DateSeparator(date: 'Yesterday'),
            ActivityItem(
              title: 'Waste deposit',
              subtitle: 'Taman Jurong Community Centre',
              points: '+10',
              isCompost: true,
            ),
          ],
        ),
      ),
    );
  }
}

class DateSeparator extends StatelessWidget {
  final String date;
  const DateSeparator({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        date,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: CupertinoColors.systemGrey,
        ),
      ),
    );
  }
}

class ActivityItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String points;
  final bool isCompost;

  const ActivityItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.points,
    required this.isCompost,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        border: Border.all(color: CupertinoColors.systemGrey5),
        borderRadius: BorderRadius.circular(12),
        color: CupertinoColors.white,
        boxShadow: const [
          BoxShadow(
            color: CupertinoColors.systemGrey6,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isCompost
                  ? CupertinoColors.systemGreen.withOpacity(0.1)
                  : CupertinoColors.systemGrey6,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isCompost ? Icons.eco_rounded : Icons.savings_rounded,
              color: isCompost
                  ? CupertinoColors.systemGreen
                  : CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 20)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(
                        color: CupertinoColors.systemGrey, fontSize: 15)),
              ],
            ),
          ),
          Text(points,
              style: TextStyle(
                color: isCompost
                    ? CupertinoColors.systemGreen
                    : CupertinoColors.systemRed,
                fontWeight: FontWeight.w400,
              )),
        ],
      ),
    );
  }
}
