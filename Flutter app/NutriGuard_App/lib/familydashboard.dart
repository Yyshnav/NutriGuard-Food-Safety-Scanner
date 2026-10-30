// import 'package:flutter/material.dart';
// import 'package:nutriguardapp/edit_family_health.dart';

// // IMPORTANT: Verify these match your actual files!
// import 'package:nutriguardapp/homepage.dart'; 
// import 'package:nutriguardapp/scanningpage.dart'; 
// import 'package:nutriguardapp/chatbotscreen.dart'; 
// import 'package:nutriguardapp/profile_dashboard.dart'; // Changed to match your profile import


// class FamilyMember {
//   final String id;
//   final String title;
//   final String subtitle;
//   final IconData avatarIcon;
//   final Color avatarBgColor;
//   final Color avatarIconColor;

//   FamilyMember({
//     required this.id,
//     required this.title,
//     required this.subtitle,
//     required this.avatarIcon,
//     required this.avatarBgColor,
//     required this.avatarIconColor,
//   });
// }

// class FamilyMembersScreen extends StatefulWidget {
//   const FamilyMembersScreen({super.key});

//   @override
//   State<FamilyMembersScreen> createState() => _FamilyMembersScreenState();
// }

// class _FamilyMembersScreenState extends State<FamilyMembersScreen> {
//   String selectedMemberId = '1';
//   final int _currentNavIndex = 2; // Active tab: Family

//   final List<FamilyMember> members = [
//     FamilyMember(
//       id: '1',
//       title: 'Me (Personal)',
//       subtitle: 'Age 24 • Male',
//       avatarIcon: Icons.person,
//       avatarBgColor: const Color(0xFFE0F2FE),
//       avatarIconColor: const Color(0xFF0284C7),
//     ),
//     FamilyMember(
//       id: '2',
//       title: 'Wife (Pregnancy)',
//       subtitle: '2nd Trimester • 26 years',
//       avatarIcon: Icons.pregnant_woman_rounded,
//       avatarBgColor: const Color(0xFFFCE4EC),
//       avatarIconColor: const Color(0xFFD81B60),
//     ),
//     FamilyMember(
//       id: '3',
//       title: 'Son (Child)',
//       subtitle: '10 years • Male',
//       avatarIcon: Icons.face_retouching_natural_outlined,
//       avatarBgColor: const Color(0xFFE8F5E9),
//       avatarIconColor: const Color(0xFF2E7D32),
//     ),
//     FamilyMember(
//       id: '4',
//       title: 'Father',
//       subtitle: '58 years • Male',
//       avatarIcon: Icons.escalator_warning_outlined,
//       avatarBgColor: const Color(0xFFFFF3E0),
//       avatarIconColor: const Color(0xFFEF6C00),
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     const primarySkyBlue = Color(0xFF0284C7);
//     const appBackgroundSky = Color(0xFFF0F9FF);
//     const cardAccentSky = Color(0xFFE0F2FE);

//     return Scaffold(
//       backgroundColor: appBackgroundSky,
      
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: primarySkyBlue, size: 20),
//           onPressed: () {
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeDashboard()));
//           },
//         ),
//         title: const Text(
//           'Family Members',
//           style: TextStyle(color: primarySkyBlue, fontWeight: FontWeight.bold, fontSize: 18),
//         ),
//         centerTitle: true,
//       ),
      
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Colors.white,
//         selectedItemColor: primarySkyBlue,
//         unselectedItemColor: Colors.grey,
//         currentIndex: _currentNavIndex,
//         onTap: (index) {
//           if (index == 0) {
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeDashboard()));
//           } else if (index == 1) {
//             Navigator.push(context, MaterialPageRoute(builder: (context) => const ScanScreen()));
//           } else if (index == 3) {
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
//           } else if (index == 4) {
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
//           }
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scan'),
//           BottomNavigationBarItem(icon: Icon(Icons.family_restroom_outlined), activeIcon: Icon(Icons.family_restroom), label: 'Family'),
//           BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Chat'),
//           BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),

