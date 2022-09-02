import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:hallo_doctor_client/app/modules/dashboard/views/dashboard_view.dart';
// import 'package:hallo_doctor_client/app/routes/app_pages.dart';
import 'package:hallo_doctor_client/app/service/auth_service.dart';
import 'package:hallo_doctor_client/modules/auth/pages/register/index.dart';

import '../../imports.dart';
import '../notifications/data/notifications.dart';
import 'data/user.dart';

AuthProvider get authProvider => Get.find();

class AuthProvider {
  AuthProvider._();
  AuthService authService = Get.find();

  static final auth = FirebaseAuth.instance;
  String get uid => auth.currentUser?.uid ?? '';

  final rxUser = Rxn<User>();
  User? get user => rxUser.value;
  final isLoggedIn = false.obs;

  static Future<AuthProvider> init() async {
    final c = AuthProvider._();
    Get.put(c);
    await c._fetchUser();
    if (c.uid.isNotEmpty) {
      if (c.user == null) {
        0.5.delay().then((_) => AuthRoutes.toPhoneLogin());
      } else {
        NotificationRepo.registerNotification();
      }
    }
    return c;
  }

  Future<void> _fetchUser() async {
    if (uid.isEmpty) return;
    final user = await UserRepository.fetchUser();
    if (user != null) {
      isLoggedIn(true);
      updateUser(user);
      UserRepository.updateActiveAt(true);
    }
  }

  Future<void> updateUser(User user) async {
    if (user.isBanned) {
      await logout();
    } else {
      rxUser(user);
    }
  }

  Future<void> login() async {
    try {
      if (uid.isEmpty) return;
      await _fetchUser();
      Get.until((r) => r.isFirst);
      if (user == null) {
        Get.offAll(() => RegisterPage());
      } else {
        NotificationRepo.registerNotification();
        // AppPages.DASHBOARD;
        Get.offAll(() => DashboardView());
        // Get.offAllNamed('/dashboard');
        // authService
        //     .loginGoogle()
        //     .then((value) => Get.offAllNamed('/dashboard'));
      }
    } catch (e) {
      logError(e);
    }
  }

  Future<void> logout() async {
    try {
      if (Get.context != null) {
        Get.until((r) => r.isFirst);
      }
      isLoggedIn(false);
      rxUser.value = null;
      await UserRepository.updateActiveAt(false);
      await NotificationRepo.clearToken();
      await auth.signOut();
    } catch (e, s) {
      logError('', e, s);
    }
  }
}
