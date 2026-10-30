// // import 'package:flutter/material.dart';

// // class EditFamilyMemberScreen extends StatefulWidget {
// //   final String memberName;
// //   final String initialStatus; // Normal, Patient, or Pregnant

// //   const EditFamilyMemberScreen({
// //     super.key,
// //     required this.memberName,
// //     this.initialStatus = 'Normal',
// //   });

// //   @override
// //   State<EditFamilyMemberScreen> createState() => _EditFamilyMemberScreenState();
// // }

// // class _EditFamilyMemberScreenState extends State<EditFamilyMemberScreen> {
// //   // Controllers
// //   final TextEditingController _nameController=TextEditingController(text: '100');
// //   final TextEditingController _ageController = TextEditingController(text: "24");
// //   final TextEditingController _heightController = TextEditingController(text: "170");
// //   final TextEditingController _weightController = TextEditingController(text: "65");
// //   final TextEditingController _relationshipController=TextEditingController(text: "100");

// //   String _selectedGender = 'Male';
// //   final List<String> _genders = ['Male', 'Female', 'Other'];

// //   // BMI State
// //   double? _calculatedBmi;
// //   String _bmiCategory = 'Awaiting Input';
// //   Color _bmiColor = Colors.grey;

// //   // Health Status
// //   late String _healthStatus;

// //   final TextEditingController _conditionController = TextEditingController();
// //   final List<String> _selectedConditions = [];

// //   String _selectedMonth = 'Month 4';
// //   String _calculatedTrimester = '2nd Trimester';
// //   final TextEditingController _pregnancyIssuesController = TextEditingController();
// //   final List<String> _months = List.generate(9, (index) => 'Month ${index + 1}');

// //   final TextEditingController _allergyController = TextEditingController();
// //   final List<String> _selectedAllergies = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     // Pre-fill the form with the data passed from the previous screen
// //     _nameController = TextEditingController(text: widget.memberName);
// //     _healthStatus = widget.initialStatus;

// //     // Auto-calculate BMI on load since we provided mock height/weight
// //     _calculateBMI();
// //   }

// //   void _calculateBMI() {
// //     final double? heightCm = double.tryParse(_heightController.text);
// //     final double? weightKg = double.tryParse(_weightController.text);

// //     if (heightCm != null && weightKg != null && heightCm > 0) {
// //       final double heightM = heightCm / 100;
// //       final double bmi = weightKg / (heightM * heightM);

// //       setState(() {
// //         _calculatedBmi = bmi;
// //         if (bmi < 18.5) {
// //           _bmiCategory = 'Underweight';
// //           _bmiColor = const Color(0xFFF59E0B);
// //         } else if (bmi < 25.0) {
// //           _bmiCategory = 'Healthy';
// //           _bmiColor = const Color(0xFF249B62);
// //         } else if (bmi < 30.0) {
// //           _bmiCategory = 'Overweight';
// //           _bmiColor = const Color(0xFFF59E0B);
// //         } else {
// //           _bmiCategory = 'Obese';
// //           _bmiColor = const Color(0xFFEF4444);
// //         }
// //       });
// //     } else {
// //       setState(() {
// //         _calculatedBmi = null;
// //         _bmiCategory = 'Awaiting Input';
// //         _bmiColor = Colors.grey;
// //       });
// //     }
// //   }
// //   final Dio dio = Dio();
// //   Future<void> registerUser() async {
// //     try {
// //       final response = await dio.post(
// //         '$baseurl/register',
// //         data: {
// //           'name': _fullNameController.text,
// //           'email': _emailController.text,
// //           'password': _passwordController.text,
// //         },
// //       );

// //       print(response.data);
// //       if (response.statusCode == 200 || response.statusCode == 201) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Registration successful')),
// //         );
// //         Navigator.push(
// //           context,
// //           MaterialPageRoute(builder: (context) => LoginScreen()),
// //         );
// //       }
// //     } catch (e) {
// //       print(e);

// //       ScaffoldMessenger.of(
// //         context,
// //       ).showSnackBar(const SnackBar(content: Text('Registration failed')));
// //     }
// //   }
// //   void _updatePregnancyMonth(String monthStr) {
// //     setState(() {
// //       _selectedMonth = monthStr;
// //       int monthNum = int.tryParse(monthStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
// //       if (monthNum <= 3) {
// //         _calculatedTrimester = '1st Trimester';
// //       } else if (monthNum <= 6) {
// //         _calculatedTrimester = '2nd Trimester';
// //       } else {
// //         _calculatedTrimester = '3rd Trimester';
// //       }
// //     });
// //   }

// //   void _addCondition() {
// //     final text = _conditionController.text.trim();
// //     if (text.isNotEmpty && !_selectedConditions.contains(text)) {
// //       setState(() => _selectedConditions.add(text));
// //       _conditionController.clear();
// //     }
// //   }

// //   void _addAllergy() {
// //     final text = _allergyController.text.trim();
// //     if (text.isNotEmpty && !_selectedAllergies.contains(text)) {
// //       setState(() => _selectedAllergies.add(text));
// //       _allergyController.clear();
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     _nameController.dispose();
// //     _ageController.dispose();
// //     _heightController.dispose();
// //     _weightController.dispose();
// //     _conditionController.dispose();
// //     _pregnancyIssuesController.dispose();
// //     _allergyController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     const primarySkyBlue = Color(0xFF0284C7);
// //     const appBackgroundSky = Color(0xFFF0F9FF);
// //     const healthGreen = Color(0xFF249B62);