//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.separated(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                 itemCount: members.length,
//                 separatorBuilder: (context, index) => const SizedBox(height: 16),
//                 itemBuilder: (context, index) {
//                   final member = members[index];
//                   final isSelected = selectedMemberId == member.id;

//                   // FULLY CONNECTED GESTURE DETECTOR
//                   return GestureDetector(
//                     onTap: () {
//                       // 1. Highlight the card
//                       setState(() {
//                         selectedMemberId = member.id;
//                       });

//                       // 2. Open the edit screen for this specific person
//                       String startingStatus = 'Normal';
//                       if (member.title.contains('Pregnancy')) startingStatus = 'Pregnant';
//                       if (member.title.contains('Father')) startingStatus = 'Patient';

//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => EditFamilyMemberScreen(
//                             memberName: member.title.replaceAll(RegExp(r'\(.*?\)'), '').trim(), 
//                             initialStatus: startingStatus,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                       decoration: BoxDecoration(
//                         color: isSelected ? cardAccentSky : Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(color: primarySkyBlue.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
//                         ],
//                         border: Border.all(color: isSelected ? primarySkyBlue : Colors.transparent, width: 2.0),
//                       ),
//                       child: Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 26,
//                             backgroundColor: member.avatarBgColor,
//                             child: Icon(member.avatarIcon, color: member.avatarIconColor, size: 28),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   member.title,
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: isSelected ? primarySkyBlue : Colors.black87,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   member.subtitle,
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     color: isSelected ? primarySkyBlue.withOpacity(0.7) : Colors.grey.shade600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Icon(isSelected ? Icons.check_circle : Icons.chevron_right, color: isSelected ? primarySkyBlue : Colors.grey.shade400, size: 24),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
            
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 60,
//                 child: ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: primarySkyBlue,
//                     foregroundColor: Colors.white,
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                   ),
//                   onPressed: () {
//                     // This opens a blank edit page to add a NEW member
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const EditFamilyMemberScreen(memberName: '', initialStatus: 'Normal'),
//                       ),
//                     );
//                   },
//                   icon: const Icon(Icons.add, size: 24),
//                   label: const Text('Add New Member', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

// Your navigation imports
import 'package:nutriguardapp/edit_family_health.dart';
import 'package:nutriguardapp/homepage.dart';
import 'package:nutriguardapp/login_page.dart'; 
import 'package:nutriguardapp/scanningpage.dart'; 
import 'package:nutriguardapp/chatbotscreen.dart'; 
import 'package:nutriguardapp/profile_dashboard.dart';
import 'package:nutriguardapp/signup_page.dart';

// ==========================================
// FAMILY MEMBER MODEL
// ==========================================
class FamilyMember {
  final int id;
  final String title;
  final String subtitle;
  final String relation;
  final int age;
  final String gender;
  final String height;
  final String weight;
  final String bmi;
  final String healthStatus;
  final String conditions;
  final String pregnancyMonth;
  final String trimester;
  final String pregnancyIssues;
  final String allergies;
  final bool isPregnant;
  final Map<String, dynamic> rawData;

