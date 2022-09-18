import 'package:flutter/material.dart';

import '../../../../components/form_field.dart';
import '../../../../imports.dart';
import '../../data/groups.dart';
import '../../models/group.dart';

class GroupEditor extends StatefulWidget {
  final Group? toEditGroup;

  const GroupEditor({
    super.key,
    this.toEditGroup,
  });
  @override
  _GroupEditorState createState() => _GroupEditorState();
}

class _GroupEditorState extends State<GroupEditor> {
  final nameController = TextEditingController();

  final imgUploader = AppUploader();
  Group? get group => widget.toEditGroup;

  bool get isToEdit => group != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        titleStr: isToEdit ? t.EditGroup : t.CreateGroup,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Obx(
              () => AvatarWidget(
                imgUploader.path(group?.photoURL),
                onTap: () => imgUploader.pick(context),
                radius: 120,
              ),
            ),
            SizedBox(height: 20),
            AppTextFormField(
              label: t.GroupName,
              controller: nameController,
              maxLength: 20,
            ),
            SizedBox(height: 20),
            SizedBox(height: 40),
            Obx(
              () => AppButton(
                t.Save,
                isLoading: imgUploader.isUploading,
                onTap: onSave,
                width: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    nameController.text = group?.name ?? '';
    super.initState();
  }

  Future<void> onSave() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      BotToast.showText(text: t.AddGroupName);
      return;
    }

    var photoURL = group?.photoURL ?? '';
    if (imgUploader.isPicked) {
      await imgUploader.upload(
        StorageHelper.groupRef(name),
        onSuccess: (v) => photoURL = v.path,
        onFailed: (e) => BotToast.showText(text: e),
      );
    }

    Group ngroup;
    BotToast.showLoading();
    if (isToEdit) {
      ngroup = group!.copyWith(
        name: name,
        photoURL: photoURL,
      );
      await GroupsRepository.editGroup(ngroup);
    } else {
      ngroup = Group.create(
        name: name,
        photoURL: photoURL,
      );
      await GroupsRepository.createGroup(ngroup);
    }
    BotToast.closeAllLoading();
    Get.until((r) => r.isFirst);
    ChatRoutes.toGroupChat(ngroup.id);
  }
}
