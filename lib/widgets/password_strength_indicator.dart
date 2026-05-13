import 'package:flutter/material.dart';
import '../config/theme.dart';

class PasswordStrengthIndicator extends StatefulWidget {
  final String password;
  final double strengthPercentage; // 0.0 to 1.0
  final String? label; // 'Weak', 'Fair', 'Good', 'Strong'
  final bool showLabel;

  const PasswordStrengthIndicator({
    Key? key,
    required this.password,
    required this.strengthPercentage,
    this.label,
    this.showLabel = true,
  }) : super(key: key);

  @override
  State<PasswordStrengthIndicator> createState() =>
      _PasswordStrengthIndicatorState();
}

class _PasswordStrengthIndicatorState extends State<PasswordStrengthIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation =
        Tween<double>(begin: 0, end: widget.strengthPercentage).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(PasswordStrengthIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.strengthPercentage != widget.strengthPercentage) {
      _animationController.forward(from: 0);
      _animation =
          Tween<double>(begin: 0, end: widget.strengthPercentage).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getColorByStrength(double strength) {
    if (strength < 0.25) {
      return AppTheme.error; // Weak - Red
    } else if (strength < 0.5) {
      return AppTheme.warning; // Fair - Orange
    } else if (strength < 0.75) {
      return AppTheme.warning; // Good - Yellow
    } else {
      return AppTheme.success; // Strong - Green
    }
  }

  IconData _getIconByStrength(double strength) {
    if (strength < 0.25) {
      return Icons.close_rounded;
    } else if (strength < 0.5) {
      return Icons.priority_high_rounded;
    } else if (strength < 0.75) {
      return Icons.check_circle_outline_rounded;
    } else {
      return Icons.check_circle_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar with animation
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          child: LinearProgressIndicator(
            value: widget.password.isEmpty ? 0 : widget.strengthPercentage,
            minHeight: 8,
            backgroundColor: AppTheme.borderLight,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getColorByStrength(widget.strengthPercentage),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Strength label with icon
        if (widget.showLabel && widget.label != null)
          Row(
            children: [
              Icon(
                _getIconByStrength(widget.strengthPercentage),
                size: 16,
                color: _getColorByStrength(widget.strengthPercentage),
              ),
              const SizedBox(width: 6),
              Text(
                widget.label ?? 'Password Strength',
                style: AppTheme.labelSmall.copyWith(
                  color: _getColorByStrength(widget.strengthPercentage),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${(widget.strengthPercentage * 100).toStringAsFixed(0)}%)',
                style: AppTheme.labelSmall.copyWith(
                  color: AppTheme.textLight,
                ),
              ),
            ],
          ),

        // Requirements checklist (optional)
        if (widget.password.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RequirementItem(
                  label: 'At least 8 characters',
                  isMet: widget.password.length >= 8,
                ),
                const SizedBox(height: 4),
                _RequirementItem(
                  label: 'Contains uppercase letter (A-Z)',
                  isMet: widget.password.contains(RegExp(r'[A-Z]')),
                ),
                const SizedBox(height: 4),
                _RequirementItem(
                  label: 'Contains number (0-9)',
                  isMet: widget.password.contains(RegExp(r'[0-9]')),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _RequirementItem extends StatelessWidget {
  final String label;
  final bool isMet;

  const _RequirementItem({
    Key? key,
    required this.label,
    required this.isMet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle_rounded : Icons.circle_outlined,
          size: 16,
          color: isMet ? AppTheme.success : AppTheme.textLight,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTheme.labelSmall.copyWith(
            color: isMet ? AppTheme.textDark : AppTheme.textLight,
            decoration: isMet ? null : null,
          ),
        ),
      ],
    );
  }
}