  FamilyMember({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.relation,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.bmi,
    required this.healthStatus,
    required this.conditions,
    required this.pregnancyMonth,
    required this.trimester,
    required this.pregnancyIssues,
    required this.allergies,
    required this.isPregnant,
    required this.rawData,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
  final name = json['name']?.toString() ?? 'Unnamed';

  final relation = (
    json['relation'] ?? json['relationship'] ?? 'Other'
  ).toString();

  final healthStatus =
      json['health_status']?.toString() ?? 'Normal';

  final age =
      int.tryParse(json['age']?.toString() ?? '') ?? 0;

  final gender = json['gender']?.toString() ?? 'Male';
  final conditions = json['conditions']?.toString() ?? '';
  final trimester = json['trimester']?.toString() ?? '';
  final month = json['pregnancy_month']?.toString() ?? '';

  String displayTitle = name;

  if (relation.isNotEmpty &&
      relation != 'Other' &&
      !name.toLowerCase().contains(relation.toLowerCase())) {
    displayTitle = '$name ($relation)';
  }

  String displaySubtitle = '$relation • $age years • $gender';

  if (healthStatus == 'Pregnant') {
    displaySubtitle =
        '${trimester.isNotEmpty ? trimester : "Pregnant"}'
        ' • $month • $age yrs';
  } else if (healthStatus == 'Patient' &&
      conditions.isNotEmpty) {
    displaySubtitle = '$conditions • $age yrs • $gender';
  }

  return FamilyMember(
   id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
    title: displayTitle,
    subtitle: displaySubtitle,
    relation: relation,
    age: age,
    gender: gender,
    height: json['height']?.toString() ?? '170',
    weight: json['weight']?.toString() ?? '65',
    bmi: json['bmi']?.toString() ?? '0',
    healthStatus: healthStatus,
    conditions: conditions,
    pregnancyMonth: month,
    trimester: trimester,
    pregnancyIssues:
        json['pregnancy_issues']?.toString() ?? '',
    allergies: (
      json['allergies'] ?? json['food_allergies'] ?? ''
    ).toString(),
    isPregnant:
        json['is_pregnant'] == true ||
        healthStatus == 'Pregnant',
    rawData: json,
  );
}
  // Dynamic Avatar Icons & Colors
  IconData get avatarIcon {
    if (healthStatus == 'Pregnant' || isPregnant) return Icons.pregnant_woman_rounded;
    if (relation.toLowerCase() == 'child' || relation.toLowerCase() == 'son' || relation.toLowerCase() == 'daughter') {
      return Icons.face_retouching_natural_outlined;
    }
    if (relation.toLowerCase() == 'parent' || relation.toLowerCase() == 'father' || relation.toLowerCase() == 'mother') {
      return Icons.escalator_warning_outlined;
    }
    if (gender.toLowerCase() == 'female') return Icons.face_3_outlined;
    return Icons.person;
  }

  Color get avatarBgColor {
    if (healthStatus == 'Pregnant' || isPregnant) return const Color(0xFFFCE4EC);
    if (healthStatus == 'Patient') return const Color(0xFFFFF3E0);
    if (relation.toLowerCase() == 'child') return const Color(0xFFE8F5E9);
    return const Color(0xFFE0F2FE);
  }

  Color get avatarIconColor {
    if (healthStatus == 'Pregnant' || isPregnant) return const Color(0xFFD81B60);
    if (healthStatus == 'Patient') return const Color(0xFFEF6C00);
    if (relation.toLowerCase() == 'child') return const Color(0xFF2E7D32);
    return const Color(0xFF0284C7);
  }
}

// ==========================================
// FAMILY MEMBERS SCREEN
// ==========================================
class FamilyMembersScreen extends StatefulWidget {
  const FamilyMembersScreen({super.key, });

