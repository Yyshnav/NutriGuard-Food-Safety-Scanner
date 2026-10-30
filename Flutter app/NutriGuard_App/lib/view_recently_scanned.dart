import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutriguardapp/login_page.dart';
import 'package:nutriguardapp/signup_page.dart';

class ProductListScreen extends StatefulWidget {
  final String pageTitle;

  const ProductListScreen({super.key, required this.pageTitle});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchScans();
  }

  Future<void> fetchScans() async {
    if (userId == null) {
      setState(() => isLoading = false);
      return;
    }
    try {
      final res = await Dio().get('$baseurl/recent-scans/$userId');
      if (res.statusCode == 200 && res.data['scans'] is List) {
        if (!mounted) return;
        setState(() {
          products = List<Map<String, dynamic>>.from(res.data['scans']);
          isLoading = false;
        });
        return;
      }
    } catch (e) {
      print("Error fetching all scans: $e");
    }
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primarySkyBlue = Color(0xFF0284C7);
    const appBackgroundSky = Color(0xFFF0F9FF);
    const healthGreen = Color(0xFF249B62);

    return Scaffold(
      backgroundColor: appBackgroundSky,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: primarySkyBlue, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.pageTitle,
          style: const TextStyle(color: primarySkyBlue, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: primarySkyBlue))
            : products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code_scanner, size: 60, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          'No scanned products yet',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Scan packaged foods to view your history here.',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: fetchScans,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: products.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final scoreVal = int.tryParse(product["health_score"]?.toString() ?? '') ?? 50;
                        Color scoreColor = healthGreen;
                        if (scoreVal < 40) {
                          scoreColor = Colors.redAccent;
                        } else if (scoreVal < 70) {
                          scoreColor = Colors.orange;
                        }

                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: primarySkyBlue.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0F2FE),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.fastfood_outlined, color: primarySkyBlue),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product["name"] ?? 'Product',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Scanned: ${product["date"] ?? 'Recently'}",
                                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: scoreColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  product["score"] ?? "$scoreVal/100",
                                  style: TextStyle(color: scoreColor, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
