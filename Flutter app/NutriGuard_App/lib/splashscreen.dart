import 'package:flutter/material.dart';
import 'package:nutriguardapp/onboarding.dart'; // Adjust based on your actual path

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  // Wait 3 seconds, then go to Onboarding automatically
  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Set extendBodyBehindAppBar to true if you want the image behind the AppBar
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        // I removed the text so it doesn't overlap your custom image's design
        backgroundColor: Colors.transparent, // Makes the app bar see-through
        elevation: 0,
      ),
      // 2. Use a Stack to layer the loading indicator ON TOP of the full-screen image
      body: Stack(
        fit: StackFit.expand, // Forces the stack to fill the whole screen
        children: [
          // Bottom Layer: The Splash Image
          Image.asset(
            'assets/images/frontpage.png', 
            fit: BoxFit.cover, // Scales the image to fill the screen
          ),
          
          // Top Layer: The Loading Indicator
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 80.0), // Pushes the indicator up from the very bottom
              child: CircularProgressIndicator(
                color: Color(0xFF1B8A5A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}