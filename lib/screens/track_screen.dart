import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import '../services/api_service.dart';

class TrackScreen extends StatefulWidget {
  final String? initialId;
  const TrackScreen({super.key, this.initialId});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  final _ctrl = TextEditingController();
  bool _loading = false;
  String? _error;
  Complaint? _complaint;

  final List<String> _statuses = [
    'Submitted',
    'Under Review',
    'In Progress',
    'Resolved',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialId != null) {
      _ctrl.text = widget.initialId!;
      WidgetsBinding.instance.addPostFrameCallback((_) => _track());
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _track() async {
    final id = _ctrl.text.trim();
    if (id.isEmpty) {
      setState(() => _error = 'Please enter a tracking ID.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
      _complaint = null;
    });
    try {
      final c = await ApiService.trackComplaint(id);
      setState(() => _complaint = c);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── BLUE HERO ─────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(color: AppColors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Track Your Complaint',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Enter your tracking ID to get real-time status updates.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white60,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ctrl,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          onSubmitted: (_) => _track(),
                          decoration: InputDecoration(
                            hintText: 'CP-XXXXXXXX',
                            hintStyle: const TextStyle(
                                color: Colors.white38,
                                fontFamily: 'monospace'),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: AppColors.teal, width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 13),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _loading ? null : _track,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 13, horizontal: 18),
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                'Track →',
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── ERROR ─────────────────────────────────
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: AlertBanner(message: _error!),
              ),

            // ── RESULT ────────────────────────────────
            if (_complaint != null) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Header card
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
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.blueSoft,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  _complaint!.categoryEmoji,
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _complaint!.category,
                                      style: const TextStyle(
                                        fontFamily: 'Sora',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: AppColors.text,
                                      ),
                                    ),
                                    Text(
                                      _complaint!.trackingId,
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 12,
                                        color: AppColors.textLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              StatusTag(_complaint!.status),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(color: AppColors.border),
                          const SizedBox(height: 12),
                          Text(
                            _complaint!.rawText,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textMid,
                              height: 1.55,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              PriorityTag(_complaint!.priority),
                              const SizedBox(width: 8),
                              if (_complaint!.authority != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.bg,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Text(
                                    _complaint!.authority!,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textMid,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Timeline card
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
                          const Text(
                            'STATUS TIMELINE',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: AppColors.textLight,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ..._buildTimeline(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ── EMPTY STATE ───────────────────────────
            if (_complaint == null && _error == null && !_loading)
              Padding(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.blueSoft,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.search,
                            color: AppColors.blue, size: 30),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Enter a tracking ID above\nto view complaint status.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textLight,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTimeline() {
    final currentIdx = _statuses.indexOf(_complaint!.status);
    final isRejected = _complaint!.status == 'Rejected';

    final steps = isRejected
        ? [..._statuses.take(currentIdx + 1), 'Rejected']
        : _statuses;

    return List.generate(steps.length, (i) {
      final s = steps[i];
      final isDone = isRejected
          ? i < steps.length - 1
          : (i < currentIdx || _complaint!.status == 'Resolved');
      final isActive = !isRejected && i == currentIdx && s != 'Resolved';
      final isLast = i == steps.length - 1;

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _TimelineDot(
                  done: isDone || s == 'Resolved' && _complaint!.status == 'Resolved',
                  active: isActive,
                  rejected: s == 'Rejected'),
              if (!isLast)
                Container(
                  width: 2,
                  height: 32,
                  color: isDone ? AppColors.teal.withOpacity(0.4) : AppColors.border,
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: (isDone || isActive)
                          ? AppColors.text
                          : AppColors.textLight,
                    ),
                  ),
                  Text(
                    _stepDesc(s),
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textLight),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  String _stepDesc(String s) {
    switch (s) {
      case 'Submitted': return 'Complaint received & AI processed';
      case 'Under Review': return 'Reviewing by authority';
      case 'In Progress': return 'Team assigned, work underway';
      case 'Resolved': return 'Issue has been resolved ✓';
      case 'Rejected': return 'Complaint could not be processed';
      default: return '';
    }
  }
}

class _TimelineDot extends StatelessWidget {
  final bool done, active, rejected;
  const _TimelineDot(
      {required this.done, required this.active, required this.rejected});

  @override
  Widget build(BuildContext context) {
    if (rejected) {
      return Container(
        width: 22,
        height: 22,
        decoration: const BoxDecoration(
            color: AppColors.tagRedBg,
            shape: BoxShape.circle,
            border: Border.fromBorderSide(
                BorderSide(color: AppColors.tagRedText, width: 2))),
        child: const Icon(Icons.close,
            size: 12, color: AppColors.tagRedText),
      );
    }
    if (done) {
      return Container(
        width: 22,
        height: 22,
        decoration: const BoxDecoration(
            color: AppColors.teal, shape: BoxShape.circle),
        child:
            const Icon(Icons.check, size: 12, color: Colors.white),
      );
    }
    if (active) {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.teal, width: 2),
        ),
        child: Center(
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
                color: AppColors.teal, shape: BoxShape.circle),
          ),
        ),
      );
    }
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border, width: 2),
      ),
    );
  }
}
