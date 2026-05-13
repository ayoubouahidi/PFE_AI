import 'package:flutter/material.dart';
import '../config/theme.dart';

enum ButtonVariant { primary, secondary, outline, text }

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final ButtonVariant variant;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final double? width;
  final double height;
  final EdgeInsets padding;
  final TextStyle? textStyle;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.variant = ButtonVariant.primary,
    this.leadingIcon,
    this.trailingIcon,
    this.width,
    this.height = 56,
    this.padding = const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    this.textStyle,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
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

  Color _getBackgroundColor() {
    if (!widget.isEnabled) {
      return AppTheme.primary.withOpacity(0.5);
    }
    switch (widget.variant) {
      case ButtonVariant.primary:
        return AppTheme.primary;
      case ButtonVariant.secondary:
        return AppTheme.primaryDark;
      case ButtonVariant.outline:
        return Colors.transparent;
      case ButtonVariant.text:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor() {
    switch (widget.variant) {
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
        return Colors.white;
      case ButtonVariant.outline:
      case ButtonVariant.text:
        return AppTheme.primary;
    }
  }

  Color _getBorderColor() {
    if (!widget.isEnabled) {
      return AppTheme.primary.withOpacity(0.5);
    }
    switch (widget.variant) {
      case ButtonVariant.outline:
        return AppTheme.primary;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isEnabled && !widget.isLoading ? _handleTapDown : null,
      onTapUp: widget.isEnabled && !widget.isLoading ? _handleTapUp : null,
      onTapCancel: widget.isEnabled && !widget.isLoading ? _handleTapCancel : null,
      onTap: widget.isEnabled && !widget.isLoading ? widget.onPressed : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            border: Border.all(
              color: _getBorderColor(),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            boxShadow: widget.variant == ButtonVariant.primary && widget.isEnabled
                ? [AppTheme.shadowSmall]
                : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isEnabled && !widget.isLoading
                  ? widget.onPressed
                  : null,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              highlightColor: Colors.white.withOpacity(0.1),
              splashColor: Colors.white.withOpacity(0.2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Leading Icon
                  if (widget.leadingIcon != null && !widget.isLoading)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        widget.leadingIcon,
                        color: _getForegroundColor(),
                        size: 20,
                      ),
                    ),

                  // Loading Spinner
                  if (widget.isLoading)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getForegroundColor(),
                          ),
                        ),
                      ),
                    ),

                  // Text
                  Text(
                    widget.isLoading ? 'Please wait...' : widget.text,
                    style: widget.textStyle ??
                        AppTheme.buttonLarge.copyWith(
                          color: _getForegroundColor(),
                          fontWeight: FontWeight.w600,
                        ),
                  ),

                  // Trailing Icon
                  if (widget.trailingIcon != null && !widget.isLoading)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(
                        widget.trailingIcon,
                        color: _getForegroundColor(),
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
