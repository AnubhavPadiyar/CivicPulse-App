import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../theme.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import '../services/api_service.dart';
import 'track_screen.dart';

class SubmitScreen extends StatefulWidget {
  final User user;
  final String? preCategory;
  const SubmitScreen({super.key, required this.user, this.preCategory});

  @override
  State<SubmitScreen> createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  final _textCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  String? _selectedCategory;
  bool _loading = false;
  String? _error;
  Complaint? _result;
  File? _selectedImage;
  final _picker = ImagePicker();

  final List<Map<String, String>> _categories = [
    {'emoji': '🛣️', 'name': 'Roads & Infrastructure'},
    {'emoji': '💧', 'name': 'Water Supply'},
    {'emoji': '🗑️', 'name': 'Garbage & Waste'},
    {'emoji': '🌊', 'name': 'Drainage & Sewage'},
    {'emoji': '⚡', 'name': 'Electricity & Streetlights'},
    {'emoji': '📋', 'name': 'Public Nuisance'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.preCategory;
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 75,
        maxWidth: 1200,
      );
      if (picked != null) {
        setState(() => _selectedImage = File(picked.path));
      }
    } catch (e) {
      setState(() => _error = 'Could not access ${source == ImageSource.camera ? "camera" : "gallery"}. Please check permissions.');
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Photo',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 16),
              _PickerOption(
                icon: Icons.camera_alt_outlined,
                label: 'Take a photo',
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 10),
              _PickerOption(
                icon: Icons.photo_library_outlined,
                label: 'Choose from gallery',
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_selectedImage != null) ...[
                const SizedBox(height: 10),
                _PickerOption(
                  icon: Icons.delete_outline,
                  label: 'Remove photo',
                  isDestructive: true,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedImage = null);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_textCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Please describe your complaint.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final complaint = await ApiService.submitComplaint(
        rawText: _textCtrl.text.trim(),
        category: _selectedCategory,
        locationAddress: _addressCtrl.text.trim().isEmpty
            ? null
            : _addressCtrl.text.trim(),
        image: _selectedImage,
      );
      setState(() => _result = complaint);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_result != null) return _SuccessView(complaint: _result!);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── HEADER ────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              color: AppColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionLabel('Report a Civic Issue'),
                  const SizedBox(height: 6),
                  const Text(
                    'Submit your complaint',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Describe the issue in plain language — our AI will handle the rest.',
                    style: TextStyle(fontSize: 13, color: AppColors.textLight, height: 1.5),
                  ),
                ],
              ),
            ),

            // ── FORM ──────────────────────────────────
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_error != null) ...[
                    AlertBanner(message: _error!),
                    const SizedBox(height: 16),
                  ],

                  // Category picker
                  const Text('Category', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMid)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categories.map((c) {
                      final selected = _selectedCategory == c['name'];
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = c['name']),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.blueSoft : AppColors.bg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected ? AppColors.blue : AppColors.border,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            '${c['emoji']} ${c['name']}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: selected ? AppColors.blue : AppColors.textMid,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Complaint text
                  const Text('Describe the Issue', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMid)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _textCtrl,
                    maxLines: 5,
                    style: const TextStyle(fontSize: 14, color: AppColors.text),
                    decoration: const InputDecoration(
                      hintText: 'e.g. "There is a huge pothole on MG Road near the petrol station..."',
                      alignLabelWithHint: true,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Location
                  const Text('Location (optional)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMid)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _addressCtrl,
                    style: const TextStyle(fontSize: 14, color: AppColors.text),
                    decoration: const InputDecoration(
                      hintText: 'e.g. MG Road, near petrol station',
                      prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.textLight, size: 18),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── PHOTO UPLOAD ──────────────────────
                  const Text('Photo (optional)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMid)),
                  const SizedBox(height: 8),

                  if (_selectedImage != null) ...[
                    // Show selected image preview
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImage!,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: _showImagePicker,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(Icons.edit, color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedImage = null),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(Icons.close, color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Photo picker button
                    GestureDetector(
                      onTap: _showImagePicker,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          color: AppColors.bg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.border,
                            width: 1.5,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          children: const [
                            Icon(Icons.add_a_photo_outlined, color: AppColors.textLight, size: 28),
                            SizedBox(height: 8),
                            Text(
                              'Tap to add a photo',
                              style: TextStyle(fontSize: 13, color: AppColors.textLight, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Camera or Gallery',
                              style: TextStyle(fontSize: 11, color: AppColors.textLight),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // AI notice
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.blueSoft,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.blueLight),
                    ),
                    child: Row(
                      children: const [
                        Text('✨', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Gemini AI will automatically classify your complaint, assign priority, and route it to the right department.',
                            style: TextStyle(fontSize: 12, color: AppColors.blue, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  CpButton(label: 'Submit Complaint →', onTap: _submit, loading: _loading),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── IMAGE PICKER OPTION ──────────────────────────────────
class _PickerOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _PickerOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : AppColors.textMid;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDestructive ? AppColors.errorSoft : AppColors.bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDestructive ? AppColors.error.withOpacity(0.3) : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── SUCCESS VIEW ─────────────────────────────────────────
class _SuccessView extends StatelessWidget {
  final Complaint complaint;
  const _SuccessView({required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              width: 72, height: 72,
              decoration: const BoxDecoration(color: AppColors.successSoft, shape: BoxShape.circle),
              child: const Icon(Icons.check_circle, color: AppColors.successText, size: 40),
            ),
            const SizedBox(height: 20),
            const Text('Complaint Submitted!',
              style: TextStyle(fontFamily: 'Sora', fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.text)),
            const SizedBox(height: 8),
            const Text(
              'Your complaint has been processed by AI and forwarded to the relevant authority.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textMid, height: 1.55),
            ),
            const SizedBox(height: 28),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Tracking ID',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMid)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(complaint.trackingId,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 18,
                          fontWeight: FontWeight.w700, color: AppColors.blue, letterSpacing: 1),
                      textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 16),
                  _InfoRow('Category', complaint.category),
                  _InfoRow('Priority', complaint.priority),
                  _InfoRow('Department', complaint.authority ?? complaint.department ?? '—'),
                  _InfoRow('Status', complaint.status),
                  if (complaint.sdgMessage != null && complaint.sdgMessage!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.tealSoft,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.teal.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Text('🌱', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 8),
                          Expanded(child: Text(complaint.sdgMessage!,
                            style: const TextStyle(fontSize: 12, color: AppColors.teal, height: 1.4))),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            CpButton(
              label: 'Track My Complaint',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => TrackScreen(initialId: complaint.trackingId)),
              ),
            ),
            const SizedBox(height: 10),
            CpOutlineButton(
              label: 'Back to Home',
              onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 90,
            child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textLight, fontWeight: FontWeight.w500))),
          Text(value, style: const TextStyle(fontSize: 13, color: AppColors.text, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
