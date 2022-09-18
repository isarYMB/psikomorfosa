import 'package:flutter/material.dart';

import '../styles.dart';
import 'text.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? backgroundColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? isLoading;
  final VoidCallback? onTap;
  final EdgeInsets contentPadding;
  final double width;
  final double textSize;
  final double borderRadius;
  const AppButton(
    this.text, {
    super.key,
    this.color,
    this.backgroundColor,
    this.onTap,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
    this.width = 300,
    this.textSize = 18,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: contentPadding,
      height: 60,
      width: isLoading! ? 150 : width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              colors: [
                Color.fromRGBO(150, 149, 238, 1),
                Color.fromRGBO(251, 199, 212, 1),
              ]
          )
      ),
      child: ElevatedButton(
        onPressed:
            onTap == null ? null : () => isLoading! ? null : onTap?.call(),
        style: ButtonStyle(
          // foregroundColor:
          // MaterialStateProperty.all<Color>(Colors.transparent),
          backgroundColor:
          MaterialStateProperty.all<Color> (Color.fromRGBO(255, 255, 255, 0),),
          shadowColor:
          MaterialStateProperty.all(Colors.transparent),
          shape:
          MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading!)
              SizedBox.fromSize(
                size: Size.fromRadius(12),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    color ?? theme.scaffoldBackgroundColor,
                  ),
                ),
              )
            else ...[
              if (prefixIcon != null) ...[prefixIcon!, SizedBox(width: 10)],
              Flexible(
                child: AppText(
                  text,
                  size: textSize,
                  color: color ?? theme.scaffoldBackgroundColor,
                  maxLines: 1,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (suffixIcon != null) suffixIcon!,
            ],
          ],
        ),
      ),
    );
  }
}
