import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutriguardapp/complaintpage.dart';

import 'package:nutriguardapp/homepage.dart';
import 'package:nutriguardapp/login_page.dart';
import 'package:nutriguardapp/ratingpage.dart';
import 'package:nutriguardapp/saved_product_page.dart';
import 'package:nutriguardapp/scanningpage.dart';
import 'package:nutriguardapp/familydashboard.dart';
import 'package:nutriguardapp/chatbotscreen.dart';
import 'package:nutriguardapp/signup_page.dart';
import 'package:nutriguardapp/view_recently_scanned.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentNavIndex = 4;

  bool _hasProfilePhoto = true;

  final Dio dio = Dio();

  Map<String, dynamic>? userData;

  bool isLoading = true;
  String? errorMessage;

  // Profile values from API
  String name = '';
  String email = '';
  String age = '';
  String gender = '';
  String height = '';
  String weight = '';
  String bmi = '';
  String healthCondition = '';
  String food_allergies = '';

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  // ============================================================
  // GET PROFILE DATA FROM API
  // ============================================================

  Future<void> fetchProfile() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await dio.get('$baseurl/healthprofile/$userId');

      print("PROFILE API RESPONSE: ${response.data}");

      if (response.statusCode == 200 && response.data['message'] == 'success') {
        final user = response.data['user'];

        setState(() {
          userData = Map<String, dynamic>.from(user);

          name = user['name']?.toString() ?? '';
          email = user['email']?.toString() ?? '';
          age = user['age']?.toString() ?? '';
          gender = user['gender']?.toString() ?? '';
          height = user['height']?.toString() ?? '';
          weight = user['weight']?.toString() ?? '';
          bmi = user['bmi'] != null
              ? double.tryParse(user['bmi'].toString())?.toStringAsFixed(2) ??
                    ''
              : '';
          healthCondition = user['health_condition']?.toString() ?? '';
          food_allergies = user['food_allergies']?.toString() ?? '';

          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'User not found';
          isLoading = false;
        });
      }
    } catch (e) {
      print("PROFILE API ERROR: $e");

      setState(() {
        errorMessage = 'Failed to load Profile: $e';
        isLoading = false;
      });
    }
  }
  // ============================================================
  // EDIT BODY DETAILS
  // ============================================================

  void _showEditMetricsSheet() {
    final TextEditingController heightCtrl = TextEditingController(
      text: height,
    );

    final TextEditingController weightCtrl = TextEditingController(
      text: weight,
    );

    const primarySkyBlue = Color(0xFF0284C7);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const Text(
                "Update Body Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primarySkyBlue,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: heightCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Height (cm)",
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: TextField(
                      controller: weightCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Weight (kg)",
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primarySkyBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    if (heightCtrl.text.isNotEmpty &&
                        weightCtrl.text.isNotEmpty) {
                      setState(() {
                        height = heightCtrl.text;
                        weight = weightCtrl.text;
                      });

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Body details updated successfully!'),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // PROFILE IMAGE OPTIONS
  // ============================================================

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 8.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                const Text(
                  'Profile Photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 16),

                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: Color(0xFF0284C7),
                  ),
                  title: const Text(
                    'Choose from Gallery',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    setState(() {
                      _hasProfilePhoto = true;
                    });
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.camera_alt_outlined,
                    color: Color(0xFF0284C7),
                  ),
                  title: const Text(
                    'Take a New Photo',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    setState(() {
                      _hasProfilePhoto = true;
                    });
                  },
                ),

                if (_hasProfilePhoto)
                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                    title: const Text(
                      'Delete Profile Photo',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);

                      setState(() {
                        _hasProfilePhoto = false;
                      });
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // BUILD UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    const primarySkyBlue = Color(0xFF0284C7);
    const appBackgroundSky = Color(0xFFF0F9FF);
    const cardAccentSky = Color(0xFFE0F2FE);

    return Scaffold(
      backgroundColor: appBackgroundSky,

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: primarySkyBlue,
            size: 20,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeDashboard()),
            );
          },
        ),

        title: const Text(
          'My Profile',
          style: TextStyle(
            color: primarySkyBlue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: primarySkyBlue),
            onPressed: _showEditMetricsSheet,
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'Log Out',
            onPressed: () => _confirmLogout(context),
          ),
        ],

        centerTitle: true,
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    ElevatedButton(
                      onPressed: fetchProfile,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12.0,
                ),

                child: Column(
                  children: [
                    // ==================================================
                    // USER HEADER CARD
                    // ==================================================
                    Container(
                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: primarySkyBlue.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => _showImagePickerOptions(context),

                            child: Stack(
                              alignment: Alignment.bottomRight,

                              children: [
                                CircleAvatar(
                                  radius: 45,
                                  backgroundColor: cardAccentSky,

                                  child: Icon(
                                    _hasProfilePhoto
                                        ? Icons.person
                                        : Icons.person_outline,
                                    size: 55,
                                    color: primarySkyBlue,
                                  ),
                                ),

                                Container(
                                  padding: const EdgeInsets.all(8),

                                  decoration: const BoxDecoration(
                                    color: primarySkyBlue,
                                    shape: BoxShape.circle,
                                  ),

                                  child: Icon(
                                    _hasProfilePhoto
                                        ? Icons.edit
                                        : Icons.add_a_photo,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            name.isNotEmpty ? name : 'Name',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            email.isNotEmpty ? email : 'Email',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withOpacity(0.55),
                            ),
                          ),

                          const SizedBox(height: 12),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),

                            decoration: BoxDecoration(
                              color: cardAccentSky,
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: const Text(
                              'Primary Account Holder',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: primarySkyBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ==================================================
                    // PERSONAL INFO
                    // ==================================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        const Text(
                          'Personal Info',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primarySkyBlue,
                          ),
                        ),

                        TextButton.icon(
                          onPressed: _showEditMetricsSheet,

                          icon: const Icon(
                            Icons.edit,
                            size: 16,
                            color: primarySkyBlue,
                          ),

                          label: const Text(
                            "Edit",
                            style: TextStyle(color: primarySkyBlue),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: primarySkyBlue.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: Column(
                        children: [
                          _buildInfoRow(
                            icon: Icons.cake_outlined,
                            label: 'Age',
                            value: age,
                          ),

                          const Divider(
                            height: 1,
                            indent: 50,
                            color: Color(0xFFF0F9FF),
                          ),

                          _buildInfoRow(
                            icon: Icons.male,
                            label: 'Gender',
                            value: gender,
                          ),

                          const Divider(
                            height: 1,
                            indent: 50,
                            color: Color(0xFFF0F9FF),
                          ),

                          _buildInfoRow(
                            icon: Icons.height,
                            label: 'Height',
                            value: height.isNotEmpty ? '$height cm' : '',
                          ),

                          const Divider(
                            height: 1,
                            indent: 50,
                            color: Color(0xFFF0F9FF),
                          ),

                          _buildInfoRow(
                            icon: Icons.monitor_weight_outlined,
                            label: 'Weight',
                            value: weight.isNotEmpty ? '$weight kg' : '',
                          ),
                          const Divider(
                            height: 1,
                            indent: 50,
                            color: Color(0xFFF0F9FF),
                          ),
                          _buildInfoRow(
                            icon: Icons.monitor_weight,
                            label: 'BMI',
                            value: bmi,
                          ),
                          const Divider(
                            height: 1,
                            indent: 50,
                            color: Color(0xFFF0F9FF),
                          ),
                          _buildInfoRow(
                            icon: Icons.favorite,
                            label: 'Health Condition',
                            value: healthCondition,
                          ),
                          const Divider(
                            height: 1,
                            indent: 50,
                            color: Color(0xFFF0F9FF),
                          ),
                          _buildInfoRow(
                            icon: Icons.warning_amber,
                            label: 'Food Allergies',
                            value: food_allergies,
                          ),
                          const Divider(
                            height: 1,
                            indent: 50,
                            color: Color(0xFFF0F9FF),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ==================================================
                    // MY FOOD ACTIVITY
                    // ==================================================
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'My Food Activity',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primarySkyBlue,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    _buildActionTile(
                      icon: Icons.history,
                      title: 'Recently Scanned',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductListScreen(
                              pageTitle: "Recently Scanned",
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    _buildActionTile(
                      icon: Icons.bookmark_border,
                      title: 'Saved Products',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SavedProductsScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // ==================================================
                    // QUICK ACTIONS
                    // ==================================================
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primarySkyBlue,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                     

                    _buildActionTile(
                      icon: Icons.groups_outlined,
                      title: 'Manage Family Members',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FamilyMembersScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 10),
                    
                    
                    _buildActionTile(
                      icon: Icons.report,
                       title: 'Complaints',
                      onTap: () {
                        Navigator.push(
                         context,
                          MaterialPageRoute(
                            builder: (context) => const ComplaintScreen(),
                          ),
                        );
                       },
                    ),
                    const SizedBox(height: 10),

                     _buildActionTile(
                       icon: Icons.favorite_outline,
                       title: 'Rating ',
                       onTap: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (context) => const RatingScreen(),
                           ),
                         );
                       },
                     ),
                    const SizedBox(height: 12),
                    _buildLogoutTile(
                      onTap: () => _confirmLogout(context),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
      ),

      // ============================================================
      // BOTTOM NAVIGATION
      // ============================================================
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,

        backgroundColor: Colors.white,

        selectedItemColor: primarySkyBlue,

        unselectedItemColor: Colors.grey,

        currentIndex: _currentNavIndex,

        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeDashboard()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ScanScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const FamilyMembersScreen(),
              ),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          } else {
            setState(() {
              _currentNavIndex = index;
            });
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.family_restroom_outlined),
            activeIcon: Icon(Icons.family_restroom),
            label: 'Family',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFO ROW
  // ============================================================

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0284C7), size: 22),

          const SizedBox(width: 14),

          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTION TILE
  // ============================================================

  void _confirmLogout(BuildContext context) {
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

  Widget _buildLogoutTile({required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFEE2E2)),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFFEE2E2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.logout, color: Colors.red, size: 20),
          ),
          title: const Text(
            'Log Out',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.redAccent,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0284C7).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),

        child: ListTile(
          onTap: onTap,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),

          leading: Container(
            padding: const EdgeInsets.all(10),

            decoration: const BoxDecoration(
              color: Color(0xFFE0F2FE),
              shape: BoxShape.circle,
            ),

            child: Icon(icon, color: const Color(0xFF0284C7), size: 20),
          ),

          title: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.black26,
            size: 20,
          ),
        ),
      ),
    );
  }
}
