import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/modules/appointment/controllers/appointment_controller.dart';
import 'package:hallo_doctor_client/app/modules/chat/views/list_users_view.dart';
import 'package:hallo_doctor_client/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hallo_doctor_client/app/service/notification_service.dart';
import 'package:hallo_doctor_client/modules/auth/data/user.dart';
import 'package:hallo_doctor_client/modules/auth/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:hallo_doctor_client/app/modules/profile/views/pages/change_password.dart';
import 'package:hallo_doctor_client/app/modules/profile/views/pages/edit_image_page.dart';
import 'package:hallo_doctor_client/app/modules/profile/views/pages/kuisioner_view.dart';
import 'package:hallo_doctor_client/app/service/auth_service.dart';
import 'package:hallo_doctor_client/app/service/user_service.dart';

import '../../../../modules/auth/models/user.dart';
import '../views/pages/update_email_page.dart';

class ProfileController extends GetxController {
  //TODO: Implement ProfileController

  final count = 0.obs;
  AuthService authService = Get.find();
  UserService userService = Get.find();
  User user = authProvider.user!;
  var username = ''.obs;
  var profilePic = ''.obs;
  var appVersion = ''.obs;
  var email = ''.obs;
  var newPassword = ''.obs;
  var valuekejadian = 'Seminggu ini'.obs;
  var valuedampak = ''.obs;
  var valuejenisKelamin = ''.obs;
  var valueumur = ''.obs;
  var valueKronologi = ''.obs;
  var valuePerubahan = ''.obs;

  String? selectedGender;
  final List<String> gender = ["Pria", "Wanita"];

  String? select;

  // final selected = "some book type".obs;

