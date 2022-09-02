import 'package:flutter/material.dart';

import 'package:timeago/timeago.dart' as time_ago;

import '../../../../../imports.dart';
import '../../../data/posts.dart';
import '../../../models/post.dart';

class UserTile extends StatelessWidget {
  final User user;
  final Post post;

  const UserTile(
    this.user,
    this.post, {
    super.key,
  });

  bool get isAdmin => authProvider.user!.isAdmin;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: post.isMine ? null : () => AuthRoutes.toProfile(post.authorID),
        child: Row(
          children: <Widget>[
            AvatarWidget(
              user.photoURL,
              radius: 45,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${user.username} ${user.isAdmin ? "(${t.Admin})" : ""}',
                    maxLines: 1,
                  ),
                  Text(
                    time_ago.format(
                      post.createdAt,
                      locale: 'en_short',
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<int>(
              itemBuilder: (_) => [
                if (post.isMine || isAdmin)
                  PopupMenuItem(value: 0, child: Text(t.Edit)),
                if (!post.isMine) PopupMenuItem(value: 1, child: Text(t.Report))
              ],
              onSelected: (v) {
                if (v == 0) {
                  FeedRoutes.toPostEditor(post);
                } else if (v == 1) {
                  FeedRoutes.toReport(post);
                } else if (v == 2) {
                  PostsRepository.unReportPost(post.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
