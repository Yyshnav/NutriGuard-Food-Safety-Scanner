import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutriguardapp/familydashboard.dart';
import 'package:nutriguardapp/homepage.dart';
import 'package:nutriguardapp/login_page.dart';
import 'package:nutriguardapp/profile_dashboard.dart';
import 'package:nutriguardapp/scanningpage.dart';
import 'package:nutriguardapp/signup_page.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  final int _selectedIndex = 3; // Chat tab is index 3
  bool _isTyping = false;
  String? _selectedImagePath;

  final List<Map<String, dynamic>> _messages = [
    {
      "text": "Hello! I am NutriGuard AI, your personal food and family nutrition assistant 🛡️\n\nAsk me about any packaged food, recipe, or ingredient. I will check for allergens and health risks for you and your registered family members!",
      "isUser": false,
      "imagePath": null,
    },
  ];

  final List<String> _quickPrompts = [
    "Are peanut cookies safe for us?",
    "Check milk & dairy allergens",
    "Is high sodium soup safe?",
    "Healthy snack recommendations",
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 75,
        maxWidth: 1024,
      );
      if (picked != null) {
        setState(() {
          _selectedImagePath = picked.path;
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt, color: Color(0xFF0284C7)),
                  ),
                  title: const Text('Take Photo', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Capture food packaging or ingredients'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                    child: const Icon(Icons.image, color: Color(0xFF0284C7)),
                  ),
                  title: const Text('Upload Image', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Choose food photo from gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Fallback to direct Gemini API call if backend is offline
  Future<String> _geminiDirectFallback(String userMessage, String? imagePath) async {
    const geminiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: 'YOUR_GEMINI_API_KEY');
    final models = ["models/gemini-3.5-flash-lite", "models/gemini-3.8-flash"];

    List<dynamic> parts = [];
    if (imagePath != null) {
      try {
        final bytes = await File(imagePath).readAsBytes();
        final b64 = base64Encode(bytes);
        parts.add({
          "inline_data": {
            "mime_type": "image/jpeg",
            "data": b64,
          }
        });
      } catch (_) {}
    }

    parts.add({
      "text": "You are NutriGuard AI, an expert food safety and dietary assistant. Evaluate this food or question for allergens, warnings, health risks, and nutrition tips.\n\nUser Question: $userMessage"
    });

    for (final m in models) {
      try {
        final res = await Dio().post(
          "https://generativelanguage.googleapis.com/v1beta/$m:generateContent?key=$geminiKey",
          data: {
            "contents": [{"parts": parts}]
          },
        );
        if (res.statusCode == 200) {
          final text = res.data['candidates']?[0]?['content']?['parts']?[0]?['text'];
          if (text != null && text.toString().isNotEmpty) {
            return text.toString();
          }
        }
      } catch (e) {
        debugPrint("Gemini fallback error with $m: $e");
      }
    }
    return "I could not analyze this at the moment. Please verify your internet connection and try again.";
  }

  Future<void> _sendMessage({String? customText}) async {
    final text = customText ?? _messageController.text.trim();
    final imagePath = _selectedImagePath;

    if (text.isEmpty && imagePath == null) return;

    setState(() {
      _messages.add({
        "text": text.isEmpty ? "Analyze this image for my family" : text,
        "isUser": true,
        "imagePath": imagePath,
      });
      _messageController.clear();
      _selectedImagePath = null;
      _isTyping = true;
    });

    _scrollToBottom();

    String aiResponse = "";

    try {
      final dio = Dio();
      final formDataMap = <String, dynamic>{
        'message': text,
      };

      if (imagePath != null) {
        formDataMap['image'] = await MultipartFile.fromFile(
          imagePath,
          filename: 'chat_food.jpg',
        );
      }

      final response = await dio.post(
        '$baseurl/chatbot/$userId',
        data: FormData.fromMap(formDataMap),
      );

      if (response.statusCode == 200 && response.data['reply'] != null) {
        aiResponse = response.data['reply'].toString();
      } else {
        aiResponse = await _geminiDirectFallback(text, imagePath);
      }
    } catch (e) {
      debugPrint("Backend chat failed, switching to direct Gemini fallback: $e");
      aiResponse = await _geminiDirectFallback(text, imagePath);
    }

    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add({
          "text": aiResponse,
          "isUser": false,
          "imagePath": null,
        });
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    const primarySkyBlue = Color(0xFF0284C7);
    const appBackgroundSky = Color(0xFFF0F9FF);
    const aiBubbleColor = Color(0xFFE0F2FE);

    return Scaffold(
      backgroundColor: appBackgroundSky,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeDashboard()),
            );
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.auto_awesome, color: primarySkyBlue, size: 20),
            SizedBox(width: 8),
            Text(
              'NutriGuard AI Chat',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primarySkyBlue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeDashboard()));
          } else if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ScanScreen()));
          } else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FamilyMembersScreen()));
          } else if (index == 4) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.family_restroom_outlined), activeIcon: Icon(Icons.family_restroom), label: 'Family'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: Column(
        children: [
          // Quick prompt chips
          if (_messages.length <= 2)
            Container(
              height: 44,
              margin: const EdgeInsets.only(top: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _quickPrompts.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFBAE6FD)),
                      label: Text(
                        _quickPrompts[i],
                        style: const TextStyle(fontSize: 12, color: primarySkyBlue, fontWeight: FontWeight.w600),
                      ),
                      onPressed: () => _sendMessage(customText: _quickPrompts[i]),
                    ),
                  );
                },
              ),
            ),

          // Main Chat List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator(primarySkyBlue, aiBubbleColor);
                }

                final message = _messages[index];
                final isUser = message["isUser"] as bool;
                final text = message["text"] as String;
                final imgPath = message["imagePath"] as String?;

                return _buildChatBubble(
                  text: text,
                  isUser: isUser,
                  imagePath: imgPath,
                  primarySkyBlue: primarySkyBlue,
                  aiBubbleColor: aiBubbleColor,
                );
              },
            ),
          ),

          // Selected Image Preview bar
          if (_selectedImagePath != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(_selectedImagePath!),
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Image attached for analysis',
                      style: TextStyle(fontSize: 13, color: Colors.blueGrey, fontWeight: FontWeight.w500),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red, size: 20),
                    onPressed: () {
                      setState(() {
                        _selectedImagePath = null;
                      });
                    },
                  ),
                ],
              ),
            ),

          // Bottom Input Area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt_outlined, color: primarySkyBlue),
                    onPressed: _showAttachmentOptions,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask about food safety or ingredients...',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _isTyping ? null : () => _sendMessage(),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _isTyping ? Colors.grey : primarySkyBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(Color primaryColor, Color aiBubbleColor) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: aiBubbleColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 14,
              width: 14,
              child: CircularProgressIndicator(strokeWidth: 2, color: primaryColor),
            ),
            const SizedBox(width: 10),
            Text(
              'Checking family allergy profiles...',
              style: TextStyle(color: primaryColor, fontSize: 13, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble({
    required String text,
    required bool isUser,
    required String? imagePath,
    required Color primarySkyBlue,
    required Color aiBubbleColor,
  }) {
    final bool hasWarning = !isUser && (text.contains('⚠️') || text.toLowerCase().contains('warning') || text.toLowerCase().contains('not safe') || text.toLowerCase().contains('allergic'));

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? primarySkyBlue
              : (hasWarning ? const Color(0xFFFFFBEB) : aiBubbleColor),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
          border: hasWarning ? Border.all(color: const Color(0xFFFDE68A)) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imagePath != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(imagePath),
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (!isUser && hasWarning) ...[
              Row(
                children: const [
                  Icon(Icons.warning_amber_rounded, size: 16, color: Color(0xFFD97706)),
                  SizedBox(width: 6),
                  Text(
                    'NutriGuard Safety Alert',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD97706),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],
            Text(
              text,
              style: TextStyle(
                color: isUser ? Colors.white : const Color(0xFF0F2942),
                fontSize: 14,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