// //     return Scaffold(
// //       backgroundColor: appBackgroundSky,
// //       appBar: AppBar(
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back_ios_new, color: primarySkyBlue, size: 20),
// //           onPressed: () => Navigator.pop(context),
// //         ),
// //         title: const Text(
// //           "Edit Family Member",
// //           style: TextStyle(color: primarySkyBlue, fontWeight: FontWeight.bold),
// //         ),
// //         centerTitle: true,
// //       ),
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           padding: const EdgeInsets.all(20),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               _buildCard(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     const Text("Basic Information", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primarySkyBlue)),
// //                     const SizedBox(height: 16),
// //                     _buildTextField(label: "Name", hint: "e.g. Sarah", controller: _nameController),
// //                     const SizedBox(height: 16),
// //                     Row(
// //                       children: [
// //                         Expanded(
// //                           child: _buildDropdown(
// //                             label: "Relationship",

// //                           ),
// //                         ),
// //                         const SizedBox(width: 16),
// //                         Expanded(
// //                           child: _buildTextField(label: "Age", hint: "Years", controller: _ageController, isNumber: true),
// //                         ),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 16),
// //                     _buildDropdown(
// //                       label: "Gender",
// //                       value: _selectedGender,
// //                       items: _genders,
// //                       onChanged: (val) => setState(() => _selectedGender = val!)
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(height: 16),

// //               _buildCard(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     const Text("Body Metrics", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primarySkyBlue)),
// //                     const SizedBox(height: 16),
// //                     Row(
// //                       children: [
// //                         Expanded(
// //                           child: _buildTextField(
// //                             label: "Height (cm)", hint: "e.g. 165", controller: _heightController, isNumber: true, onChanged: (_) => _calculateBMI(),
// //                           ),
// //                         ),
// //                         const SizedBox(width: 16),
// //                         Expanded(
// //                           child: _buildTextField(
// //                             label: "Weight (kg)", hint: "e.g. 60", controller: _weightController, isNumber: true, onChanged: (_) => _calculateBMI(),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 24),
// //                     Container(
// //                       padding: const EdgeInsets.all(16),
// //                       decoration: BoxDecoration(
// //                         color: _calculatedBmi == null ? Colors.grey.shade50 : _bmiColor.withOpacity(0.08),
// //                         borderRadius: BorderRadius.circular(16),
// //                         border: Border.all(color: _calculatedBmi == null ? Colors.grey.shade200 : _bmiColor.withOpacity(0.3), width: 2),
// //                       ),
// //                       child: Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Text("BMI Rate", style: TextStyle(fontSize: 14, color: _calculatedBmi == null ? Colors.grey : Colors.black87, fontWeight: FontWeight.bold)),
// //                               Text(
// //                                 _calculatedBmi != null ? _calculatedBmi!.toStringAsFixed(1) : "--.-",
// //                                 style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _bmiColor),
// //                               ),
// //                             ],
// //                           ),
// //                           Container(
// //                             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                             decoration: BoxDecoration(
// //                               color: _calculatedBmi == null ? Colors.grey.shade200 : _bmiColor.withOpacity(0.15),
// //                               borderRadius: BorderRadius.circular(20)
// //                             ),
// //                             child: Text(
// //                               _bmiCategory,
// //                               style: TextStyle(color: _calculatedBmi == null ? Colors.grey.shade600 : _bmiColor, fontWeight: FontWeight.bold)
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(height: 16),

// //               const Text("Current Health Status", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
// //               const SizedBox(height: 12),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                 children: ['Normal', 'Patient', 'Pregnant'].map((status) {
// //                   final isSelected = _healthStatus == status;
// //                   return ChoiceChip(
// //                     label: Text(status, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
// //                     selected: isSelected,
// //                     selectedColor: primarySkyBlue,
// //                     backgroundColor: Colors.white,
// //                     showCheckmark: false,
// //                     onSelected: (selected) {
// //                       if (selected) {
// //                         setState(() {
// //                           _healthStatus = status;
// //                           if (status == 'Pregnant' && _selectedGender != 'Female') {
// //                             _selectedGender = 'Female';
// //                           }
// //                         });
// //                       }
// //                     },
// //                   );
// //                 }).toList(),
// //               ),
// //               const SizedBox(height: 24),

// //               if (_healthStatus == 'Patient')
// //                 _buildCard(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       const Text("Patient Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange)),
// //                       const SizedBox(height: 8),
// //                       const Text("What health issues or problems are they facing?", style: TextStyle(fontSize: 12, color: Colors.black54)),
// //                       const SizedBox(height: 16),
// //                       if (_selectedConditions.isNotEmpty)
// //                         Wrap(
// //                           spacing: 8, runSpacing: 8,
// //                           children: _selectedConditions.map((condition) {
// //                             return InputChip(
// //                               label: Text(condition, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
// //                               backgroundColor: Colors.orange.shade50,
// //                               deleteIconColor: Colors.orange,
// //                               onDeleted: () => setState(() => _selectedConditions.remove(condition)),
// //                             );
// //                           }).toList(),
// //                         ),
// //                       if (_selectedConditions.isNotEmpty) const SizedBox(height: 12),
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             child: _buildTextField(label: "", hint: "e.g. Diabetes, Ulcer...", controller: _conditionController),
// //                           ),
// //                           const SizedBox(width: 8),
// //                           ElevatedButton(
// //                             style: ElevatedButton.styleFrom(
// //                               backgroundColor: Colors.orange,
// //                               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
// //                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //                             ),
// //                             onPressed: _addCondition,
// //                             child: const Text("Add", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),

