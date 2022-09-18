import 'package:flutter/material.dart';
import 'package:hallo_doctor_client/main.dart';

import '../../../../../imports.dart';
import '../../../models/group.dart';
import 'typing.dart';

class GroupAppBar extends StatelessWidget with PreferredSizeWidget {
  final Group group;

  const GroupAppBar(
    this.group, {
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    // RxBool anonim = false.obs; // our observable

    // // swap true/false & save it to observable
    // void toggle() => anonim.value = anonim.value ? false : true;

    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: Colors.white,
        foregroundColor: Color.fromRGBO(163, 144, 201, 1),
        title: ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: AvatarWidget(
            group.photoURL,
            radius: 40,
          ),
          title: Text(
            group.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          subtitle: group.isTyping
              ? TypingWidget()
              : Text(
                  '${group.members.length} ${t.Members}',
                  style: theme.textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                  ),
                ),
          // trailing: !group.isMember() ? null : Icon(Icons.info),
          onTap: !group.isMember() ? null : () => ChatRoutes.toGroupInfo(group),
        ),
        actions: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text('Anonim'),
            Obx(
              () => Switch(
                  onChanged: (val) => toggleGroup(), value: anonimGroup.value),
            )
          ])
        ]);
  }

  @override
  Size get preferredSize => Size(double.infinity, 50);
}
