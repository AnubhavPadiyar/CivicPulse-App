import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/api_service.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  bool _loginLoading = false;
  bool _registerLoading = false;
  String? _loginError;
  String? _loginSuccess;
  String? _registerError;
  String? _registerSuccess;

  final _loginEmail = TextEditingController();
  final _loginPass = TextEditingController();
  final _regName = TextEditingController();
  final _regEmail = TextEditingController();
  final _regPass = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _loginEmail.dispose();
    _loginPass.dispose();
    _regName.dispose();
    _regEmail.dispose();
    _regPass.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _loginEmail.text.trim();
    final pass = _loginPass.text;
    if (email.isEmpty || pass.isEmpty) {
      setState(() => _loginError = 'Please fill in all fields.');
      return;
    }
    setState(() {
      _loginLoading = true;
      _loginError = null;
      _loginSuccess = null;
    });
    try {
      final data = await ApiService.login(email, pass);
      final user = User.fromJson(data['user']);
      await ApiService.saveAuth(data['token'], user);
      setState(() => _loginSuccess = 'Login successful! Redirecting...');
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
      );
    } catch (e) {
      setState(() => _loginError = e.toString());
    } finally {
      if (mounted) setState(() => _loginLoading = false);
    }
  }

  Future<void> _handleRegister() async {
    final name = _regName.text.trim();
    final email = _regEmail.text.trim();
    final pass = _regPass.text;
    if (name.isEmpty || email.isEmpty || pass.isEmpty) {
      setState(() => _registerError = 'Please fill in all fields.');
      return;
    }
    if (pass.length < 6) {
      setState(() => _registerError = 'Password must be at least 6 characters.');
      return;
    }
    setState(() {
      _registerLoading = true;
      _registerError = null;
      _registerSuccess = null;
    });
    try {
      final data = await ApiService.register(name, email, pass);
      final user = User.fromJson(data['user']);
      await ApiService.saveAuth(data['token'], user);
      setState(() => _registerSuccess = 'Account created! Redirecting...');
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
      );
    } catch (e) {
      setState(() => _registerError = e.toString());
    } finally {
      if (mounted) setState(() => _registerLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── NAV ─────────────────────────────────
            Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  const CpLogo(),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: const Text(
                      '← Back',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ── BODY ─────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // ── BLUE LEFT PANEL (hero) ────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Stack(
                        children: [
                          // decorative circles
                          Positioned(
                            top: -40,
                            right: -40,
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -30,
                            left: -20,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: AppColors.teal.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Tag
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.15)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: AppColors.teal,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 7),
                                    const Text(
                                      'AI-Powered Platform',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Headline
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontFamily: 'Sora',
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    height: 1.2,
                                    letterSpacing: -0.5,
                                  ),
                                  children: [
                                    TextSpan(text: 'Be the change.\nReport. Track. Resolve.\n'),
                                    TextSpan(
                                      text: 'Build a better city.',
                                      style: TextStyle(color: AppColors.teal),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Report civic issues in seconds. Our AI routes your complaint to the right authority automatically.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white60,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Stats
                              Row(
                                children: const [
                                  StatItem(number: '2.4', suffix: 'K+', label: 'Complaints Filed'),
                                  SizedBox(width: 28),
                                  StatItem(number: '87', suffix: '%', label: 'Resolution Rate'),
                                  SizedBox(width: 28),
                                  StatItem(number: '48', suffix: 'h', label: 'Avg. Response'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ── AUTH CARD ─────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        border: Border(
                          left: BorderSide(color: AppColors.border),
                          right: BorderSide(color: AppColors.border),
                          bottom: BorderSide(color: AppColors.border),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tab switcher
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.bg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TabBar(
                              controller: _tabCtrl,
                              labelColor: AppColors.text,
                              unselectedLabelColor: AppColors.textLight,
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                              indicator: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(7),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: Colors.transparent,
                              tabs: const [
                                Tab(text: 'Login'),
                                Tab(text: 'Register'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),
                          // Tab views
                          SizedBox(
                            height: 320,
                            child: TabBarView(
                              controller: _tabCtrl,
                              children: [
                                _LoginTab(
                                  emailCtrl: _loginEmail,
                                  passCtrl: _loginPass,
                                  loading: _loginLoading,
                                  error: _loginError,
                                  success: _loginSuccess,
                                  onLogin: _handleLogin,
                                  onSwitch: () => _tabCtrl.animateTo(1),
                                ),
                                _RegisterTab(
                                  nameCtrl: _regName,
                                  emailCtrl: _regEmail,
                                  passCtrl: _regPass,
                                  loading: _registerLoading,
                                  error: _registerError,
                                  success: _registerSuccess,
                                  onRegister: _handleRegister,
                                  onSwitch: () => _tabCtrl.animateTo(0),
                                ),
                              ],
                            ),
                          ),
                        ],
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
}

// ─── LOGIN TAB ───────────────────────────────────────────
class _LoginTab extends StatelessWidget {
  final TextEditingController emailCtrl, passCtrl;
  final bool loading;
  final String? error, success;
  final VoidCallback onLogin, onSwitch;

  const _LoginTab({
    required this.emailCtrl,
    required this.passCtrl,
    required this.loading,
    required this.error,
    required this.success,
    required this.onLogin,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome back',
            style: TextStyle(
              fontFamily: 'Sora',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Login to track and manage your complaints',
            style: TextStyle(fontSize: 13, color: AppColors.textLight),
          ),
          const SizedBox(height: 16),
          if (error != null) ...[
            AlertBanner(message: error!),
            const SizedBox(height: 12),
          ],
          if (success != null) ...[
            AlertBanner(message: success!, isError: false),
            const SizedBox(height: 12),
          ],
          _LabeledField(label: 'Email Address', ctrl: emailCtrl,
              hint: 'you@example.com', type: TextInputType.emailAddress),
          const SizedBox(height: 12),
          _LabeledField(label: 'Password', ctrl: passCtrl,
              hint: 'Enter your password', obscure: true),
          const SizedBox(height: 16),
          CpButton(label: 'Login', onTap: onLogin, loading: loading),
          const SizedBox(height: 14),
          Center(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textLight,
                    fontFamily: 'Plus Jakarta Sans'),
                children: [
                  const TextSpan(text: "Don't have an account? "),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: onSwitch,
                      child: const Text(
                        'Register here',
                        style: TextStyle(
                          color: AppColors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── REGISTER TAB ────────────────────────────────────────
class _RegisterTab extends StatelessWidget {
  final TextEditingController nameCtrl, emailCtrl, passCtrl;
  final bool loading;
  final String? error, success;
  final VoidCallback onRegister, onSwitch;

  const _RegisterTab({
    required this.nameCtrl,
    required this.emailCtrl,
    required this.passCtrl,
    required this.loading,
    required this.error,
    required this.success,
    required this.onRegister,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create account',
            style: TextStyle(
              fontFamily: 'Sora',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Join thousands of active citizens',
            style: TextStyle(fontSize: 13, color: AppColors.textLight),
          ),
          const SizedBox(height: 16),
          if (error != null) ...[
            AlertBanner(message: error!),
            const SizedBox(height: 12),
          ],
          if (success != null) ...[
            AlertBanner(message: success!, isError: false),
            const SizedBox(height: 12),
          ],
          _LabeledField(label: 'Full Name', ctrl: nameCtrl,
              hint: 'Your full name'),
          const SizedBox(height: 12),
          _LabeledField(label: 'Email Address', ctrl: emailCtrl,
              hint: 'you@example.com', type: TextInputType.emailAddress),
          const SizedBox(height: 12),
          _LabeledField(label: 'Password', ctrl: passCtrl,
              hint: 'Min. 6 characters', obscure: true),
          const SizedBox(height: 16),
          CpButton(label: 'Create Account', onTap: onRegister, loading: loading),
          const SizedBox(height: 14),
          Center(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textLight,
                    fontFamily: 'Plus Jakarta Sans'),
                children: [
                  const TextSpan(text: 'Already have an account? '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: onSwitch,
                      child: const Text(
                        'Login here',
                        style: TextStyle(
                          color: AppColors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── LABELED FIELD ───────────────────────────────────────
class _LabeledField extends StatelessWidget {
  final String label, hint;
  final TextEditingController ctrl;
  final bool obscure;
  final TextInputType type;

  const _LabeledField({
    required this.label,
    required this.ctrl,
    required this.hint,
    this.obscure = false,
    this.type = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textMid,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          obscureText: obscure,
          keyboardType: type,
          style: const TextStyle(fontSize: 14, color: AppColors.text),
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