// //               if (_healthStatus == 'Pregnant')
// //                 _buildCard(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       const Text("Pregnancy Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple)),
// //                       const SizedBox(height: 16),
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             child: _buildDropdown(
// //                               label: "Which Month?",
// //                               value: _selectedMonth,
// //                               items: _months,
// //                               onChanged: (val) => _updatePregnancyMonth(val!)
// //                             ),
// //                           ),
// //                           const SizedBox(width: 16),
// //                           Expanded(
// //                             child: Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 const Text("Trimester", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
// //                                 const SizedBox(height: 8),
// //                                 Container(
// //                                   width: double.infinity,
// //                                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
// //                                   decoration: BoxDecoration(
// //                                     color: Colors.purple.shade50,
// //                                     borderRadius: BorderRadius.circular(12),
// //                                     border: Border.all(color: Colors.purple.shade200),
// //                                   ),
// //                                   child: Text(_calculatedTrimester, style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 16),
// //                       _buildTextField(
// //                         label: "Do you have any pregnancy-related issues?",
// //                         hint: "e.g. Gestational diabetes...",
// //                         controller: _pregnancyIssuesController
// //                       ),
// //                     ],
// //                   ),
// //                 ),

// //               if (_healthStatus != 'Normal') const SizedBox(height: 16),

// //               _buildCard(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     const Text("Food Allergies", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent)),
// //                     const SizedBox(height: 16),
// //                     if (_selectedAllergies.isNotEmpty)
// //                       Wrap(
// //                         spacing: 8, runSpacing: 8,
// //                         children: _selectedAllergies.map((allergy) {
// //                           return InputChip(
// //                             label: Text(allergy, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
// //                             backgroundColor: Colors.red.shade50,
// //                             deleteIconColor: Colors.redAccent,
// //                             onDeleted: () => setState(() => _selectedAllergies.remove(allergy)),
// //                           );
// //                         }).toList(),
// //                       ),
// //                     if (_selectedAllergies.isNotEmpty) const SizedBox(height: 12),
// //                     Row(
// //                       children: [
// //                         Expanded(child: _buildTextField(label: "", hint: "Type allergy...", controller: _allergyController)),
// //                         const SizedBox(width: 8),
// //                         ElevatedButton(
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: Colors.redAccent,
// //                             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
// //                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //                           ),
// //                           onPressed: _addAllergy,
// //                           child: const Text("Add", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(height: 32),

// //               SizedBox(
// //                 width: double.infinity,
// //                 height: 56,
// //                 child: ElevatedButton(
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: healthGreen,
// //                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //                   ),
// //                   onPressed: () {
// //                     Navigator.pop(context);
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       const SnackBar(content: Text('Profile Updates Saved!')),
// //                     );
// //                   },
// //                   child: const Text("Save Changes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildCard({required Widget child}) {
// //     return Container(
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [BoxShadow(blurRadius: 12, color: Colors.black.withOpacity(0.03), offset: const Offset(0, 4))],
// //       ),
// //       child: child,
// //     );
// //   }

// //   Widget _buildTextField({required String label, required String hint, required TextEditingController controller, bool isNumber = false, Function(String)? onChanged}) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         if (label.isNotEmpty) ...[Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)), const SizedBox(height: 8)],
// //         TextField(
// //           controller: controller,
// //           keyboardType: isNumber ? TextInputType.number : TextInputType.text,
// //           onChanged: onChanged,
// //           decoration: InputDecoration(
// //             hintText: hint,
// //             hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
// //             filled: true,
// //             fillColor: Colors.grey.shade50,
// //             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
// //             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
// //             enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildDropdown({required String label, required String value, required List<String> items, required Function(String?) onChanged}) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
// //         const SizedBox(height: 8),
// //         Container(
// //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// //           decoration: BoxDecoration(
// //             color: Colors.grey.shade50,
// //             borderRadius: BorderRadius.circular(12),
// //             border: Border.all(color: Colors.grey.shade300),
// //           ),
// //           child: DropdownButtonHideUnderline(
// //             child: DropdownButton<String>(
// //               value: value,
// //               isExpanded: true,
// //               items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
// //               onChanged: onChanged,
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:nutriguardapp/signup_page.dart';

// class EditFamilyMemberScreen extends StatefulWidget {
//   final String memberName;
//   final String initialStatus; // Normal, Patient, or Pregnant

//   const EditFamilyMemberScreen({
//     super.key,
//     required this.memberName,
//     this.initialStatus = 'Normal',
//   });

//   @override
//   State<EditFamilyMemberScreen> createState() =>
//       _EditFamilyMemberScreenState();
// }

// class _EditFamilyMemberScreenState
//     extends State<EditFamilyMemberScreen> {
//   // Controllers

//   final TextEditingController _ageController =
//       TextEditingController(text: "24");
//   final TextEditingController _heightController =
//       TextEditingController(text: "170");
//   final TextEditingController _weightController =
//       TextEditingController(text: "65");
//   final TextEditingController _relationshipController =
//       TextEditingController(text: "100");

//   String _selectedGender = 'Male';
//   final List<String> _genders = ['Male', 'Female', 'Other'];

//   // BMI State
//   double? _calculatedBmi;
//   String _bmiCategory = 'Awaiting Input';
//   Color _bmiColor = Colors.grey;

//   // Health Status
//   late String _healthStatus;

//   final TextEditingController _conditionController =
//       TextEditingController();
//   final List<String> _selectedConditions = [];

//   String _selectedMonth = 'Month 4';
//   String _calculatedTrimester = '2nd Trimester';

//   final TextEditingController _pregnancyIssuesController =
//       TextEditingController();

//   final List<String> _months =
//       List.generate(9, (index) => 'Month ${index + 1}');

//   final TextEditingController _allergyController =
//       TextEditingController();
// final TextEditingController        _nameController =
//         TextEditingController();

//   final List<String> _selectedAllergies = [];

//   @override
//   void initState() {
//     super.initState();

//     // Pre-fill the form with the data passed from the previous screen

//     _healthStatus = widget.initialStatus;

//     // Auto-calculate BMI on load
//     _calculateBMI();
//   }

//   void _calculateBMI() {
//     final double? heightCm =
//         double.tryParse(_heightController.text);

//     final double? weightKg =
//         double.tryParse(_weightController.text);

//     if (heightCm != null &&
//         weightKg != null &&
//         heightCm > 0) {
//       final double heightM = heightCm / 100;

//       final double bmi =
//           weightKg / (heightM * heightM);

//       setState(() {
//         _calculatedBmi = bmi;

//         if (bmi < 18.5) {
//           _bmiCategory = 'Underweight';
//           _bmiColor = const Color(0xFFF59E0B);
//         } else if (bmi < 25.0) {
//           _bmiCategory = 'Healthy';
//           _bmiColor = const Color(0xFF249B62);
//         } else if (bmi < 30.0) {
//           _bmiCategory = 'Overweight';
//           _bmiColor = const Color(0xFFF59E0B);
//         } else {
//           _bmiCategory = 'Obese';
//           _bmiColor = const Color(0xFFEF4444);
//         }
//       });
//     } else {
//       setState(() {
//         _calculatedBmi = null;
//         _bmiCategory = 'Awaiting Input';
//         _bmiColor = Colors.grey;
//       });
//     }
//   }

//   final Dio dio = Dio();

//   Future<void> registerUser() async {
//     try {
//       final response = await dio.post(
//         '$baseurl/family-members',
//         data: {
//           'name': _nameController.text,
//           'age':_ageController.text,
//           'gender':_genders,
//           'height':_heightController.text,
//           'weight':_weightController.text,
//           'bmi':_bmiCategory,
//           'food_allergies':
//           'is_pregnant':
//           'relationship':_relationshipController.text,
//           'conditions':_c
//           'pregnancy_issues':_pregnancyIssuesController.text,
//           'pregnancy_month':_updatePregnancyMonth(monthStr)
//         },
//       );

//       print(response.data);

//       if (response.statusCode == 200 ||
//           response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Member Adding successful'),
//           ),
//         );
//       }
//     } catch (e) {
//       print(e);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Member Adding  failed'),
//         ),
//       );
//     }
//   }

//   void _updatePregnancyMonth(String monthStr) {
//     setState(() {
//       _selectedMonth = monthStr;

//       int monthNum = int.tryParse(
//             monthStr.replaceAll(
//               RegExp(r'[^0-9]'),
//               '',
//             ),
//           ) ??
//           1;

//       if (monthNum <= 3) {
//         _calculatedTrimester = '1st Trimester';
//       } else if (monthNum <= 6) {
//         _calculatedTrimester = '2nd Trimester';
//       } else {
//         _calculatedTrimester = '3rd Trimester';
//       }
//     });
//   }

//   void _addCondition() {
//     final text = _conditionController.text.trim();

//     if (text.isNotEmpty &&
//         !_selectedConditions.contains(text)) {
//       setState(() {
//         _selectedConditions.add(text);
//       });

//       _conditionController.clear();
//     }
//   }

//   void _addAllergy() {
//     final text = _allergyController.text.trim();

//     if (text.isNotEmpty &&
//         !_selectedAllergies.contains(text)) {
//       setState(() {
//         _selectedAllergies.add(text);
//       });

//       _allergyController.clear();
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _ageController.dispose();
//     _heightController.dispose();
//     _weightController.dispose();
//     _relationshipController.dispose();
//     _conditionController.dispose();
//     _pregnancyIssuesController.dispose();
//     _allergyController.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     const primarySkyBlue = Color(0xFF0284C7);
//     const appBackgroundSky = Color(0xFFF0F9FF);
//     const healthGreen = Color(0xFF249B62);

//     return Scaffold(
//       backgroundColor: appBackgroundSky,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new,
//             color: primarySkyBlue,
//             size: 20,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           "Edit Family Member",
//           style: TextStyle(
//             color: primarySkyBlue,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildCard(
//                 child: Column(
//                   crossAxisAlignment:
//                       CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Basic Information",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: primarySkyBlue,
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     _buildTextField(
//                       label: "Name",
//                       hint: "e.g. Sarah",
//                       controller: _nameController,
//                     ),

//                     const SizedBox(height: 16),

//                     Row(
//                       children: [
//                         Expanded(
//                           child: _buildTextField(
//                             label: "Relationship",
//                             hint: "e.g. Father",
//                             controller:
//                                 _relationshipController,
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: _buildTextField(
//                             label: "Age",
//                             hint: "Years",
//                             controller: _ageController,
//                             isNumber: true,
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 16),

//                     _buildDropdown(
//                       label: "Gender",
//                       value: _selectedGender,
//                       items: _genders,
//                       onChanged: (val) {
//                         setState(() {
//                           _selectedGender = val!;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 16),

//               _buildCard(
//                 child: Column(
//                   crossAxisAlignment:
//                       CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Body Metrics",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: primarySkyBlue,
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     Row(
//                       children: [
//                         Expanded(
//                           child: _buildTextField(
//                             label: "Height (cm)",
//                             hint: "e.g. 165",
//                             controller: _heightController,
//                             isNumber: true,
//                             onChanged: (_) =>
//                                 _calculateBMI(),
//                           ),
//                         ),

//                         const SizedBox(width: 16),

//                         Expanded(
//                           child: _buildTextField(
//                             label: "Weight (kg)",
//                             hint: "e.g. 60",
//                             controller: _weightController,
//                             isNumber: true,
//                             onChanged: (_) =>
//                                 _calculateBMI(),
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 24),

//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: _calculatedBmi == null
//                             ? Colors.grey.shade50
//                             : _bmiColor.withOpacity(0.08),
//                         borderRadius:
//                             BorderRadius.circular(16),
//                         border: Border.all(
//                           color: _calculatedBmi == null
//                               ? Colors.grey.shade200
//                               : _bmiColor.withOpacity(0.3),
//                           width: 2,
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment:
//                             MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "BMI Rate",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color:
//                                       _calculatedBmi == null
//                                           ? Colors.grey
//                                           : Colors.black87,
//                                   fontWeight:
//                                       FontWeight.bold,
//                                 ),
//                               ),

//                               Text(
//                                 _calculatedBmi != null
//                                     ? _calculatedBmi!
//                                         .toStringAsFixed(2)
//                                     : "--.--",
//                                 style: TextStyle(
//                                   fontSize: 32,
//                                   fontWeight:
//                                       FontWeight.bold,
//                                   color: _bmiColor,
//                                 ),
//                               ),
//                             ],
//                           ),

//                           Container(
//                             padding:
//                                 const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 8,
//                             ),
//                             decoration: BoxDecoration(
//                               color: _calculatedBmi == null
//                                   ? Colors.grey.shade200
//                                   : _bmiColor
//                                       .withOpacity(0.15),
//                               borderRadius:
//                                   BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               _bmiCategory,
//                               style: TextStyle(
//                                 color:
//                                     _calculatedBmi == null
//                                         ? Colors.grey.shade600
//                                         : _bmiColor,
//                                 fontWeight:
//                                     FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 16),

//               const Text(
//                 "Current Health Status",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),

//               const SizedBox(height: 12),

//               Row(
//                 mainAxisAlignment:
//                     MainAxisAlignment.spaceEvenly,
//                 children: [
//                   'Normal',
//                   'Patient',
//                   'Pregnant',
//                 ].map((status) {
//                   final isSelected =
//                       _healthStatus == status;

//                   return ChoiceChip(
//                     label: Text(
//                       status,
//                       style: TextStyle(
//                         color: isSelected
//                             ? Colors.white
//                             : Colors.black87,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     selected: isSelected,
//                     selectedColor: primarySkyBlue,
//                     backgroundColor: Colors.white,
//                     showCheckmark: false,
//                     onSelected: (selected) {
//                       if (selected) {
//                         setState(() {
//                           _healthStatus = status;

//                           if (status == 'Pregnant' &&
//                               _selectedGender != 'Female') {
//                             _selectedGender = 'Female';
//                           }
//                         });
//                       }
//                     },
//                   );
//                 }).toList(),
//               ),

//               const SizedBox(height: 24),

//               if (_healthStatus == 'Patient')
//                 _buildCard(
//                   child: Column(
//                     crossAxisAlignment:
//                         CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Patient Details",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.orange,
//                         ),
//                       ),

//                       const SizedBox(height: 8),

//                       const Text(
//                         "What health issues or problems are they facing?",
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.black54,
//                         ),
//                       ),

//                       const SizedBox(height: 16),

//                       if (_selectedConditions.isNotEmpty)
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 8,
//                           children:
//                               _selectedConditions.map(
//                             (condition) {
//                               return InputChip(
//                                 label: Text(
//                                   condition,
//                                   style: const TextStyle(
//                                     color: Colors.orange,
//                                     fontWeight:
//                                         FontWeight.bold,
//                                   ),
//                                 ),
//                                 backgroundColor:
//                                     Colors.orange.shade50,
//                                 deleteIconColor:
//                                     Colors.orange,
//                                 onDeleted: () {
//                                   setState(() {
//                                     _selectedConditions
//                                         .remove(condition);
//                                   });
//                                 },
//                               );
//                             },
//                           ).toList(),
//                         ),

//                       if (_selectedConditions.isNotEmpty)
//                         const SizedBox(height: 12),

//                       Row(
//                         children: [
//                           Expanded(
//                             child: _buildTextField(
//                               label: "",
//                               hint:
//                                   "e.g. Diabetes, Ulcer...",
//                               controller:
//                                   _conditionController,
//                             ),
//                           ),

//                           const SizedBox(width: 8),

//                           ElevatedButton(
//                             style:
//                                 ElevatedButton.styleFrom(
//                               backgroundColor:
//                                   Colors.orange,
//                               padding:
//                                   const EdgeInsets.symmetric(
//                                 horizontal: 20,
//                                 vertical: 14,
//                               ),
//                               shape:
//                                   RoundedRectangleBorder(
//                                 borderRadius:
//                                     BorderRadius.circular(
//                                         12),
//                               ),
//                             ),
//                             onPressed: _addCondition,
//                             child: const Text(
//                               "Add",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),

//               if (_healthStatus == 'Pregnant')
//                 _buildCard(
//                   child: Column(
//                     crossAxisAlignment:
//                         CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Pregnancy Details",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.purple,
//                         ),
//                       ),

//                       const SizedBox(height: 16),

//                       Row(
//                         children: [
//                           Expanded(
//                             child: _buildDropdown(
//                               label: "Which Month?",
//                               value: _selectedMonth,
//                               items: _months,
//                               onChanged: (val) {
//                                 _updatePregnancyMonth(
//                                     val!);
//                               },
//                             ),
//                           ),

//                           const SizedBox(width: 16),

//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment:
//                                   CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   "Trimester",
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight:
//                                         FontWeight.w600,
//                                     color: Colors.black87,
//                                   ),
//                                 ),

//                                 const SizedBox(height: 8),

//                                 Container(
//                                   width: double.infinity,
//                                   padding:
//                                       const EdgeInsets
//                                           .symmetric(
//                                     horizontal: 16,
//                                     vertical: 14,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color:
//                                         Colors.purple.shade50,
//                                     borderRadius:
//                                         BorderRadius.circular(
//                                             12),
//                                     border: Border.all(
//                                       color: Colors
//                                           .purple.shade200,
//                                     ),
//                                   ),
//                                   child: Text(
//                                     _calculatedTrimester,
//                                     style:
//                                         const TextStyle(
//                                       color: Colors.purple,
//                                       fontWeight:
//                                           FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 16),

//                       _buildTextField(
//                         label:
//                             "Do you have any pregnancy-related issues?",
//                         hint:
//                             "e.g. Gestational diabetes...",
//                         controller:
//                             _pregnancyIssuesController,
//                       ),
//                     ],
//                   ),
//                 ),

//               if (_healthStatus != 'Normal')
//                 const SizedBox(height: 16),

//               _buildCard(
//                 child: Column(
//                   crossAxisAlignment:
//                       CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Food Allergies",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.redAccent,
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     if (_selectedAllergies.isNotEmpty)
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children:
//                             _selectedAllergies.map(
//                           (allergy) {
//                             return InputChip(
//                               label: Text(
//                                 allergy,
//                                 style: const TextStyle(
//                                   color: Colors.redAccent,
//                                   fontWeight:
//                                       FontWeight.bold,
//                                 ),
//                               ),
//                               backgroundColor:
//                                   Colors.red.shade50,
//                               deleteIconColor:
//                                   Colors.redAccent,
//                               onDeleted: () {
//                                 setState(() {
//                                   _selectedAllergies
//                                       .remove(allergy);
//                                 });
//                               },
//                             );
//                           },
//                         ).toList(),
//                       ),

//                     if (_selectedAllergies.isNotEmpty)
//                       const SizedBox(height: 12),

//                     Row(
//                       children: [
//                         Expanded(
//                           child: _buildTextField(
//                             label: "",
//                             hint: "Type allergy...",
//                             controller:
//                                 _allergyController,
//                           ),
//                         ),

//                         const SizedBox(width: 8),

//                         ElevatedButton(
//                           style:
//                               ElevatedButton.styleFrom(
//                             backgroundColor:
//                                 Colors.redAccent,
//                             padding:
//                                 const EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 14,
//                             ),
//                             shape:
//                                 RoundedRectangleBorder(
//                               borderRadius:
//                                   BorderRadius.circular(12),
//                             ),
//                           ),
//                           onPressed: _addAllergy,
//                           child: const Text(
//                             "Add",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 32),

//               SizedBox(
//                 width: double.infinity,
//                 height: 56,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: healthGreen,
//                     shape: RoundedRectangleBorder(
//                       borderRadius:
//                           BorderRadius.circular(16),
//                     ),
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context);

//                     ScaffoldMessenger.of(context)
//                         .showSnackBar(
//                       const SnackBar(
//                         content:
//                             Text('Profile Updates Saved!'),
//                       ),
//                     );
//                   },
//                   child: const Text(
//                     "Save Changes",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCard({required Widget child}) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             blurRadius: 12,
//             color: Colors.black.withOpacity(0.03),
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }

