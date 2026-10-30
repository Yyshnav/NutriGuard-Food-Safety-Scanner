import 'package:flutter/material.dart';
import 'package:nutriguardapp/changepassword.dart';
import 'package:nutriguardapp/login_page.dart';
import 'package:nutriguardapp/privacy_security_screen.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  // Settings States
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English'; 

  // --- Show Language Selection Bottom Sheet ---
  void _showLanguageSelector() {
    final List<String> languages = ['English', 'Malayalam', 'Hindi', 'Spanish', 'French'];
    const primarySkyBlue = Color(0xFF0284C7);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40, height: 4, margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2)),
                ),
                const Text('App Language', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 16),
                
                // Generates a list of languages to pick from
                ...languages.map((language) {
                  final isSelected = _selectedLanguage == language;
                  return ListTile(
                    title: Text(
                      language,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? primarySkyBlue : Colors.black87,
                      ),
                    ),
                    trailing: isSelected ? const Icon(Icons.check_circle, color: primarySkyBlue) : null,
                    onTap: () {
                      setState(() {
                        _selectedLanguage = language;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Language changed to $language')),
                      );
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const primarySkyBlue = Color(0xFF0284C7);
    const appBackgroundSky = Color(0xFFF0F9FF);

    return Scaffold(
      backgroundColor: appBackgroundSky,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: primarySkyBlue, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'App Settings',
          style: TextStyle(color: primarySkyBlue, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text("Preferences", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
            const SizedBox(height: 12),
            _buildSettingsCard([
              _buildSwitchTile(
                icon: Icons.notifications_active_outlined,
                title: "Push Notifications",
                value: _notificationsEnabled,
                onChanged: (val) => setState(() => _notificationsEnabled = val),
              ),
              const Divider(height: 1, indent: 50, color: Color(0xFFF0F9FF)),
              _buildSwitchTile(
                icon: Icons.dark_mode_outlined,
                title: "Dark Mode",
                value: _darkModeEnabled,
                onChanged: (val) => setState(() => _darkModeEnabled = val),
              ),
              const Divider(height: 1, indent: 50, color: Color(0xFFF0F9FF)),
              // NEW: Language Selector Tile
              _buildNavTile(
                icon: Icons.language,
                title: "Language",
                trailingText: _selectedLanguage, // Shows currently selected language
                onTap: _showLanguageSelector,
              ),
            ]),
            
            const SizedBox(height: 24),
            const Text("Account & Security", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
            const SizedBox(height: 12),
            _buildSettingsCard([
              _buildNavTile(icon: Icons.lock_outline, title: "Change Password", onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
              }),
              const Divider(height: 1, indent: 50, color: Color(0xFFF0F9FF)),
              _buildNavTile(icon: Icons.privacy_tip_outlined, title: "Privacy & Security", onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacySecurityScreen()));

              }),
            ]),

            const SizedBox(height: 24),
            const Text("Support", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
            const SizedBox(height: 12),
            _buildSettingsCard([
              _buildNavTile(icon: Icons.help_outline, title: "Help & Support", onTap: () {}),
              const Divider(height: 1, indent: 50, color: Color(0xFFF0F9FF)),
              _buildNavTile(icon: Icons.info_outline, title: "About NutriGuard", onTap: () {}),
            ]),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.redAccent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  userId = null;
                  loggedInUserName = null;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text("Log Out", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: const Color(0xFF0284C7).withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({required IconData icon, required String title, required bool value, required Function(bool) onChanged}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(color: Color(0xFFE0F2FE), shape: BoxShape.circle),
        child: Icon(icon, color: const Color(0xFF0284C7), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF0284C7),
      ),
    );
  }

  // Updated to support trailing text (like showing "English")
  Widget _buildNavTile({required IconData icon, required String title, String? trailingText, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(color: Color(0xFFE0F2FE), shape: BoxShape.circle),
        child: Icon(icon, color: const Color(0xFF0284C7), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null) 
            Text(trailingText, style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.black26, size: 20),
        ],
      ),
    );
  }
}