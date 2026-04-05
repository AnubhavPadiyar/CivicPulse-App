import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import 'submit_screen.dart';
import 'track_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  final List<Map<String, String>> _categories = [
    {'emoji': '🛣️', 'name': 'Roads &\nInfrastructure', 'cat': 'Roads & Infrastructure'},
    {'emoji': '💧', 'name': 'Water\nSupply', 'cat': 'Water Supply'},
    {'emoji': '🗑️', 'name': 'Garbage\n& Waste', 'cat': 'Garbage & Waste'},
    {'emoji': '🌊', 'name': 'Drainage\n& Sewage', 'cat': 'Drainage & Sewage'},
    {'emoji': '⚡', 'name': 'Electricity &\nStreetlights', 'cat': 'Electricity & Streetlights'},
    {'emoji': '📋', 'name': 'Public\nNuisance', 'cat': 'Public Nuisance'},
  ];

  void _goToSubmit([String? category]) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => SubmitScreen(user: widget.user, preCategory: category),
    ));
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── HERO ──────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 28),
            color: AppColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.blueSoft,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.blueLight),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _PulseDot(color: AppColors.teal),
                      const SizedBox(width: 7),
                      const Text(
                        'AI-Powered · Gemini',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blue,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                      height: 1.15,
                      letterSpacing: -1,
                    ),
                    children: [
                      TextSpan(text: 'Your city.\nYour voice.\n'),
                      TextSpan(
                        text: 'Real action.',
                        style: TextStyle(color: AppColors.blue),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Report civic issues in plain language — garbage, potholes, water leaks, broken streetlights. AI routes it to the right authority in seconds.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textMid,
                    height: 1.65,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _goToSubmit(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          elevation: 2,
                          shadowColor: AppColors.blue.withOpacity(0.3),
                        ),
                        child: const Text(
                          'Report an Issue →',
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _tab = 1),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textMid,
                          side: const BorderSide(
                              color: AppColors.border, width: 1.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                        child: const Text(
                          'Track Complaint',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: const [
                      _StatStrip(num: '2.4K+', label: 'Complaints Filed'),
                      SizedBox(width: 28),
                      _StatStrip(num: '87%', label: 'Resolution Rate'),
                      SizedBox(width: 28),
                      _StatStrip(num: '48h', label: 'Avg. Response'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── RECENT REPORTS MOCKUP ──────────────────────
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blue.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Reports',
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppColors.text,
                      ),
                    ),
                    const LiveBadge(),
                  ],
                ),
                const SizedBox(height: 12),
                const ComplaintMiniCard(
                  emoji: '🗑️',
                  type: 'Garbage Overflow',
                  desc: 'Market area, not collected for 4 days',
                  trackingId: 'CP-A4F82B1C',
                  status: 'In Progress',
                ),
                const ComplaintMiniCard(
                  emoji: '💧',
                  type: 'Water Pipe Burst',
                  desc: 'Main road, wasting since morning',
                  trackingId: 'CP-D3C92A4E',
                  status: 'Under Review',
                ),
                const ComplaintMiniCard(
                  emoji: '🚦',
                  type: 'Traffic Signal Down',
                  desc: 'Main junction, not working since last night',
                  trackingId: 'CP-B1E74F2D',
                  status: 'Resolved',
                ),
              ],
            ),
          ),

          // ── CATEGORIES ─────────────────────────────────
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel('What do you want to report?'),
                const SizedBox(height: 6),
                const Text(
                  'Select a category',
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: _categories
                      .map((c) => CategoryCard(
                            emoji: c['emoji']!,
                            name: c['name']!,
                            onTap: () => _goToSubmit(c['cat']),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),

          // ── HOW IT WORKS ────────────────────────────────
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel('How It Works'),
                const SizedBox(height: 6),
                const Text(
                  'Three steps to resolution',
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),
                _HowCard(
                  num: '01',
                  title: 'Describe the Issue',
                  desc:
                      'Type your complaint in plain language. Add a photo and pin your location — no forms, no confusion.',
                ),
                const SizedBox(height: 10),
                _HowCard(
                  num: '02',
                  title: 'AI Routes It',
                  desc:
                      'Gemini AI reads your complaint, assigns priority, and routes it to the correct government department.',
                ),
                const SizedBox(height: 10),
                _HowCard(
                  num: '03',
                  title: 'Track & Resolve',
                  desc:
                      'Get a unique tracking ID. Monitor your complaint\'s status in real time. Earn badges for participation.',
                ),
              ],
            ),
          ),

          // ── TRACK CTA (BLUE BANNER) ─────────────────────
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Already filed?\nTrack your complaint.',
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter your tracking ID to get real-time status updates.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white60,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() => _tab = 1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 13, horizontal: 24),
                  ),
                  child: const Text(
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
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildHomeTab(),
      TrackScreen(),
      SubmitScreen(user: widget.user),
      ProfileScreen(user: widget.user),
    ];

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const CpLogo(),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => ProfileScreen(user: widget.user)),
                    ),
                    child: CircleAvatar(
                      radius: 17,
                      backgroundColor: AppColors.blue,
                      child: Text(
                        widget.user.name.isNotEmpty
                            ? widget.user.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: IndexedStack(index: _tab, children: screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: (i) => setState(() => _tab = i),
          backgroundColor: AppColors.white,
          indicatorColor: AppColors.blueSoft,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: AppColors.blue),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search, color: AppColors.blue),
              label: 'Track',
            ),
            NavigationDestination(
              icon: Icon(Icons.add_circle_outline),
              selectedIcon: Icon(Icons.add_circle, color: AppColors.blue),
              label: 'Report',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: AppColors.blue),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper widgets ──────────────────────────────────────

class _PulseDot extends StatefulWidget {
  final Color color;
  const _PulseDot({required this.color});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 1.0, end: 0.4).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}

class _StatStrip extends StatelessWidget {
  final String num, label;
  const _StatStrip({required this.num, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          num,
          style: const TextStyle(
            fontFamily: 'Sora',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textLight,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _HowCard extends StatelessWidget {
  final String num, title, desc;
  const _HowCard(
      {required this.num, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              num,
              style: const TextStyle(
                fontFamily: 'Sora',
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMid,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
