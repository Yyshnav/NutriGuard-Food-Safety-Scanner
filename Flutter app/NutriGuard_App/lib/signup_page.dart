import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutriguardapp/login_page.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

String baseurl = "http://192.168.29.79:5000";

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final Dio dio = Dio();
  Future<void> registerUser() async {
    try {
      final response = await dio.post(
        '$baseurl/register',
        data: {
          'name': _fullNameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful')),
        );
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
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

  // State Variables
  bool _isTermsAccepted = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 10.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title & Subtitle
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Start Your Health Guard Today',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 28),

                  // Full Name Input
                  _buildTextField(
                    controller: _fullNameController,
                    hintText: 'Full Name',
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16),

                  // Email Input
                  _buildTextField(
                    controller: _emailController,
                    hintText: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Password Input
                  _buildTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password Input
                  _buildTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Terms & Conditions Checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _isTermsAccepted,
                          activeColor: const Color(0xFF0D529C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _isTermsAccepted = value ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Wrap(
                          children: const [
                            Text(
                              'I agree to the ',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Terms & Conditions',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF0D529C),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              ' and ',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Privacy Policy',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF0D529C),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E75C9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          registerUser();
                          if (!_isTermsAccepted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please accept Terms & Conditions to proceed',
                                ),
                              ),
                            );
                            return;
                          }

                          // Handle Registration
                        }
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Divider Text
                  const Text(
                    'Or continue with',
                    style: TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                  const SizedBox(height: 20),

                  // Social Login Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(
                        child: const Text(
                          'G',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                        onTap: () {},
                      ),
                      const SizedBox(width: 16),
                      _buildSocialButton(
                        child: const Icon(
                          Icons.apple,
                          color: Colors.black,
                          size: 26,
                        ),
                        onTap: () {},
                      ),
                      const SizedBox(width: 16),
                      _buildSocialButton(
                        child: const Icon(
                          Icons.facebook,
                          color: Color(0xFF1877F2),
                          size: 26,
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Text Field Builder Widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        fillColor: Colors.white,
        filled: true,
        suffixIcon: suffixIcon,
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

  // Social Button Helper Widget
  Widget _buildSocialButton({
    required Widget child,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 65,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black12, width: 1),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