  // var selected = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = packageInfo.version;
  }

  @override
  void dispose() {
    save();
    super.dispose();
  }

  @override
  void onReady() {
    super.onReady();
    var user = userService.currentUser;
    print('user : ' + user.toString());
    profilePic.value = userService.getProfilePicture()!;
    username.value = user!.displayName!;
    email.value = user.email!;
    // coba.value = user.coba!;
  }

  @override
  void onClose() {}

  Future<void> save() async {
    if (user == authProvider.user) return;
    await 1.delay();
    authProvider.rxUser(user);
    await UserRepository.saveMyInfo();
  }

  void logout() async {
    Get.defaultDialog(
      title: 'Logout'.tr,
      middleText: 'Are you sure you want to Logout'.tr,
      radius: 15,
      textCancel: 'Cancel'.tr,
      textConfirm: 'Logout'.tr,
      onConfirm: () {},
    );
  }

  toEditImage() {
    Get.to(() => EditImagePage());
  }

  toUpdateEmail() {
    Get.to(() => UpdateEmailPage());
  }

  toChangePassword() {
    Get.to(() => ChangePasswordPage());
  }

  void updateEmail(String email) async {
    // if (!(await checkGoogleLogin())) return;
    try {
      EasyLoading.show();
      UserService().updateEmail(email).then((value) {
        Get.back();
        this.email.value = email;
        update();
      }).catchError((err) {
        Fluttertoast.showToast(msg: err.toString());
      }).whenComplete(() {
        EasyLoading.dismiss();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void updateProfilePic(File filePath) {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    userService.updateProfilePic(filePath).then((updatedUrl) {
      profilePic.value = updatedUrl;
      Get.back();
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: error.toString(), toastLength: Toast.LENGTH_LONG);
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  // void kejadian(String kejadian) async {
  //   // if (!(await checkGoogleLogin())) return;
  //   try {
  //     EasyLoading.show();
  //     UserService().kejadian(kejadian).then((value) {
  //       Get.back();
  //       this.valuekejadian.value = kejadian;
  //       update();
  //     }).catchError((err) {
  //       Fluttertoast.showToast(msg: err.toString());
  //     }).whenComplete(() {
  //       EasyLoading.dismiss();
  //     });
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: e.toString());
  //   }
  // }

  void kejadian(String kejadian) async {
    // selected.value = value;
    try {
      EasyLoading.show();
      UserService().kejadian(kejadian).then((value) {
        // Get.back();
        this.valuekejadian.value = kejadian;
        update();
      }).catchError((err) {
        Fluttertoast.showToast(msg: err.toString());
      }).whenComplete(() {
        EasyLoading.dismiss();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void dampak(String dampak) async {
    // if (!(await checkGoogleLogin())) return;
    try {
      EasyLoading.show();
      UserService().dampak(dampak).then((value) {
        // Get.back();
        this.valuedampak.value = dampak;
        update();
      }).catchError((err) {
        Fluttertoast.showToast(msg: err.toString());
      }).whenComplete(() {
        EasyLoading.dismiss();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void goHome() {
    Get.offAllNamed('dashboard');
    Get.find<DashboardController>().selectedIndex = 2;
    Get.find<AppointmentController>().getListAppointment();
  }

  void Kronologi(String Kronologi) async {
    // if (!(await checkGoogleLogin())) return;
    try {
      EasyLoading.show();
      UserService().Kronologi(Kronologi).then((value) {
        // Get.back();
        this.valueKronologi.value = Kronologi;
        update();
      }).catchError((err) {
        Fluttertoast.showToast(msg: err.toString());
      }).whenComplete(() {
        EasyLoading.dismiss();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void Perubahan(String Perubahan) async {
    // if (!(await checkGoogleLogin())) return;
    try {
      EasyLoading.show();
      UserService().Perubahan(Perubahan).then((value) {
        // Get.back();
        this.valuePerubahan.value = Perubahan;
        update();
      }).catchError((err) {
        Fluttertoast.showToast(msg: err.toString());
      }).whenComplete(() {
        EasyLoading.dismiss();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  // void jenisKelamin(String jenisKelamin) async {
  //   // if (!(await checkGoogleLogin())) return;
  //   try {
  //     EasyLoading.show();
  //     UserService().jenisKelamin(jenisKelamin).then((value) {
  //       Get.back();
  //       this.valuejenisKelamin.value = jenisKelamin;
  //       update();
  //     }).catchError((err) {
  //       Fluttertoast.showToast(msg: err.toString());
  //     }).whenComplete(() {
  //       EasyLoading.dismiss();
  //     });
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: e.toString());
  //   }
  // }

  void jenisKelamin(String jenisKelamin) async {
    // print(jenisKelamin);

    // update();
    try {
      select = jenisKelamin;
      EasyLoading.show();
      UserService().jenisKelamin(jenisKelamin).then((value) {
        // Get.back();
        this.valuejenisKelamin.value = jenisKelamin;
        update();
      }).catchError((err) {
        Fluttertoast.showToast(msg: err.toString());
      }).whenComplete(() {
        EasyLoading.dismiss();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void umur(String umur) async {
    // if (!(await checkGoogleLogin())) return;
    try {
      EasyLoading.show();
      UserService().umur(umur).then((value) {
        // Get.back();
        this.valueumur.value = umur;
        update();
      }).catchError((err) {
        Fluttertoast.showToast(msg: err.toString());
      }).whenComplete(() {
        EasyLoading.dismiss();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void changePassword(String currentPassword, String newPassword) async {
    // if (!(await checkGoogleLogin())) return;

    try {
      await UserService().changePassword(currentPassword, newPassword);
      currentPassword = '';
      newPassword = '';
      Get.back();
      Fluttertoast.showToast(msg: 'Successfully change password'.tr);
    } catch (err) {
      Fluttertoast.showToast(msg: err.toString());
    }
    EasyLoading.dismiss();
  }

//user for testing something
  Future testButton() async {
    try {
      // print('my uid : ' + UserService().currentUser!.uid);
      // Get.to(() => ListUser());
      NotificationService notificationService = Get.find<NotificationService>();
      await Future.delayed(Duration(seconds: 10));
      // notificationService.showCallNotification('amsyari', 'roomname', 'token');
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // Future<bool> checkGoogleLogin() async {
  //   bool loginGoogle = await AuthService().checkIfGoogleLogin();
  //   print('is login google : ' + loginGoogle.toString());
  //   if (loginGoogle) {
  //     Fluttertoast.showToast(
  //         msg: 'your login method, it is not possible to change this data');
  //     return false;
  //   }
  //   return loginGoogle;
  // }
}
