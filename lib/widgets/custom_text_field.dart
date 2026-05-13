// Example: Using CustomTextField
import 'package:flutter/material.dart';
import '../config/theme.dart';

enum TextFieldType { text, email, password, phone, url }

class CustomTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  final String? value;
  final Function(String) onChanged;
  final String? error;
  final TextFieldType type;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool showCharacterCount;
  final TextInputAction textInputAction;
  final Function()? onSubmitted;
  final bool readOnly;
  final Function()? onTap;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.placeholder,
    this.value,
    required this.onChanged,
    this.error,
    this.type = TextFieldType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.showCharacterCount = false,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _obscureText = true;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value ?? '';
    }
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case TextFieldType.email:
        return TextInputType.emailAddress;
      case TextFieldType.phone:
        return TextInputType.phone;
      case TextFieldType.url:
        return TextInputType.url;
      case TextFieldType.password:
        return TextInputType.visiblePassword;
      default:
        return TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.error != null && widget.error!.isNotEmpty;
    final borderColor = _isFocused
        ? AppTheme.primary
        : hasError
            ? AppTheme.error
            : AppTheme.borderLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            widget.label,
            style: AppTheme.labelMedium.copyWith(
              color: AppTheme.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // TextField
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            boxShadow: _isFocused ? [AppTheme.shadowSmall] : [],
          ),
          child: TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: widget.onChanged,
            keyboardType: _getKeyboardType(),
            obscureText: widget.type == TextFieldType.password && _obscureText,
            maxLines: widget.type == TextFieldType.password ? 1 : widget.maxLines,
            minLines: widget.minLines,
            maxLength: widget.maxLength,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            textInputAction: widget.textInputAction,
            onFieldSubmitted: (_) => widget.onSubmitted?.call(),
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textLight,
              ),
              filled: true,
              fillColor: AppTheme.inputBackground,
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: _isFocused ? AppTheme.primary : AppTheme.textLight,
                      size: 20,
                    )
                  : null,
              suffixIcon: widget.type == TextFieldType.password
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppTheme.textLight,
                        size: 20,
                      ),
                    )
                  : widget.suffixIcon != null
                      ? Icon(
                          widget.suffixIcon,
                          color:
                              _isFocused ? AppTheme.primary : AppTheme.textLight,
                          size: 20,
                        )
                      : null,
              counterText: widget.showCharacterCount ? null : '',
              counterStyle: AppTheme.labelSmall.copyWith(
                color: AppTheme.textLight,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                borderSide: BorderSide(
                  color: borderColor,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                borderSide: BorderSide(
                  color: hasError ? AppTheme.error : AppTheme.borderLight,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                borderSide: BorderSide(
                  color: AppTheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                borderSide: BorderSide(
                  color: AppTheme.error,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                borderSide: BorderSide(
                  color: AppTheme.error,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textDark,
            ),
          ),
        ),

        // Error Message
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppTheme.error,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.error!,
                    style: AppTheme.labelSmall.copyWith(
                      color: AppTheme.error,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