//   Widget _buildTextField({
//     required String label,
//     required String hint,
//     required TextEditingController controller,
//     bool isNumber = false,
//     Function(String)? onChanged,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (label.isNotEmpty) ...[
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 8),
//         ],
//         TextField(
//           controller: controller,
//           keyboardType: isNumber
//               ? TextInputType.number
//               : TextInputType.text,
//           onChanged: onChanged,
//           decoration: InputDecoration(
//             hintText: hint,
//             hintStyle: TextStyle(
//               color: Colors.grey.shade400,
//               fontSize: 13,
//             ),
//             filled: true,
//             fillColor: Colors.grey.shade50,
//             contentPadding:
//                 const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 14,
//             ),
//             border: OutlineInputBorder(
//               borderRadius:
//                   BorderRadius.circular(12),
//               borderSide: BorderSide(
//                 color: Colors.grey.shade300,
//               ),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius:
//                   BorderRadius.circular(12),
//               borderSide: BorderSide(
//                 color: Colors.grey.shade300,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDropdown({
//     required String label,
//     required String value,
//     required List<String> items,
//     required Function(String?) onChanged,
//   }) {
//     return Column(
//       crossAxisAlignment:
//           CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),

//         const SizedBox(height: 8),

//         Container(
//           padding:
//               const EdgeInsets.symmetric(
//             horizontal: 12,
//             vertical: 4,
//           ),
//           decoration: BoxDecoration(
//             color: Colors.grey.shade50,
//             borderRadius:
//                 BorderRadius.circular(12),
//             border: Border.all(
//               color: Colors.grey.shade300,
//             ),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: value,
//               isExpanded: true,
//               items: items
//                   .map(
//                     (e) => DropdownMenuItem(
//                       value: e,
//                       child: Text(e),
//                     ),
//                   )
//                   .toList(),
//               onChanged: onChanged,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:nutriguardapp/login_page.dart';
import 'package:nutriguardapp/signup_page.dart';

