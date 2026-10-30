import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutriguardapp/login_page.dart';
import 'package:nutriguardapp/signup_page.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late TabController _tabController;

  bool _isSubmitting = false;
  bool _isLoadingComplaints = false;
  List<dynamic> _complaints = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchComplaints();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _formatDate(dynamic dateVal) {
    if (dateVal == null) return '';
    try {
      final dt = DateTime.parse(dateVal.toString()).toLocal();
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      String period = dt.hour >= 12 ? 'PM' : 'AM';
      int hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      String minute = dt.minute.toString().padLeft(2, '0');
      return "${dt.day} ${months[dt.month - 1]} ${dt.year}, $hour:$minute $period";
    } catch (_) {
      return dateVal.toString();
    }
  }

  Future<void> _fetchComplaints() async {
    setState(() {
      _isLoadingComplaints = true;
    });

    try {
      final dio = Dio();
      final response = await dio.get('$baseurl/complaint/$userId');
      if (response.statusCode == 200 && response.data['message'] == 'success') {
        setState(() {
          _complaints = response.data['complaints'] ?? [];
        });
      }
    } catch (e) {
      debugPrint('Error fetching complaints: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingComplaints = false;
        });
      }
    }
  }

  Future<void> _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        final dio = Dio();
        final response = await dio.post(
          '$baseurl/complaint/$userId',
          data: {
            'subject': _subjectController.text.trim(),
            'description': _descriptionController.text.trim(),
          },
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Complaint submitted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            _subjectController.clear();
            _descriptionController.clear();
          }
          await _fetchComplaints();
          _tabController.animateTo(1); // Switch to My Complaints tab
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(response.data['error']?.toString() ?? 'Failed to submit complaint.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to connect to server. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primarySkyBlue = Color(0xFF0284C7);
    const appBackgroundSky = Color(0xFFF0F9FF);

    return Scaffold(
      backgroundColor: appBackgroundSky,
      appBar: AppBar(
        backgroundColor: primarySkyBlue,
        elevation: 0,
        title: const Text(
          'Help & Support',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: [
            const Tab(
              icon: Icon(Icons.edit_note, size: 20),
              text: 'New Complaint',
            ),
            Tab(
              icon: const Icon(Icons.history, size: 20),
              text: _complaints.isNotEmpty
                  ? 'History (${_complaints.length})'
                  : 'History',
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildComplaintForm(primarySkyBlue),
            _buildComplaintsList(primarySkyBlue),
          ],
        ),
      ),
    );
  }

  // ======================================================================
  // TAB 1: COMPLAINT FORM
  // ======================================================================
  Widget _buildComplaintForm(Color primaryColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Submit a Complaint',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F2942),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Describe your issue below and our admin team will reply as soon as possible.',
              style: TextStyle(fontSize: 14, color: Colors.blueGrey),
            ),
            const SizedBox(height: 28),

            // Subject TextField
            const Text(
              'Subject',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _subjectController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'e.g., App crashes during scan',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a subject';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Description TextField
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Provide details about what happened...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please describe your issue';
                }
                return null;
              },
            ),
            const SizedBox(height: 28),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitComplaint,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        'Send Complaint',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================================
  // TAB 2: COMPLAINTS HISTORY & REPLIES
  // ======================================================================
  Widget _buildComplaintsList(Color primaryColor) {
    if (_isLoadingComplaints) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_complaints.isEmpty) {
      return RefreshIndicator(
        onRefresh: _fetchComplaints,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(32),
          children: [
            const SizedBox(height: 60),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFE0F2FE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_chat_unread_outlined,
                  size: 48,
                  color: Color(0xFF0284C7),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Complaints Yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F2942),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'If you face any issues with food scanning or your account, let us know via the "New Complaint" tab.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.blueGrey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchComplaints,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _complaints.length,
        itemBuilder: (context, index) {
          final item = _complaints[index];
          final subject = item['subject'] ?? 'Complaint';
          final description = item['description'] ?? '';
          final reply = item['reply'];
          final sendDate = _formatDate(item['send_date']);
          final replyDate = _formatDate(item['reply_date']);
          final hasReply = reply != null && reply.toString().trim().isNotEmpty;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status & Date row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: hasReply
                              ? const Color(0xFFDCFCE7)
                              : const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              hasReply ? Icons.check_circle : Icons.hourglass_top,
                              size: 14,
                              color: hasReply ? Colors.green[800] : Colors.orange[800],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              hasReply ? 'Admin Replied' : 'Pending Reply',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: hasReply ? Colors.green[800] : Colors.orange[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (sendDate.isNotEmpty)
                        Text(
                          sendDate,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Subject
                  Text(
                    subject,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F2942),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Description
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF475569),
                      height: 1.4,
                    ),
                  ),

                  // Reply box if admin answered
                  if (hasReply) ...[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBAE6FD)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.support_agent, color: primaryColor, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Admin Reply',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              if (replyDate.isNotEmpty)
                                Text(
                                  replyDate,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            reply.toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF0F2942),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
