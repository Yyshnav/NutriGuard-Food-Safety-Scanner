import 'package:flutter/material.dart';
import 'package:nutriguardapp/login_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // This controller lets us programmatically swipe to the next page
  final PageController _pageController = PageController();
  
  // This is our 'state' variable tracking the current page index
  int _currentPage = 0;

  // Added an "image" key to tie a specific image to each swipeable page
  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Scan Packaged Food",
      "description": "Use our camera to scan the packaged food and get instant details.",
      "image": "assets/images/secondpage.jpeg", 
    },
    {
      "title": "Personalized for You\nand Your Family",
      "description": "Get recommendations based on your health profile and family members (pregnancy, child, etc).",
      "image": "assets/images/thirdpage.jpg", // Replace with your actual 3rd page image name
    }
  ];

  @override
  Widget build(BuildContext context) {
    final primaryBlue = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            // 1. The Swipeable Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                // Update our state variable when the user swipes
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // The image is now INSIDE the PageView so it scrolls!
                        Expanded(
                          child: Image.asset(
                            _onboardingData[index]["image"]!,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // Title Text
                        Text(
                          _onboardingData[index]["title"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Description Text
                        Text(
                          _onboardingData[index]["description"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // 2. Bottom Navigation Section (Dots and Buttons stay fixed at the bottom)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                children: [
                  // The dynamic dot indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => _buildDot(index, context),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // The Main Action Button
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _onboardingData.length - 1) {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                      } else {
                        // Programmatically swipe to the next page
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(34, 50), // Makes button full width
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentPage == _onboardingData.length - 1 ? "Done" : "Next",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // The Skip Button
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // A helper function to draw the dots
  Widget _buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Theme.of(context).primaryColor : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}