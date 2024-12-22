import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'widgets/home_screen.dart';
import 'widgets/profile_screen.dart';
import 'widgets/recent_activity_screen.dart';
import 'widgets/rewards_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.activeGreen,
      ),
      home: _getInitialScreen(), // Set the initial screen dynamically
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/home':
            return CupertinoPageRoute(builder: (_) => const TabScaffold());
          case '/login':
            return CupertinoPageRoute(builder: (_) => const LoginScreen());
          case '/signup':
            return CupertinoPageRoute(builder: (_) => const SignupScreen());
          default:
            return CupertinoPageRoute(builder: (_) => const TabScaffold());
        }
      },
    );
  }

  Widget _getInitialScreen() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is logged in, show the home screen
      return const TabScaffold();
    } else {
      // User is not logged in, show the login screen
      return const LoginScreen();
    }
  }
}

class TabScaffold extends StatelessWidget {
  const TabScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_rounded),
            label: 'Live Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_rounded),
            label: 'Points',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            switch (index) {
              case 0:
                return const HomeScreen();
              case 1:
                return const Center(child: Text('Live Data'));
              case 2:
                return const RewardsScreen();
              case 3:
                return const RecentActivityScreen();
              case 4:
                return const ProfileScreen();
              default:
                return const HomeScreen();
            }
          },
        );
      },
    );
  }
}
