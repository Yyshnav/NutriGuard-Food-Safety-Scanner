import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  void _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New passwords do not match!'), backgroundColor: Colors.redAccent),
        );
        return;
      }

      setState(() => _isLoading = true);

      // Simulate an API delay
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password updated successfully!'),
            backgroundColor: Color(0xFF249B62), // Health Green
          ),
        );
        Navigator.pop(context); // Go back to settings
      }
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
          'Change Password',
          style: TextStyle(color: primarySkyBlue, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create a strong password to keep your health data secure.",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 32),

                const Text("Current Password", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                const SizedBox(height: 8),
                _buildPasswordField(
                  controller: _currentPasswordController,
                  hintText: 'Enter current password',
                  obscureText: _obscureCurrent,
                  onToggleVisibility: () => setState(() => _obscureCurrent = !_obscureCurrent),
                ),
                
                const SizedBox(height: 24),
                
                const Text("New Password", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                const SizedBox(height: 8),
                _buildPasswordField(
                  controller: _newPasswordController,
                  hintText: 'Enter new password',
                  obscureText: _obscureNew,
                  onToggleVisibility: () => setState(() => _obscureNew = !_obscureNew),
                ),

                const SizedBox(height: 16),

                const Text("Confirm New Password", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                const SizedBox(height: 8),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  hintText: 'Re-enter new password',
                  obscureText: _obscureConfirm,
                  onToggleVisibility: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primarySkyBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                    ),
                    onPressed: _isLoading ? null : _updatePassword,
                    child: _isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Update Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        fillColor: Colors.white,
        filled: true,
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.grey,
            size: 20,
          ),
          onPressed: onToggleVisibility,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}