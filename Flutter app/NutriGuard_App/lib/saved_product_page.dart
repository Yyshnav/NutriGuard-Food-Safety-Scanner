import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:nutriguardapp/login_page.dart';
import 'package:nutriguardapp/signup_page.dart';

class SavedProductsScreen extends StatefulWidget {
  const SavedProductsScreen({super.key});

  @override
  State<SavedProductsScreen> createState() => _SavedProductsScreenState();
}

class _SavedProductsScreenState extends State<SavedProductsScreen> {
  List<Map<String, dynamic>> _savedProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSavedProducts();
  }

  // --- Fetch Saved Products from Backend ---
  Future<void> _fetchSavedProducts() async {
    if (userId == null) {
      setState(() {
        _isLoading = false;
        _savedProducts = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final dio = Dio();
      final response = await dio.get('$baseurl/saved-products/$userId');

      if (response.statusCode == 200 && response.data['message'] == 'success') {
        final List list = response.data['saved_products'] ?? [];
        setState(() {
          _savedProducts = list.map<Map<String, dynamic>>((item) {
            int healthScore = int.tryParse(item['health_score']?.toString() ?? '50') ?? 50;
            Color color = const Color(0xFF249B62);
            if (healthScore < 40) {
              color = const Color(0xFFEF4444);
            } else if (healthScore < 70) {
              color = const Color(0xFFF59E0B);
            }

            return {
              "id": item['id'],
              "name": item['name']?.toString() ?? "Saved Product",
              "score": item['score']?.toString() ?? "$healthScore/100",
              "health_score": healthScore,
              "color": color,
              "brand": item['brand']?.toString() ?? "",
              "ingredients": item['ingredients']?.toString() ?? "",
              "saved_date": item['saved_date']?.toString() ?? "",
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _savedProducts = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching saved products: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // --- Remove Product from Saved List ---
  Future<void> _removeSavedProduct(int index) async {
    final product = _savedProducts[index];
    final itemId = product["id"];
    final removedName = product["name"];

    try {
      final dio = Dio();
      final response = await dio.post('$baseurl/delete-saved-product/$itemId');

      if (response.statusCode == 200) {
        setState(() {
          _savedProducts.removeAt(index);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$removedName removed from Saved Products'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Error removing saved product: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to remove product. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // --- Show Product Details Bottom Sheet ---
  void _showProductDetails(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product["name"],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                        ),
                        if (product["brand"] != null && product["brand"].isNotEmpty)
                          Text(product["brand"], style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: product["color"].withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Score: ${product["score"]}",
                      style: TextStyle(color: product["color"], fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              const Text('Ingredients', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              Text(
                (product["ingredients"] != null && product["ingredients"].isNotEmpty)
                    ? product["ingredients"]
                    : "No specific ingredient details saved.",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
              ),
              if (product["saved_date"] != null && product["saved_date"].isNotEmpty) ...[
                const SizedBox(height: 16),
                Text("Saved on: ${product["saved_date"]}", style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ],
              const SizedBox(height: 20),
            ],
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
          "Saved Products",
          style: TextStyle(color: primarySkyBlue, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: primarySkyBlue),
              )
            : RefreshIndicator(
                onRefresh: _fetchSavedProducts,
                color: primarySkyBlue,
                child: _savedProducts.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.bookmark_border, size: 64, color: Colors.grey.shade400),
                                const SizedBox(height: 16),
                                Text(
                                  "No saved products yet.",
                                  style: TextStyle(color: Colors.grey.shade700, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Scan foods and tap 'Save Product'\nto save them here for later.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: _savedProducts.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final product = _savedProducts[index];

                          return InkWell(
                            onTap: () => _showProductDetails(product),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: primarySkyBlue.withOpacity(0.06),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Food Icon Container
                                  Container(
                                    height: 55,
                                    width: 55,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE0F2FE),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.fastfood_outlined, color: primarySkyBlue),
                                  ),
                                  const SizedBox(width: 16),

                                  // Product Text details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product["name"],
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (product["brand"] != null && product["brand"].isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            product["brand"],
                                            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                        const SizedBox(height: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: product["color"].withOpacity(0.12),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            "Score: ${product["score"]}",
                                            style: TextStyle(color: product["color"], fontWeight: FontWeight.bold, fontSize: 11),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Filled Bookmark Icon (Tap to remove)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.bookmark,
                                      color: primarySkyBlue,
                                      size: 26,
                                    ),
                                    tooltip: 'Remove from saved',
                                    onPressed: () => _removeSavedProduct(index),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
      ),
    );
  }
}