class EditFamilyMemberScreen extends StatefulWidget {
  final int? memberId; // Null when adding; non-null when editing
  final String memberName;
  final String initialStatus; // 'Normal', 'Patient', or 'Pregnant'
  final Map<String, dynamic>?
  memberData; // Full pre-existing record if available

  const EditFamilyMemberScreen({
    super.key,
    required this.memberName,
    this.initialStatus = 'Normal',
    this.memberId,
    this.memberData,
  });

  @override
  State<EditFamilyMemberScreen> createState() => _EditFamilyMemberScreenState();
}

class _EditFamilyMemberScreenState extends State<EditFamilyMemberScreen> {
  // Base URL (Use 10.0.2.2 for Android Emulator, LAN IP for Physical Phone)
  final Dio dio = Dio();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  late String _selectedRelationship;
  final List<String> _relationships = [
    'Wife',
    'Child',
    'Parent',
    'Sibling',
    'Other',
    'Me',
  ];

  late String _selectedGender;
  final List<String> _genders = ['Male', 'Female', 'Other'];

  // BMI State
  double? _calculatedBmi;
  String _bmiCategory = 'Awaiting Input';
  Color _bmiColor = Colors.grey;

  // Health Status
  late String _healthStatus;

  final TextEditingController _conditionController = TextEditingController();
  final List<String> _selectedConditions = [];

