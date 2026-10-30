import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutriguardapp/forgetpassword.dart';
import 'package:nutriguardapp/health.dart';
import 'package:nutriguardapp/homepage.dart';
import 'package:nutriguardapp/signup_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

int? userId;
String? loggedInUserName;

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryBlue = Theme.of(context).primaryColor;
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final Dio dio = Dio();
    Future<void> loginUser() async {
      try {
        final response = await dio.post(
          '$baseurl/login',
          data: {
            'email': _emailController.text,
            'password': _passwordController.text,
          },
        );
        userId = response.data['login_id'];
        loggedInUserName = response.data['user']?['name']?.toString();
        bool isCompleted = response.data['is_profile_completed'];
        print(isCompleted);
        print(userId);
        print("#####################,${response.data}");
        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful')),
          );
          if (!isCompleted) {
            //direct user to fillup into health screenR
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => HealthProfileScreen()),
              (route) => false,
            );
          } else {
            //when the user already completed the page so go into the home page
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeDashboard()),
              (route) => false,
            );
          }
        }
      } catch (e) {
        print(e);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Registration failed')));
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      // The AppBar automatically gives us a clean back button!
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryBlue),
      ),
      body: Center(
        // Makes the screen scrollable when the keyboard appears
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // 1. Headers
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Login to continue',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),

                // 2. Input Fields
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Email Address',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                ),
                const SizedBox(height: 16),

                // 3. Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: primaryBlue),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 4. Login Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      loginUser();
                    }
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 40),

                // 5. Social Login Section
                const Text(
                  'Or continue with',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(Icons.g_mobiledata),
                    const SizedBox(width: 16),
                    _buildSocialButton(Icons.apple),
                    const SizedBox(width: 16),
                    _buildSocialButton(Icons.facebook),
                  ],
                ),
                const SizedBox(height: 30),

                // 6. Footer Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateAccountScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create clean, rounded input fields
  //  Widget _buildTextField({
  //     required TextEditingController controller,
  //      String hint,
  //    bool isPassword,
  //     TextInputType keyboardType = TextInputType.text,
  //   }){
  //     return TextFormField(controller: controller,
  //       obscureText: isPassword,
  //       decoration: InputDecoration(
  //         hintText: hint,
  //         hintStyle: const TextStyle(color: Colors.grey),
  //         filled: true,
  //         fillColor: const Color(0xFFF9FAFB), // Very light grey background
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(12),
  //           borderSide: BorderSide(color: Colors.grey.shade300),
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(12),
  //           borderSide: BorderSide(color: Colors.grey.shade300),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(12),
  //           borderSide: BorderSide(color: Theme.of(context).primaryColor),
  //         ),
  //       ),
  //     );
  //   }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextFormField(
      controller: controller,

      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.black12, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF1E75C9), width: 1.5),
        ),
      ),
    );
  }

  // Helper method for social buttons (reused from Welcome Screen)
  Widget _buildSocialButton(IconData icon) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFF1E3A8A), size: 32),
        onPressed: () {},
      ),
    );
  }
}
