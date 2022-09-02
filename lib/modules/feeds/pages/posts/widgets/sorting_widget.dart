import 'package:flutter/material.dart';

import '../../../models/post_query.dart';

class PostsSortingWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final PostQuery postQuery;
  final void Function(PostQuery value)? onChange;

  const PostsSortingWidget(
    this.postQuery, {
    super.key,
    this.onChange,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          for (final s in PostQuery.values)
            GestureDetector(
              onTap: () => onChange?.call(s),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Chip(
                  backgroundColor: s == postQuery ? Colors.grey : null,
                  label: Text(s.text),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 40);
}
