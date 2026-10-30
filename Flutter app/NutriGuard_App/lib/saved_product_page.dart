import 'package:flutter/material.dart';

class SavedProductsScreen extends StatefulWidget {
  const SavedProductsScreen({super.key});

  @override
  State<SavedProductsScreen> createState() => _SavedProductsScreenState();
}

class _SavedProductsScreenState extends State<SavedProductsScreen> {
  // This is the dedicated list of ONLY saved products
  final List<Map<String, dynamic>> _savedProducts = [
    {"name": "Whole Wheat Bread", "score": "82/100", "color": const Color(0xFF249B62), "brand": "Nature's Best"},
    {"name": "Organic Almond Milk", "score": "90/100", "color": const Color(0xFF249B62), "brand": "AlmondBreeze"},
    {"name": "Greek Yogurt", "score": "75/100", "color": const Color(0xFF249B62), "brand": "Chobani"},
    {"name": "Dark Chocolate 70%", "score": "68/100", "color": Colors.orange, "brand": "Lindt"},
  ];

  // Logic to remove a product from the saved list
  void _removeSavedProduct(int index) {
    final removedItem = _savedProducts[index]["name"];
    
    setState(() {
      _savedProducts.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$removedItem removed from Saved Products'),
        duration: const Duration(seconds: 2),
      ),
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
        child: _savedProducts.isEmpty 
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border, size: 60, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  "No saved products yet.",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  "Scan foods and tap the bookmark icon\nto save them here for later.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                ),
              ],
            ),
          )
        : ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: _savedProducts.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final product = _savedProducts[index];
            
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
                  // Placeholder for Product Image
                  Container(
                    height: 55, width: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.fastfood_outlined, color: primarySkyBlue),
                  ),
                  const SizedBox(width: 16),
                  
                  // Product Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product["name"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                        const SizedBox(height: 4),
                        Text(product["brand"], style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: product["color"].withOpacity(0.1),
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
                      Icons.bookmark, // Always filled because these are saved
                      color: primarySkyBlue,
                      size: 26,
                    ),
                    onPressed: () => _removeSavedProduct(index),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}