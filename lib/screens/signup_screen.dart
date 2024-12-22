import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _signupUser() async {
    // Check if fields are not empty
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      _showErrorDialog("Fields cannot be empty");
      return;
    }

    // Start the loading state
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? newUser = userCredential.user;

      // Save user data to Firestore
      if (newUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(newUser.uid)
            .set({
          'name': 'New User',
          'email': newUser.email,
          'dateJoined': DateTime.now().toIso8601String(),
          'totalContributions': 0,
          'rewardsEarned': 0,
          'address': 'Enter your address',
        });
      }

      // Navigate to the home screen upon successful signup
      Navigator.of(context).pushReplacementNamed('/home');
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      String errorMessage = "An unknown error occurred";
      if (e.code == 'email-already-in-use') {
        errorMessage = "This email is already in use";
      } else if (e.code == 'weak-password') {
        errorMessage = "The password is too weak";
      } else if (e.code == 'invalid-email') {
        errorMessage = "The email address is not valid";
      }

      _showErrorDialog(errorMessage);
    } catch (e) {
      // Handle other errors
      _showErrorDialog(e.toString());
    } finally {
      // Stop the loading state
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Signup Failed"),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: CupertinoColors.systemGrey5),
            boxShadow: const [
              BoxShadow(
                color: CupertinoColors.systemGrey6,
                blurRadius: 20,
                offset: Offset(0, 20),
              ),
            ],
          ),
          width: MediaQuery.of(context).size.width * 0.40,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Name and Subtitle
              const Text(
                "R3BIN",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.activeGreen,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Create an Account",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: CupertinoColors.systemGrey,
                ),
              ),
              const SizedBox(height: 20),
              // Email Field
              CupertinoTextField(
                controller: _emailController,
                placeholder: "Email",
                keyboardType: TextInputType.emailAddress,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),
              // Password Field
              CupertinoTextField(
                controller: _passwordController,
                placeholder: "Password",
                obscureText: true,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),
              // Loading Indicator or Signup Button
              _isLoading
                  ? const CupertinoActivityIndicator()
                  : CupertinoButton.filled(
                      onPressed: _signupUser,
                      child: const Text("Sign Up"),
                    ),
              // Login Button
              CupertinoButton(
                child: const Text("Already have an account? Log in"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
