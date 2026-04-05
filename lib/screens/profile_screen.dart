import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Complaint> _complaints = [];
  bool _loadingComplaints = true;

  final List<Map<String, dynamic>> _allBadges = [
    {'id': 'civic_starter', 'emoji': '🌱', 'name': 'Civic Starter', 'pts': '50 pts', 'desc': 'First complaint'},
    {'id': 'eco_warrior', 'emoji': '♻️', 'name': 'Eco Warrior', 'pts': '200 pts', 'desc': 'SDG complaint'},
    {'id': 'city_guardian', 'emoji': '🛡️', 'name': 'City Guardian', 'pts': '500 pts', 'desc': '10 complaints'},
    {'id': 'rapid_reporter', 'emoji': '⚡', 'name': 'Rapid Reporter', 'pts': '150 pts', 'desc': 'High priority'},
    {'id': 'problem_solver', 'emoji': '🔧', 'name': 'Problem Solver', 'pts': '300 pts', 'desc': '5 resolved'},
  ];

  @override
  void initState() {
    super.initState();
    _loadComplaints();
  }

  Future<void> _loadComplaints() async {
    try {
      final list = await ApiService.myComplaints();
      if (mounted) setState(() => _complaints = list);
    } catch (_) {}
    if (mounted) setState(() => _loadingComplaints = false);
  }

  Future<void> _logout() async {
    await ApiService.clearAuth();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: RefreshIndicator(
        onRefresh: _loadComplaints,
        color: AppColors.blue,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── PROFILE HEADER ─────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                decoration: const BoxDecoration(color: AppColors.blue),
                child: Column(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Text(
                        widget.user.name.isNotEmpty
                            ? widget.user.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Sora',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.user.name,
                      style: const TextStyle(
                        fontFamily: 'Sora',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.user.email,
                      style: const TextStyle(
                          fontSize: 13, color: Colors.white60),
                    ),
                    const SizedBox(height: 20),
                    // Points box
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 28),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.15)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${widget.user.points}',
                            style: const TextStyle(
                              fontFamily: 'Sora',
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: AppColors.teal,
                            ),
                          ),
                          const Text(
                            'Total Points',
                            style: TextStyle(
                                fontSize: 12, color: Colors.white38),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── BADGES ─────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Badges',
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.85,
                        children: _allBadges.map((b) {
                          final earned =
                              widget.user.badges.contains(b['id']);
                          return Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: earned
                                  ? AppColors.successSoft
                                  : AppColors.bg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: earned
                                    ? AppColors.successBorder
                                    : AppColors.border,
                                width: 1.5,
                              ),
                            ),
                            child: Opacity(
                              opacity: earned ? 1.0 : 0.4,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Text(b['emoji'],
                                      style:
                                          const TextStyle(fontSize: 22)),
                                  const SizedBox(height: 6),
                                  Text(
                                    b['name'],
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textMid,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    earned ? b['pts'] : b['desc'],
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: earned
                                          ? AppColors.successText
                                          : AppColors.textLight,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── MY COMPLAINTS ──────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'My Complaints',
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.text,
                          ),
                        ),
                        Text(
                          '${_complaints.length} total',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textLight),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (_loadingComplaints)
                      const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.blue))
                    else if (_complaints.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Column(
                          children: [
                            Text('📭',
                                style: TextStyle(fontSize: 32)),
                            SizedBox(height: 10),
                            Text(
                              'No complaints yet.\nBe the first to report an issue!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textLight,
                                  height: 1.5),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _complaints.length,
                          separatorBuilder: (_, __) => const Divider(
                              height: 1, color: AppColors.border),
                          itemBuilder: (_, i) {
                            final c = _complaints[i];
                            return Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  Text(c.categoryEmoji,
                                      style:
                                          const TextStyle(fontSize: 22)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          c.category,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                            color: AppColors.text,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          c.rawText,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textLight,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          c.trackingId,
                                          style: const TextStyle(
                                            fontFamily: 'monospace',
                                            fontSize: 10,
                                            color: AppColors.textLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      StatusTag(c.status),
                                      const SizedBox(height: 4),
                                      PriorityTag(c.priority),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 20),

                    // ── LOGOUT ─────────────────────────────
                    OutlinedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout,
                          size: 16, color: AppColors.error),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: AppColors.error, width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 20),
                        minimumSize: const Size(double.infinity, 0),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
