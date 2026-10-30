import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutriguardapp/homepage.dart';
import 'package:nutriguardapp/login_page.dart';
import 'package:nutriguardapp/signup_page.dart';

class HealthProfileScreen extends StatefulWidget {
  const HealthProfileScreen({super.key});

  @override
  State<HealthProfileScreen> createState() => _HealthProfileScreenState();
}

class _HealthProfileScreenState extends State<HealthProfileScreen> {
  // 1. Basic Info Controllers
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String _selectedGender = 'Male';
  final List<String> _genders = ['Male', 'Female', 'Other'];

  // 2. BMI State
  double? _calculatedBmi;
  String _bmiCategory = 'Awaiting Input';
  Color _bmiColor = Colors.grey;

  // 3. Custom Addition Controllers & Lists
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _allergyController = TextEditingController();
  
  final List<String> _selectedConditions = [];
  final List<String> _selectedAllergies = [];
final Dio dio =Dio();
Future<void> health_profile() async{
  try{
    final response = await dio.post(
      '$baseurl/healthprofile/$userId',
      data: {
        'age':_ageController.text,
        'height':_heightController.text,
        'weight':_weightController.text,
        'gender':_selectedGender,
        'bmi':_calculatedBmi,
        
        'health_condition': _selectedConditions.join(', '),
        'food_allergies': _selectedAllergies.join(', '),
      },
    );
    print(response.data);
    if (response.statusCode ==200|| response.statusCode ==201){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Health Status Added Sucessfully")),
      );
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>HomeDashboard() ,));
  }
  catch(e){
    print(e);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Health Status Addding Failed")));
  }
  
}
  // --- LOGIC: BMI Calculation ---
  void _calculateBMI() {
    final double? heightCm = double.tryParse(_heightController.text);
    final double? weightKg = double.tryParse(_weightController.text);

    if (heightCm != null && weightKg != null && heightCm > 0) {
      final double heightM = heightCm / 100;
      final double bmi = weightKg / (heightM * heightM);

      setState(() {
        _calculatedBmi = bmi;
        if (bmi < 18.5) {
          _bmiCategory = 'Underweight';
          _bmiColor = const Color(0xFFF59E0B); // Orange
        } else if (bmi < 25.0) {
          _bmiCategory = 'Healthy';
          _bmiColor = const Color(0xFF249B62); // Green
        } else if (bmi < 30.0) {
          _bmiCategory = 'Overweight';
          _bmiColor = const Color(0xFFF59E0B); // Orange
        } else {
          _bmiCategory = 'Obese';
          _bmiColor = const Color(0xFFEF4444); // Red
        }
      });
    } else {
      setState(() {
        _calculatedBmi = null;
        _bmiCategory = 'Awaiting Input';
        _bmiColor = Colors.grey;
      });
    }
  }

  // --- LOGIC: Add Custom Condition ---
  void _addCondition() {
    final text = _conditionController.text.trim();
    if (text.isNotEmpty && !_selectedConditions.contains(text)) {
      setState(() {
        _selectedConditions.add(text);
      });
      _conditionController.clear(); 
    }
  }

  // --- LOGIC: Add Custom Allergy ---
  void _addAllergy() {
    final text = _allergyController.text.trim();
    if (text.isNotEmpty && !_selectedAllergies.contains(text)) {
      setState(() {
        _selectedAllergies.add(text);
      });
      _allergyController.clear(); 
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _conditionController.dispose();
    _allergyController.dispose();
    super.dispose();
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
        title: const Text(
          "Complete Your Profile",
          style: TextStyle(color: primarySkyBlue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tell us about your body and health so we can analyze food properly for you.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),

              // 🔹 SECTION 1: BODY METRICS & BMI RATE
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Body Metrics", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primarySkyBlue)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(label: "Age", hint: "Years", controller: _ageController, isNumber: true)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Gender", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedGender,
                                    isExpanded: true,
                                    items: _genders.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                                    onChanged: (value) => setState(() => _selectedGender = value!),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: "Height (cm)", hint: "e.g. 175", controller: _heightController, isNumber: true, onChanged: (_) => _calculateBMI(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            label: "Weight (kg)", hint: "e.g. 70", controller: _weightController, isNumber: true, onChanged: (_) => _calculateBMI(),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // NEW: Permanently Visible BMI Rate Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _calculatedBmi == null ? Colors.grey.shade50 : _bmiColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _calculatedBmi == null ? Colors.grey.shade200 : _bmiColor.withOpacity(0.3), width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Your BMI Rate", style: TextStyle(fontSize: 14, color: _calculatedBmi == null ? Colors.grey : Colors.black87, fontWeight: FontWeight.bold)),
                              Text(
                                _calculatedBmi != null ? _calculatedBmi!.toStringAsFixed(1) : "--.-",
                                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _bmiColor),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: _calculatedBmi == null ? Colors.grey.shade200 : _bmiColor.withOpacity(0.15), 
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Text(
                              _bmiCategory, 
                              style: TextStyle(color: _calculatedBmi == null ? Colors.grey.shade600 : _bmiColor, fontWeight: FontWeight.bold)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 🔹 SECTION 2: HEALTH CONDITIONS (Custom Add)
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Health Conditions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primarySkyBlue)),
                    const SizedBox(height: 8),
                    const Text("Add any health issues (e.g. Diabetes, Gas, Hypertension)", style: TextStyle(fontSize: 12, color: Colors.black54)),
                    const SizedBox(height: 16),
                    
                    if (_selectedConditions.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _selectedConditions.map((condition) {
                          return InputChip(
                            label: Text(condition, style: const TextStyle(color: primarySkyBlue, fontWeight: FontWeight.bold)),
                            backgroundColor: const Color(0xFFE0F2FE),
                            deleteIconColor: primarySkyBlue,
                            onDeleted: () {
                              setState(() {
                                _selectedConditions.remove(condition);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    if (_selectedConditions.isNotEmpty) const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _conditionController,
                            decoration: InputDecoration(
                              hintText: "Type health issue...",
                              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primarySkyBlue,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _addCondition,
                          child: const Text("Add", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 🔹 SECTION 3: FOOD ALLERGIES (Custom Add)
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Food Allergies", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                    const SizedBox(height: 8),
                    const Text("Add your allergies (e.g. Peanuts, Dairy, Gluten)", style: TextStyle(fontSize: 12, color: Colors.black54)),
                    const SizedBox(height: 16),
                    
                    if (_selectedAllergies.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _selectedAllergies.map((allergy) {
                          return InputChip(
                            label: Text(allergy, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                            backgroundColor: Colors.red.shade50,
                            deleteIconColor: Colors.redAccent,
                            onDeleted: () {
                              setState(() {
                                _selectedAllergies.remove(allergy);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    if (_selectedAllergies.isNotEmpty) const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _allergyController,
                            decoration: InputDecoration(
                              hintText: "Type food allergy...",
                              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _addAllergy,
                          child: const Text("Add", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 🔹 SAVE & CONTINUE BUTTON
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: healthGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    health_profile();
                  },
                  child: const Text("Save Health Profile", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI HELPER WIDGETS ---
  
  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(blurRadius: 12, color: Colors.black.withOpacity(0.03), offset: const Offset(0, 4))],
      ),
      child: child,
    );
  }

  Widget _buildTextField({
    required String label, 
    required String hint, 
    required TextEditingController controller, 
    bool isNumber = false,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
          ),
        ),
      ],
    );
  }
}