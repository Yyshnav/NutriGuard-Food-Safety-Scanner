import 'package:flutter/material.dart';
import 'package:nutriguardapp/saved_product_page.dart';

class AnalysisResultScreen extends StatefulWidget {
  final Map<String, dynamic>? data;

  const AnalysisResultScreen({super.key, this.data});

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1E3A8A); 
    const lightBackground = Color(0xFFF9FAFB);
    const healthGreen = Color(0xFF249B62);
    const warningRed = Color(0xFFEF4444);
    const warningOrange = Color(0xFFF59E0B);

    final info = widget.data;
    final productName = info?['product_name']?.toString() ?? "Lay's Classic Chips";
    final brand = info?['brand']?.toString() ?? "";
    final score = int.tryParse(info?['health_score']?.toString() ?? '') ?? 65;
    
    Color scoreColor = healthGreen;
    if (score < 40) {
      scoreColor = warningRed;
    } else if (score < 70) {
      scoreColor = warningOrange;
    }

    final nutInfo = (info?['nutritional_info'] as Map?) ?? {};
    final ingredientsList = (info?['ingredients'] as List?)?.join(', ') ?? 
        'Potatoes, Vegetable Oil (Sunflower, Corn, and/or Canola Oil), and Salt.';
    final allergensList = (info?['allergens_detected'] as List?)?.join(', ') ?? 
        'None detected in standard formulation.';
    final aiRec = info?['ai_recommendation']?.toString() ?? 
        'Great choice of servings, but high in sodium and saturated fats. Best consumed in moderation.';
    final familyWarnings = (info?['family_warnings'] as List?) ?? [];

    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Analysis Result',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header (Image, Title, Score, and "Scanned for: Family")
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 90,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50, 
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(Icons.fastfood, color: Color(0xFF0284C7), size: 40),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        if (brand.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            brand,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                        const SizedBox(height: 4),
                        Text(
                          'Scanned for: You & Family',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(color: scoreColor, shape: BoxShape.circle),
                              child: const Icon(Icons.energy_savings_leaf, color: Colors.white, size: 16),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$score/100',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: scoreColor),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: scoreColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.shield, color: scoreColor, size: 20),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 2. Family Health & Allergen Warning Section
              _buildFamilyWarningsSection(familyWarnings),
              const SizedBox(height: 14),

              // 3. Interactive Tabs
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Expanded(child: _buildTabButton('Nutritional', 0, primaryBlue)),
                    Expanded(child: _buildTabButton('Ingredients', 1, primaryBlue)),
                    Expanded(child: _buildTabButton('Health Impact', 2, primaryBlue)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 4. Tab Content
              if (_selectedTabIndex == 0)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildNutrientRow('Calories', nutInfo['calories']?.toString() ?? '250 Kcal', null, null),
                      _buildNutrientRow('Total Fat', nutInfo['fat']?.toString() ?? '12 g', 'Track', warningOrange),
                      _buildNutrientRow('Saturated Fat', nutInfo['saturated_fat']?.toString() ?? '3 g', 'Check', warningOrange),
                      _buildNutrientRow('Sodium', nutInfo['sodium']?.toString() ?? '450 mg', 'Alert', warningRed),
                      _buildNutrientRow('Sugar', nutInfo['sugar']?.toString() ?? '8 g', 'Track', warningOrange),
                      _buildNutrientRow('Carbohydrate', nutInfo['carbohydrates']?.toString() ?? '30 g', 'Normal', healthGreen),
                      _buildNutrientRow('Protein', nutInfo['protein']?.toString() ?? '4 g', 'Good', healthGreen, isLast: true),
                    ],
                  ),
                )
              else if (_selectedTabIndex == 1)
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ingredients List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      Text(
                        ingredientsList,
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade800, height: 1.5),
                      ),
                      const SizedBox(height: 16),
                      const Text('Detected Allergens', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: warningRed)),
                      const SizedBox(height: 8),
                      Text(allergensList, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                    ],
                  ),
                )
              else if (_selectedTabIndex == 2)
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.warning_amber_rounded, color: warningRed, size: 20),
                          SizedBox(width: 8),
                          Text('Sodium & Fat Analysis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Frequent consumption of high-sodium foods can strain blood pressure and cardiovascular health.',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
                      ),
                      const Divider(height: 28),
                      Row(
                        children: const [
                          Icon(Icons.family_restroom, color: primaryBlue, size: 20),
                          SizedBox(width: 8),
                          Text('Family Compatibility', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ingredients checked across your family profiles including children, pregnant members, and individual allergies.',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              // 5. AI Recommendation Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: healthGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: healthGreen.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.auto_awesome, color: healthGreen),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'AI Recommendation',
                            style: TextStyle(fontWeight: FontWeight.bold, color: healthGreen, fontSize: 14),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            aiRec,
                            style: TextStyle(fontSize: 13, color: Colors.green.shade900, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 6. Action Buttons
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SavedProductsScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Saved Products', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.grey, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Done', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFamilyWarningsSection(List warnings) {
    if (warnings.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF249B62).withOpacity(0.3)),
        ),
        child: Row(
          children: const [
            Icon(Icons.check_circle, color: Color(0xFF249B62), size: 24),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Safe for your household. No detected allergens or conflicts.',
                style: TextStyle(color: Color(0xFF166534), fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.shield_outlined, color: Color(0xFF0284C7), size: 20),
            SizedBox(width: 8),
            Text(
              'Family Health & Allergen Warning',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...warnings.map((w) {
          final risk = w['risk_level']?.toString().toLowerCase() ?? 'safe';
          Color cardBg;
          Color borderColor;
          Color iconColor;
          IconData icon;

          if (risk == 'high') {
            cardBg = const Color(0xFFFEF2F2);
            borderColor = const Color(0xFFEF4444);
            iconColor = const Color(0xFFDC2626);
            icon = Icons.warning_rounded;
          } else if (risk == 'moderate') {
            cardBg = const Color(0xFFFFFBEB);
            borderColor = const Color(0xFFF59E0B);
            iconColor = const Color(0xFFD97706);
            icon = Icons.info_outline;
          } else {
            cardBg = const Color(0xFFF0FDF4);
            borderColor = const Color(0xFF249B62);
            iconColor = const Color(0xFF16A34A);
            icon = Icons.check_circle_outline;
          }

          final member = w['member_name']?.toString() ?? 'Member';
          final relation = w['relationship']?.toString() ?? '';
          final text = w['warning']?.toString() ?? '';

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor.withOpacity(0.4), width: 1.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: iconColor, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        relation.isNotEmpty ? '$member ($relation)' : member,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: iconColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        text,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade800, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTabButton(String text, int tabIndex, Color activeColor) {
    bool isSelected = _selectedTabIndex == tabIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = tabIndex;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNutrientRow(String label, String value, String? badgeText, Color? badgeColor, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500)),
              const Spacer(),
              Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
              if (badgeText != null && badgeColor != null) ...[
                const SizedBox(width: 12),
                Container(
                  width: 50, 
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(color: badgeColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ] else ...[
                const SizedBox(width: 62), 
              ]
            ],
          ),
        ),
        if (!isLast) Divider(color: Colors.grey.shade200, height: 1, thickness: 1),
      ],
    );
  }
}
