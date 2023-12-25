import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    this.onTap,
    required this.isLoading,
    this.backgroundColor,
    this.textColor,
    required this.text,
  });

  final void Function()? onTap;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final String text;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isLoading ? null : widget.onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: widget.backgroundColor ?? Colors.redAccent,
        ),
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: widget.isLoading
            ? SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  color: widget.textColor ?? Colors.white,
                  backgroundColor: Colors.transparent,
                ),
              )
            : Text(
                widget.text,
                style: TextStyle(
                  fontSize: 20,
                  color: widget.textColor ?? Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