  String _selectedMonth = 'Month 4';
  String _calculatedTrimester = '2nd Trimester';
  final TextEditingController _pregnancyIssuesController =
      TextEditingController();
  final List<String> _months = List.generate(
    9,
    (index) => 'Month ${index + 1}',
  );

  final TextEditingController _allergyController = TextEditingController();
  final List<String> _selectedAllergies = [];

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final data = widget.memberData;

    // Controllers initialization
    _nameController = TextEditingController(
      text: data?['name'] ?? widget.memberName,
    );
    _ageController = TextEditingController(
      text: data?['age']?.toString() ?? "24",
    );
    _heightController = TextEditingController(
      text: data?['height']?.toString() ?? "170",
    );
    _weightController = TextEditingController(
      text: data?['weight']?.toString() ?? "65",
    );

    // Relationships
    final rel = data?['relation']?.toString() ?? 'Child';
    _selectedRelationship = _relationships.contains(rel) ? rel : 'Other';

    // Gender
    final gen = data?['gender']?.toString() ?? 'Male';
    _selectedGender = _genders.contains(gen) ? gen : 'Male';

    // Status
    _healthStatus = data?['health_status']?.toString() ?? widget.initialStatus;

    // Populate conditions
    if (data?['conditions'] != null &&
        data!['conditions'].toString().isNotEmpty) {
      _selectedConditions.addAll(
        data['conditions']
            .toString()
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty),
      );
    }

    // Populate pregnancy info
    if (data?['pregnancy_month'] != null &&
        _months.contains(data!['pregnancy_month'])) {
      _selectedMonth = data['pregnancy_month'];
      _calculatedTrimester = data['trimester']?.toString() ?? '2nd Trimester';
    }
    _pregnancyIssuesController.text =
        data?['pregnancy_issues']?.toString() ?? '';

    // Populate allergies
    if (data?['allergies'] != null &&
        data!['allergies'].toString().isNotEmpty) {
      _selectedAllergies.addAll(
        data['allergies']
            .toString()
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty),
      );
    }

    _calculateBMI();
  }

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
          _bmiColor = const Color(0xFFF59E0B);
        } else if (bmi < 25.0) {
          _bmiCategory = 'Healthy';
          _bmiColor = const Color(0xFF249B62);
        } else if (bmi < 30.0) {
          _bmiCategory = 'Overweight';
          _bmiColor = const Color(0xFFF59E0B);
        } else {
          _bmiCategory = 'Obese';
          _bmiColor = const Color(0xFFEF4444);
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

  void _updatePregnancyMonth(String monthStr) {
    setState(() {
      _selectedMonth = monthStr;
      int monthNum =
          int.tryParse(monthStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
      if (monthNum <= 3) {
        _calculatedTrimester = '1st Trimester';
      } else if (monthNum <= 6) {
        _calculatedTrimester = '2nd Trimester';
      } else {
        _calculatedTrimester = '3rd Trimester';
      }
    });
  }

  void _addCondition() {
    final text = _conditionController.text.trim();
    if (text.isNotEmpty && !_selectedConditions.contains(text)) {
      setState(() => _selectedConditions.add(text));
      _conditionController.clear();
    }
  }

  void _addAllergy() {
    final text = _allergyController.text.trim();
    if (text.isNotEmpty && !_selectedAllergies.contains(text)) {
      setState(() => _selectedAllergies.add(text));
      _allergyController.clear();
    }
  }

  // ==========================================
  // DIO SAVE / UPDATE IMPLEMENTATION
  // ==========================================
  Future<void> _saveChanges() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a name')));
      return;
    }

    setState(() => _isSaving = true);

    final payload = {
      'name': name,
      'relationship': _selectedRelationship,
      'age': int.tryParse(_ageController.text.trim()) ?? 0,
      'gender': _selectedGender,
      'height': _heightController.text.trim(),
      'weight': _weightController.text.trim(),
      'bmi': _calculatedBmi != null ? _calculatedBmi!.toStringAsFixed(1) : '0',
      'health_status': _healthStatus,
      'is_pregnant': _healthStatus == 'Pregnant',
      'conditions': _healthStatus == 'Patient'
          ? _selectedConditions.join(', ')
          : '',
      'pregnancy_month': _healthStatus == 'Pregnant' ? _selectedMonth : '',
      'trimester': _healthStatus == 'Pregnant' ? _calculatedTrimester : '',
      'pregnancy_issues': _healthStatus == 'Pregnant'
          ? _pregnancyIssuesController.text.trim()
          : '',
      'allergies': _selectedAllergies.join(', '),
    };

    try {
      Response response;
      if (widget.memberId == null) {
        // ADD NEW MEMBER
        response = await dio.post('$baseurl/add-member/$userId', data: payload);
      } else {
        // UPDATE EXISTING MEMBER
        response = await dio.put(
          '$baseurl/member/${widget.memberId}',
          data: payload,
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.memberId == null
                  ? 'Member Added Successfully!'
                  : 'Member Updated Successfully!',
            ),
          ),
        );
        Navigator.pop(
          context,
          true,
        ); // Return true so FamilyMembersScreen refreshes
      } else {
        throw Exception(response.data['error'] ?? 'Saving failed');
      }
    } on DioException catch (e) {
      if (!mounted) return;

      final data = e.response?.data;
      String error = e.message ?? 'An error occurred';

      if (data is Map) {
        error =
            data['error']?.toString() ?? data['message']?.toString() ?? error;
      } else if (data is String) {
        error = data;
      }
      print(error);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _conditionController.dispose();
    _pregnancyIssuesController.dispose();
    _allergyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primarySkyBlue = Color(0xFF0284C7);
    const appBackgroundSky = Color(0xFFF0F9FF);
    const healthGreen = Color(0xFF249B62);
    final isEditing = widget.memberId != null;

    return Scaffold(
      backgroundColor: appBackgroundSky,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: primarySkyBlue,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditing ? "Edit Family Member" : "Add Family Member",
          style: const TextStyle(
            color: primarySkyBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Basic Information",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primarySkyBlue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: "Name",
                      hint: "e.g. Sarah",
                      controller: _nameController,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            label: "Relationship",
                            value: _selectedRelationship,
                            items: _relationships,
                            onChanged: (val) =>
                                setState(() => _selectedRelationship = val!),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            label: "Age",
                            hint: "Years",
                            controller: _ageController,
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: "Gender",
                      value: _selectedGender,
                      items: _genders,
                      onChanged: (val) =>
                          setState(() => _selectedGender = val!),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Body Metrics",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primarySkyBlue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: "Height (cm)",
                            hint: "e.g. 165",
                            controller: _heightController,
                            isNumber: true,
                            onChanged: (_) => _calculateBMI(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            label: "Weight (kg)",
                            hint: "e.g. 60",
                            controller: _weightController,
                            isNumber: true,
                            onChanged: (_) => _calculateBMI(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _calculatedBmi == null
                            ? Colors.grey.shade50
                            : _bmiColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _calculatedBmi == null
                              ? Colors.grey.shade200
                              : _bmiColor.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "BMI Rate",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _calculatedBmi == null
                                      ? Colors.grey
                                      : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _calculatedBmi != null
                                    ? _calculatedBmi!.toStringAsFixed(1)
                                    : "--.-",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: _bmiColor,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _calculatedBmi == null
                                  ? Colors.grey.shade200
                                  : _bmiColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _bmiCategory,
                              style: TextStyle(
                                color: _calculatedBmi == null
                                    ? Colors.grey.shade600
                                    : _bmiColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                "Current Health Status",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['Normal', 'Patient', 'Pregnant'].map((status) {
                  final isSelected = _healthStatus == status;
                  return ChoiceChip(
                    label: Text(
                      status,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: primarySkyBlue,
                    backgroundColor: Colors.white,
                    showCheckmark: false,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _healthStatus = status;
                          if (status == 'Pregnant' &&
                              _selectedGender != 'Female') {
                            _selectedGender = 'Female';
                          }
                        });
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              if (_healthStatus == 'Patient')
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Patient Details",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "What health issues or problems are they facing?",
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      if (_selectedConditions.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedConditions.map((condition) {
                            return InputChip(
                              label: Text(
                                condition,
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: Colors.orange.shade50,
                              deleteIconColor: Colors.orange,
                              onDeleted: () => setState(
                                () => _selectedConditions.remove(condition),
                              ),
                            );
                          }).toList(),
                        ),
                      if (_selectedConditions.isNotEmpty)
                        const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              label: "",
                              hint: "e.g. Diabetes, Ulcer...",
                              controller: _conditionController,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _addCondition,
                            child: const Text(
                              "Add",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              if (_healthStatus == 'Pregnant')
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Pregnancy Details",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown(
                              label: "Which Month?",
                              value: _selectedMonth,
                              items: _months,
                              onChanged: (val) => _updatePregnancyMonth(val!),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Trimester",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.purple.shade200,
                                    ),
                                  ),
                                  child: Text(
                                    _calculatedTrimester,
                                    style: const TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: "Do you have any pregnancy-related issues?",
                        hint: "e.g. Gestational diabetes...",
                        controller: _pregnancyIssuesController,
                      ),
                    ],
                  ),
                ),

              if (_healthStatus != 'Normal') const SizedBox(height: 16),

              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Food Allergies",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_selectedAllergies.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _selectedAllergies.map((allergy) {
                          return InputChip(
                            label: Text(
                              allergy,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: Colors.red.shade50,
                            deleteIconColor: Colors.redAccent,
                            onDeleted: () => setState(
                              () => _selectedAllergies.remove(allergy),
                            ),
                          );
                        }).toList(),
                      ),
                    if (_selectedAllergies.isNotEmpty)
                      const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: "",
                            hint: "Type allergy...",
                            controller: _allergyController,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _addAllergy,
                          child: const Text(
                            "Add",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: healthGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _isSaving ? null : _saveChanges,
                  child: _isSaving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          isEditing ? "Save Changes" : "Add Member",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 4),
          ),
        ],
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
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
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
              value: value,
              isExpanded: true,
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
