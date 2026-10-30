import 'package:flutter/material.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  // Toggle states
  bool _biometricUnlock = false;
  bool _shareAnalytics = true;
  bool _personalizedAi = true;

  @override
  Widget build(BuildContext context) {
    // If you have fully implemented the ThemeProvider from the last step, 
    // you can replace these with: final theme = Provider.of<ThemeProvider>(context);
    const primarySkyBlue = Color(0xFF0284C7);
    const appBackgroundSky = Color(0xFFF0F9FF);
    const cardAccentSky = Color(0xFFE0F2FE);

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
          'Privacy & Security',
          style: TextStyle(color: primarySkyBlue, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Security Section
            const Text("App Security", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
            const SizedBox(height: 12),
            _buildSettingsCard(
              children: [
                _buildSwitchTile(
                  icon: Icons.fingerprint,
                  title: "Biometric Unlock",
                  subtitle: "Use fingerprint or Face ID to open app",
                  value: _biometricUnlock,
                  activeColor: primarySkyBlue,
                  accentColor: cardAccentSky,
                  onChanged: (val) => setState(() => _biometricUnlock = val),
                ),
              ],
              shadowColor: primarySkyBlue,
            ),
            
            const SizedBox(height: 24),

            // Data Privacy Section
            const Text("Data Privacy", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
            const SizedBox(height: 12),
            _buildSettingsCard(
              children: [
                _buildSwitchTile(
                  icon: Icons.psychology_outlined,
                  title: "Personalized AI Insights",
                  subtitle: "Allow AI to use your scan history for better advice",
                  value: _personalizedAi,
                  activeColor: primarySkyBlue,
                  accentColor: cardAccentSky,
                  onChanged: (val) => setState(() => _personalizedAi = val),
                ),
                const Divider(height: 1, indent: 60, color: Color(0xFFF0F9FF)),
                _buildSwitchTile(
                  icon: Icons.analytics_outlined,
                  title: "Share Analytics",
                  subtitle: "Help us improve by sharing anonymous usage data",
                  value: _shareAnalytics,
                  activeColor: primarySkyBlue,
                  accentColor: cardAccentSky,
                  onChanged: (val) => setState(() => _shareAnalytics = val),
                ),
              ],
              shadowColor: primarySkyBlue,
            ),

            const SizedBox(height: 24),

            // Account Data Management Section
            const Text("Your Data", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
            const SizedBox(height: 12),
            _buildSettingsCard(
              children: [
                _buildNavTile(
                  icon: Icons.download_outlined,
                  title: "Download My Data",
                  iconColor: primarySkyBlue,
                  accentColor: cardAccentSky,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Preparing your data... A download link will be emailed to you.')),
                    );
                  },
                ),
                const Divider(height: 1, indent: 60, color: Color(0xFFF0F9FF)),
                _buildNavTile(
                  icon: Icons.delete_outline,
                  title: "Delete Account",
                  iconColor: Colors.redAccent,
                  accentColor: Colors.red.shade50,
                  textColor: Colors.redAccent,
                  onTap: () => _showDeleteConfirmation(context),
                ),
              ],
              shadowColor: primarySkyBlue,
            ),
          ],
        ),
      ),
    );
  }

  // UI Helper for Cards
  Widget _buildSettingsCard({required List<Widget> children, required Color shadowColor}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: shadowColor.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(children: children),
    );
  }

  // UI Helper for Toggles
  Widget _buildSwitchTile({
    required IconData icon, 
    required String title, 
    required String subtitle, 
    required bool value, 
    required Color activeColor,
    required Color accentColor,
    required Function(bool) onChanged
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle),
          child: Icon(icon, color: activeColor, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: activeColor,
        ),
      ),
    );
  }

  // UI Helper for Navigation/Action Rows
  Widget _buildNavTile({
    required IconData icon, 
    required String title, 
    required Color iconColor,
    required Color accentColor,
    Color textColor = Colors.black87,
    required VoidCallback onTap
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor)),
      trailing: const Icon(Icons.chevron_right, color: Colors.black26, size: 20),
    );
  }

  // Delete Account Confirmation Dialog
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Delete Account?", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
          content: const Text(
            "This action is permanent and cannot be undone. All your health profiles, family data, and scan history will be erased.",
            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account deletion requested.')),
                );
              },
              child: const Text("Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}