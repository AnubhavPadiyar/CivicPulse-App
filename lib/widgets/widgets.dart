import 'package:flutter/material.dart';
import '../theme.dart';

// ─── LOGO ───────────────────────────────────────────────
class CpLogo extends StatelessWidget {
  final double size;
  const CpLogo({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            'CP',
            style: TextStyle(
              fontFamily: 'Sora',
              fontWeight: FontWeight.w800,
              fontSize: size * 0.38,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'Sora',
              fontWeight: FontWeight.w800,
              fontSize: size * 0.5,
              color: AppColors.text,
            ),
            children: const [
              TextSpan(text: 'Civic'),
              TextSpan(text: 'Pulse', style: TextStyle(color: AppColors.blue)),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── NAV BAR ────────────────────────────────────────────
class CpNavBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? trailing;
  const CpNavBar({super.key, this.trailing});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

// ─── PRIMARY BUTTON ─────────────────────────────────────
class CpButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool loading;
  final Color? color;
  const CpButton({
    super.key,
    required this.label,
    this.onTap,
    this.loading = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.blue,
          disabledBackgroundColor: AppColors.border,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: loading ? 0 : 2,
          shadowColor: AppColors.blue.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

// ─── OUTLINE BUTTON ─────────────────────────────────────
class CpOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const CpOutlineButton({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textMid,
          side: const BorderSide(color: AppColors.border, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

// ─── PRIORITY TAG ────────────────────────────────────────
class PriorityTag extends StatelessWidget {
  final String priority;
  const PriorityTag(this.priority, {super.key});

  @override
  Widget build(BuildContext context) {
    Color bg, fg;
    switch (priority) {
      case 'Critical':
        bg = AppColors.tagRedBg; fg = AppColors.tagRedText; break;
      case 'High':
        bg = AppColors.tagOrangeBg; fg = AppColors.tagOrangeText; break;
      case 'Low':
        bg = AppColors.tagGreenBg; fg = AppColors.tagGreenText; break;
      default:
        bg = AppColors.blueSoft; fg = AppColors.blue;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        priority,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─── STATUS TAG ──────────────────────────────────────────
class StatusTag extends StatelessWidget {
  final String status;
  const StatusTag(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    Color bg, fg;
    switch (status) {
      case 'Resolved':
        bg = AppColors.tagGreenBg; fg = AppColors.tagGreenText; break;
      case 'Rejected':
        bg = AppColors.tagRedBg; fg = AppColors.tagRedText; break;
      case 'In Progress':
        bg = AppColors.tagOrangeBg; fg = AppColors.tagOrangeText; break;
      case 'Under Review':
        bg = AppColors.blueSoft; fg = AppColors.blue; break;
      default:
        bg = const Color(0xFFF0F0F0); fg = AppColors.textMid;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status == 'Resolved' ? '✓ $status' : status,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─── ALERT BANNER ────────────────────────────────────────
class AlertBanner extends StatelessWidget {
  final String message;
  final bool isError;
  const AlertBanner({super.key, required this.message, this.isError = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: isError ? AppColors.errorSoft : AppColors.successSoft,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: isError ? const Color(0xFFFCCACA) : AppColors.successBorder,
        ),
      ),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isError ? AppColors.error : AppColors.successText,
        ),
      ),
    );
  }
}

// ─── SECTION LABEL ───────────────────────────────────────
class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: AppColors.blue,
      ),
    );
  }
}

// ─── STAT CARD ───────────────────────────────────────────
class StatItem extends StatelessWidget {
  final String number;
  final String suffix;
  final String label;
  const StatItem({
    super.key,
    required this.number,
    required this.suffix,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontFamily: 'Sora',
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            children: [
              TextSpan(text: number),
              TextSpan(
                text: suffix,
                style: const TextStyle(color: AppColors.teal),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white38,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ─── LIVE BADGE ──────────────────────────────────────────
class LiveBadge extends StatefulWidget {
  const LiveBadge({super.key});

  @override
  State<LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<LiveBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 1, end: 0.3).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8FBF5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFB8F0DA)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: _anim,
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF22C55E),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 5),
          const Text(
            'Live',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A7A50),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── COMPLAINT MINI CARD ─────────────────────────────────
class ComplaintMiniCard extends StatelessWidget {
  final String emoji;
  final String type;
  final String desc;
  final String trackingId;
  final String status;
  const ComplaintMiniCard({
    super.key,
    required this.emoji,
    required this.type,
    required this.desc,
    required this.trackingId,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.blueSoft,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      trackingId,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        color: AppColors.textLight,
                      ),
                    ),
                    StatusTag(status),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── CATEGORY CARD ───────────────────────────────────────
class CategoryCard extends StatelessWidget {
  final String emoji;
  final String name;
  final VoidCallback onTap;
  const CategoryCard({
    super.key,
    required this.emoji,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textMid,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
