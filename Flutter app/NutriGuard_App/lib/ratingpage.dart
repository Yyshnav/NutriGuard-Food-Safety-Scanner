import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutriguardapp/login_page.dart';
import 'package:nutriguardapp/signup_page.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reviewController = TextEditingController();

  int _selectedRating = 0;
  bool _isLoading = false;
  bool _isFetching = true;
  bool _hasPreviousRating = false;
  String? _previousDate;

  @override
  void initState() {
    super.initState();
    _fetchRating();
  }

  @override
  void dispose() {
    _reviewController.dispose();
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

  // GET: Fetch existing rating for this user
  Future<void> _fetchRating() async {
    setState(() {
      _isFetching = true;
    });

    try {
      final dio = Dio();
      final response = await dio.get('$baseurl/rating-feedback/$userId');
      if (response.statusCode == 200 && response.data['rating'] != null) {
        final r = response.data['rating'];
        setState(() {
          _selectedRating = (r['rating'] as num?)?.toInt() ?? 0;
          _reviewController.text = r['review']?.toString() ?? '';
          _hasPreviousRating = true;
          _previousDate = _formatDate(r['send_date']);
        });
      }
    } catch (e) {
      debugPrint('Error fetching rating: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isFetching = false;
        });
      }
    }
  }

  // POST: Send new or updated rating to Django backend
  Future<void> _submitRating() async {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a star rating first.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final dio = Dio();
      final response = await dio.post(
        '$baseurl/rating-feedback/$userId',
        data: {
          'rating': _selectedRating,
          'review': _reviewController.text.trim(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Thank you for your feedback!'),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            _hasPreviousRating = true;
            _previousDate = _formatDate(DateTime.now().toIso8601String());
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to submit feedback. Please try again.'),
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
          _isLoading = false;
        });
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
          'Rate & Review',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isFetching
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE0F2FE),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star_rate_rounded,
                          size: 60,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'How was your experience?',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F2942),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Your feedback helps us improve NutriGuard and protect your family.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blueGrey,
                        ),
                      ),

                      if (_hasPreviousRating && _previousDate != null && _previousDate!.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle, size: 14, color: Colors.green),
                              const SizedBox(width: 6),
                              Text(
                                'Previously submitted on $_previousDate',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 28),

                      // Interactive Star Rating Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final starIndex = index + 1;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedRating = starIndex;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Icon(
                                starIndex <= _selectedRating
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                size: 48,
                                color: starIndex <= _selectedRating
                                    ? Colors.amber
                                    : const Color(0xFFCBD5E1),
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 12),
                      Text(
                        _selectedRating > 0
                            ? '$_selectedRating / 5 Stars'
                            : 'Tap a star to rate',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _selectedRating > 0
                              ? const Color(0xFF0F2942)
                              : Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Review TextField
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Write a Review (Optional)',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _reviewController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Tell us what you liked or how we can improve...',
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
                            borderSide: const BorderSide(color: primarySkyBlue, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitRating,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primarySkyBlue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : Text(
                                  _hasPreviousRating ? 'Update Feedback' : 'Submit Feedback',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