  @override
  State<FamilyMembersScreen> createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends State<FamilyMembersScreen> {
  int? selectedMemberId;
  final int _currentNavIndex = 2; // Active tab: Family

  // Base URL (Use 10.0.2.2 for Android Emulator, LAN IP for Physical Phone)

  bool _isLoading = true;
  String? _errorMessage;
  List<FamilyMember> members = [];

  @override
  void initState() {
    super.initState();
   
    _fetchMembers();
  }
final Dio dio=Dio();
  // Fetch all members from Django API
 Future<void> _fetchMembers() async {
  if (!mounted) return;

  setState(() {
    _isLoading = true;
    _errorMessage = null;
  });

  try {
    final response =
        await dio.get('$baseurl/family-members/$userId');

    debugPrint('Family API status: ${response.statusCode}');
    debugPrint('Family API response: ${response.data}');

    final data = response.data;

    if (response.statusCode == 200 && data is Map) {
      final status = (
        data['message'] ?? data['messge'] ?? ''
      ).toString();

      if (status.toLowerCase() == 'success') {
        final List rawList;

        if (data['members'] is List) {
          rawList = data['members'] as List;
        } else if (data['member'] is Map) {
          rawList = [data['member']];
        } else {
          rawList = [];
        }

        final loadedMembers = rawList
            .whereType<Map>()
            .map(
              (item) => FamilyMember.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();

        if (!mounted) return;

        setState(() {
          members = loadedMembers;

          if (members.isNotEmpty &&
              !members.any((m) => m.id == selectedMemberId)) {
            selectedMemberId = members.first.id;
          }

          _isLoading = false;
        });
      } else {
        throw Exception(
          data['error']?.toString() ??
          'The backend did not return success.',
        );
      }
    } else {
      throw Exception('Unexpected server response.');
    }
  } on DioException catch (e) {
    if (!mounted) return;

    setState(() {
      _errorMessage =
          e.response?.data is Map
              ? e.response?.data['error']?.toString() ??
                  e.message ??
                  'Network error'
              : e.message ?? 'Network error connecting to backend';

      _isLoading = false;
    });
  } catch (e) {
    if (!mounted) return;

    setState(() {
      _errorMessage = e.toString();
      _isLoading = false;
    });
  }
}
  // Delete Member API
  Future<void> _deleteMember(FamilyMember member) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Family Member'),
        content: Text('Are you sure you want to remove ${member.rawData['name']}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final response = await dio.delete('$baseurl/member/${member.id}');
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${member.rawData['name']} removed')),
        );
        _fetchMembers();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primarySkyBlue = Color(0xFF0284C7);
    const appBackgroundSky = Color(0xFFF0F9FF);
    const cardAccentSky = Color(0xFFE0F2FE);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeDashboard()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: appBackgroundSky,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: primarySkyBlue, size: 20),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeDashboard()),
                );
              }
            },
          ),
        title: const Text(
          'Family Members',
          style: TextStyle(color: primarySkyBlue, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: primarySkyBlue),
            onPressed: _fetchMembers,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primarySkyBlue,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentNavIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeDashboard()));
          } else if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ScanScreen()));
          } else if (index == 3) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: primarySkyBlue))
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: _fetchMembers,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : members.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.family_restroom_rounded, size: 70, color: Colors.grey.shade400),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No family members found',
                                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tap below to add your first family member',
                                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _fetchMembers,
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                itemCount: members.length,
                                separatorBuilder: (context, index) => const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  final member = members[index];
                                  final isSelected = selectedMemberId == member.id;

                                  return Dismissible(
                                    key: Key(member.id.toString()),
                                    direction: DismissDirection.endToStart,
                                    confirmDismiss: (direction) async {
                                      await _deleteMember(member);
                                      return false;
                                    },
                                    background: Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(right: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade400,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(Icons.delete, color: Colors.white),
                                    ),
                                    child: GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          selectedMemberId = member.id;
                                        });

                                        // Open edit screen for this specific person
                                        final updated = await Navigator.push<bool>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditFamilyMemberScreen(
                                              memberId: member.rawData['id'],
                                              memberName: member.rawData['name'] ?? '',
                                              initialStatus: member.healthStatus,
                                              memberData: member.rawData,
                                            ),
                                          ),
                                        );

                                        if (updated == true) {
                                          _fetchMembers();
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        decoration: BoxDecoration(
                                          color: isSelected ? cardAccentSky : Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(color: primarySkyBlue.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                                          ],
                                          border: Border.all(color: isSelected ? primarySkyBlue : Colors.transparent, width: 2.0),
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 26,
                                              backgroundColor: member.avatarBgColor,
                                              child: Icon(member.avatarIcon, color: member.avatarIconColor, size: 28),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    member.title,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: isSelected ? primarySkyBlue : Colors.black87,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    member.subtitle,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: isSelected ? primarySkyBlue.withOpacity(0.7) : Colors.grey.shade600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),Text("Swipe to delete"),
                                            SizedBox(width: 3,),
                                            Icon(
                                              isSelected ? Icons.check_circle : Icons.chevron_right,
                                              color: isSelected ? primarySkyBlue : Colors.grey.shade400,
                                              size: 24,
                                            ),
                                            
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primarySkyBlue,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () async {
                    // Open blank edit page to ADD a new member
                    final created = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditFamilyMemberScreen(
                        
                          memberName: '',
                          initialStatus: 'Normal',
                        ),
                      ),
                    );

                    if (created == true) {
                      _fetchMembers();
                    }
                  },
                  icon: const Icon(Icons.add, size: 24),
                  label: const Text('Add New Member', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}