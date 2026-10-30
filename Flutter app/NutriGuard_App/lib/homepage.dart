import 'package:flutter/material.dart';
import 'package:nutriguardapp/familydashboard.dart';
import 'package:nutriguardapp/profile_dashboard.dart';
// IMPORTANT: Verify these file names exactly match your project files!
import 'package:nutriguardapp/scanningpage.dart'; 
import 'package:nutriguardapp/chatbotscreen.dart';
import 'package:nutriguardapp/view_recently_scanned.dart';
import 'package:dio/dio.dart';
import 'package:nutriguardapp/login_page.dart';
import 'package:nutriguardapp/signup_page.dart';

// Your Profile screen file

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final int _selectedIndex = 0; // Home is always index 0
  List<Map<String, dynamic>> _recentScans = [];
  String _userName = loggedInUserName ?? 'User';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchRecentScans();
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text('Are you sure you want to log out of NutriGuard?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                userId = null;
                loggedInUserName = null;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchUserData() async {
    if (userId == null) return;
    try {
      final res = await Dio().get('$baseurl/healthprofile/$userId');
      if (res.statusCode == 200 && res.data['user'] is Map) {
        final name = res.data['user']['name']?.toString();
        if (name != null && name.trim().isNotEmpty) {
          if (!mounted) return;
          setState(() {
            _userName = name.trim();
            loggedInUserName = _userName;
          });
        }
      }
    } catch (e) {
      print("Error fetching user data in home: $e");
    }
  }

  Future<void> _fetchRecentScans() async {
    if (userId == null) return;
    try {
      final res = await Dio().get('$baseurl/recent-scans/$userId');
      if (res.statusCode == 200 && res.data['scans'] is List) {
        if (!mounted) return;
        setState(() {
          _recentScans = List<Map<String, dynamic>>.from(res.data['scans']);
        });
      }
    } catch (e) {
      print("Error fetching recent scans: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    const primarySkyBlue = Color(0xFF0284C7); 
    const appBackgroundSky = Color(0xFFF0F9FF); 
    const cardAccentSky = Color(0xFFE0F2FE); 
    const healthGreen = Color(0xFF249B62); 

    return Scaffold(
      backgroundColor: appBackgroundSky,
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
        },
        backgroundColor: primarySkyBlue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.chat_bubble),
      ),

      // CONNECTED TO ALL PAGES
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, 
        backgroundColor: Colors.white,
        selectedItemColor: primarySkyBlue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ScanScreen())).then((_) => _fetchRecentScans());
          } 
          else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FamilyMembersScreen()));
          }
          else if (index == 3) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
          }
          else if (index == 4) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon : Icon(Icons.qr_code_scanner), label: 'Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.family_restroom_outlined), activeIcon: Icon(Icons.family_restroom), label: 'Family'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.health_and_safety, color: healthGreen, size: 28),
                      const SizedBox(width: 8),
                      const Text(
                        'NutriGuard',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primarySkyBlue,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const FamilyMembersScreen()));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(color: primarySkyBlue.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                            ],
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 10,
                                backgroundColor: cardAccentSky,
                                child: Icon(Icons.person, size: 12, color: primarySkyBlue),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _userName.isNotEmpty ? _userName : 'Me',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: primarySkyBlue),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.keyboard_arrow_right, size: 18, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _showLogoutDialog(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.red.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))
                            ],
                          ),
                          child: const Icon(Icons.logout, size: 18, color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Greeting
              Text(
                'Hello, $_userName 👋',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primarySkyBlue),
              ),
              const SizedBox(height: 4),
              const Text(
                "Let's make healthier choices together.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search food products, brands...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white, 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Main Scan Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardAccentSky, 
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.qr_code_scanner, color: primarySkyBlue, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Scan Packaged Food',
                                style: TextStyle(
                                  color: primarySkyBlue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Get AI-powered analysis in seconds',
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: primarySkyBlue,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () async {
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => const ScanScreen()));
                          _fetchRecentScans();
                        }, 
                        icon: const Icon(Icons.qr_code_scanner_outlined, color: Colors.white)
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Features List
              const Text(
                'What NutriGuard Helps You With',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primarySkyBlue),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 140, 
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildFeatureCard('Nutrition\nAnalysis', Icons.fact_check, Colors.blue),
                    _buildFeatureCard('Ingredient\nCheck', Icons.science, Colors.orange),
                    _buildFeatureCard('Personalized\nAdvice', Icons.person_pin, primarySkyBlue),
                    _buildFeatureCard('Healthier\nAlternatives', Icons.star, Colors.purple),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Health Tip
              const Text(
                "Today's Health Tip",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primarySkyBlue),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cardAccentSky, width: 2), 
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: Colors.orange, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Try to choose products with less than 5g of added sugar per serving for a healthier you!',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Recently Scanned
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recently Scanned',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primarySkyBlue),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductListScreen(pageTitle: 'Recently Scanned',)));
                    },
                    child: const Text('View All', style: TextStyle(color: healthGreen)),
                  ),
                ],
              ),
              
              if (_recentScans.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'No products scanned yet. Tap Scan above to start!',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _recentScans.length > 3 ? 3 : _recentScans.length,
                  itemBuilder: (context, index) {
                    final item = _recentScans[index];
                    final title = item['name']?.toString() ?? 'Packaged Food';
                    final scoreVal = int.tryParse(item['health_score']?.toString() ?? '') ?? 50;
                    Color color = healthGreen;
                    if (scoreVal < 40) {
                      color = Colors.red;
                    } else if (scoreVal < 70) {
                      color = Colors.orange;
                    }
                    return _buildRecentScanCard(title, "$scoreVal/100", color);
                  },
                ),
              const SizedBox(height: 60), 
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, Color iconColor) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 30),
          const Spacer(),
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildRecentScanCard(String title, String score, Color scoreColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            height: 40, width: 40,
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.image, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text("Health Score  ", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(score, style: TextStyle(color: scoreColor, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}