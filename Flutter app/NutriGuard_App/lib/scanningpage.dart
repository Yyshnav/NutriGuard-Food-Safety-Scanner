import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutriguardapp/login_page.dart';
import 'package:nutriguardapp/resultofscannig_page.dart';
import 'package:nutriguardapp/signup_page.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  Future<void> _uploadAndAnalyze(
    BuildContext context, {
    String? imagePath,
    String? textInput,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Color(0xFF0284C7)),
                SizedBox(height: 16),
                Text(
                  'AI analyzing ingredients for your family...',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      FormData formData;
      if (imagePath != null) {
        formData = FormData.fromMap({
          'image': await MultipartFile.fromFile(imagePath),
        });
      } else {
        formData = FormData.fromMap({
          'product_name': textInput ?? '',
        });
      }

      final response = await Dio().post(
        '$baseurl/scan-food/$userId',
        data: formData,
      );

      if (context.mounted) Navigator.pop(context); // close loading

      if (response.statusCode == 200 && response.data['data'] != null) {
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnalysisResultScreen(
                data: Map<String, dynamic>.from(response.data['data']),
              ),
            ),
          );
        }
      } else {
        throw Exception(response.data['error'] ?? 'Scan analysis failed');
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error analyzing product: $e')),
        );
      }
    }
  }

  Future<void> _scanFromCamera(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (picked != null && context.mounted) {
        await _uploadAndAnalyze(context, imagePath: picked.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camera error: $e')),
        );
      }
    }
  }

  Future<void> _scanFromGallery(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked != null && context.mounted) {
        await _uploadAndAnalyze(context, imagePath: picked.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gallery error: $e')),
        );
      }
    }
  }

  void _showManualSearch(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter Food / Ingredients'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'e.g. Peanut Butter Cookies, wheat, roasted peanuts, salt...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              Navigator.pop(ctx);
              if (text.isNotEmpty) {
                _uploadAndAnalyze(context, textInput: text);
              }
            },
            child: const Text('Analyze with AI'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primarySkyBlue = Color(0xFF0284C7); 
    const healthGreen = Color(0xFF249B62);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black87,
              child: const Center(
                child: Icon(Icons.camera_alt, color: Colors.white24, size: 100),
              ),
            ),
          ),

          Center(
            child: SizedBox(
              width: 280,
              height: 320,
              child: Stack(
                children: [
                  Positioned(top: 0, left: 0, child: _buildCorner(healthGreen, 0)),
                  Positioned(top: 0, right: 0, child: _buildCorner(healthGreen, 1)),
                  Positioned(bottom: 0, right: 0, child: _buildCorner(healthGreen, 2)),
                  Positioned(bottom: 0, left: 0, child: _buildCorner(healthGreen, 3)),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Text(
                    'Scan Food',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.keyboard, color: Colors.white),
                      onPressed: () => _showManualSearch(context),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 24, bottom: 40, left: 24, right: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Capture package or pick from gallery for AI check',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.image, color: primarySkyBlue, size: 30),
                            onPressed: () => _scanFromGallery(context),
                          ),
                          const Text('Gallery', style: TextStyle(fontSize: 12, color: primarySkyBlue)),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => _scanFromCamera(context),
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: primarySkyBlue, width: 4),
                          ),
                          child: Center(
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: const BoxDecoration(
                                color: primarySkyBlue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 30),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.search, color: Colors.grey, size: 30),
                            onPressed: () => _showManualSearch(context),
                          ),
                          const Text('Search', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(Color color, int rotationQuadrant) {
    return RotatedBox(
      quarterTurns: rotationQuadrant,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: color, width: 6),
            left: BorderSide(color: color, width: 6),
          ),
        ),
      ),
    );
  }
}
