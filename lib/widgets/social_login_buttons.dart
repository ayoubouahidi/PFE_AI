import 'package:flutter/material.dart';
import '../config/theme.dart';

class SocialLoginButtons extends StatefulWidget {
  final VoidCallback? onGooglePressed;
  final bool isLoading;

  const SocialLoginButtons({
    Key? key,
    this.onGooglePressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<SocialLoginButtons> createState() => _SocialLoginButtonsState();
}

class _SocialLoginButtonsState extends State<SocialLoginButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with text
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Row(
            children: [
              Expanded(
                child: Container(height: 1, color: AppTheme.borderLight),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Or continue with Google',
                  style: AppTheme.labelMedium.copyWith(
                    color: AppTheme.textLight,
                  ),
                ),
              ),
              Expanded(
                child: Container(height: 1, color: AppTheme.borderLight),
              ),
            ],
          ),
        ),

        // Google Button
        if (widget.onGooglePressed != null)
          _SocialButton(
            icon: Icons.g_mobiledata,
            label: 'Google',
            onPressed: widget.onGooglePressed!,
            isLoading: widget.isLoading,
          ),
      ],
    );
  }
}

class _SocialButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const _SocialButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: !widget.isLoading ? _handleTapDown : null,
      onTapUp: !widget.isLoading ? _handleTapUp : null,
      onTapCancel: !widget.isLoading ? _handleTapCancel : null,
      onTap: !widget.isLoading ? widget.onPressed : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppTheme.borderLight, width: 1.5),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            boxShadow: [AppTheme.shadowSmall],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: !widget.isLoading ? widget.onPressed : null,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              highlightColor: AppTheme.primary.withOpacity(0.1),
              splashColor: AppTheme.primary.withOpacity(0.2),
              child: Center(
                child:
                    widget.isLoading
                        ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primary,
                            ),
                          ),
                        )
                        : Icon(widget.icon, color: AppTheme.textDark, size: 28),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
