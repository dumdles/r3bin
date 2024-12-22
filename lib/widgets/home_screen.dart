import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Welcome, Riley!',
          style: TextStyle(fontSize: 16, color: CupertinoColors.black),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            AddressHeader(),
            SizedBox(height: 20),
            PointsCard(),
            SizedBox(height: 20),
            SectionHeader(title: 'Find your nearest Community Deposit Bin'),
            SizedBox(height: 10),
            InfoCard(),
            SizedBox(height: 20),
            SectionHeader(title: 'Latest rewards'),
            SizedBox(height: 10),
            RewardsList(),
            SizedBox(height: 20),
            SectionHeader(title: 'Recent transactions'),
            TransactionList(),
          ],
        ),
      ),
    );
  }
}

class AddressHeader extends StatelessWidget {
  const AddressHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.center,
      child: Row(
        children: [
          Icon(CupertinoIcons.location_solid, size: 20),
          SizedBox(width: 8),
          Text(
            '#11-905, 945 Jurong West Street 91',
            style: TextStyle(fontSize: 16, color: CupertinoColors.black),
          ),
        ],
      ),
    );
  }
}

class PointsCard extends StatelessWidget {
  const PointsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Current Points',
              style: TextStyle(color: CupertinoColors.white)),
          SizedBox(height: 8),
          Text('233',
              style: TextStyle(
                  fontSize: 36,
                  color: CupertinoColors.white,
                  fontWeight: FontWeight.w900)),
          SizedBox(height: 8),
          Text('Keep it up! 20% up from November!',
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

class RewardsList extends StatelessWidget {
  const RewardsList({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          RewardCard(title: '20% off Chye Sim', subtitle: 'NTUC FairPrice'),
          SizedBox(width: 12),
          RewardCard(title: '\$3 Voucher', subtitle: 'Koufu'),
          SizedBox(width: 12),
          RewardCard(title: '\$3 Voucher', subtitle: 'Koufu'),
          SizedBox(width: 12),
          RewardCard(title: '\$3 off any Drink', subtitle: 'Chagee'),
        ],
      ),
    );
  }
}

class RewardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  const RewardCard({Key? key, required this.title, required this.subtitle})
      : super(key: key);

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
              'https://picsum.photos/200/80', // Placeholder image
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
          )
        ],
      ),
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
