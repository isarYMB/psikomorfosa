import 'package:flutter/material.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final String? titleStr;
  final bool centerTitle;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const Appbar({
    super.key,
    this.title,
    this.titleStr,
    this.actions,
    this.centerTitle = true,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: Color.fromRGBO(163, 144, 201, 1),
      elevation: 0.0,
      leading: leading,
      centerTitle: centerTitle,
      title: title ??
          Text(
            titleStr ?? '',
            style: const TextStyle(fontSize: 22,color: Color.fromRGBO(163, 144, 201, 1),fontFamily: "Nunito",fontWeight: FontWeight.bold),
          ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
