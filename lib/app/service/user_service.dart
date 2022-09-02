import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hallo_doctor_client/app/models/user_model.dart';
import 'package:hallo_doctor_client/app/service/firebase_service.dart';
import 'package:path/path.dart';

import 'auth_service.dart';

class UserService {
  static User? user;
  set currentUser(User? user) => UserService.user = user;
  User? get currentUser {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      return auth.currentUser;
    } else {
      print('User Null');
      return null;
    }
  }

  Future<String> getUsername() async {
    return currentUser!.displayName!;
  }

  String? getProfilePicture() {
    String? profilePic;
    try {
      profilePic = currentUser?.photoURL ?? "";
    } catch (e) {
      profilePic = '';
    }
    return profilePic;
  }

  //Upload image file to firebase storage & update current user profile pic
  Future<String> updateProfilePic(File filePath) async {
    try {
      String fileName = basename(filePath.path);
      var ref = FirebaseStorage.instance.ref().child('uploads/$fileName');
      final result = await ref.putFile(File(filePath.path));
      final fileUrl = await result.ref.getDownloadURL();
      await updateProfileUrl(fileUrl);
      return fileUrl;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  //Update current user profile url
  Future updateProfileUrl(String url) async {
    try {
      currentUser!.updatePhotoURL(url);
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({'photoUrl': url});
    } catch (err) {
      Future.error(err.toString());
    }
  }

  Future updateEmail(String email) async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({'email': email});
    } on FirebaseAuthException catch (err) {
      return Future.error(err.message!);
    }
  }

  Future changePassword(String currentPassword, String newPassword) async {
    try {
      bool validatePassword =
          await AuthService().verifyPassword(currentPassword);
      if (validatePassword) {
        currentUser!.updatePassword(newPassword);
      }
    } catch (err) {
      return Future.error(err.toString());
    }
  }

  String getUserId() {
    return currentUser!.uid;
  }

  Future<UserModel?> getUsernameById(String userId) async {
    try {
      var user = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      user.data();
      if (!user.exists) return null;
      UserModel userModel = UserModel.fromJson(user.data()!);
      return userModel;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future updateUserToken(String? token) async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({'token': token});
    } catch (e) {
      Future.error(e.toString());
    }
  }

  Future<bool> checkIfUserExist() async {
    var userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();
    if (userSnapshot.exists) return true;
    return false;
  }

  //Kuisioner
  Future kejadian(String kejadian) async {
    try {
      // currentUser!.updateEmail(coba);
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({'kejadian': kejadian});
    } on FirebaseAuthException catch (err) {
      return Future.error(err.message!);
    }
  }

  Future dampak(String dampak) async {
    try {
      // currentUser!.updateEmail(coba);
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({'dampak': dampak});
    } on FirebaseAuthException catch (err) {
      return Future.error(err.message!);
    }
  }

  Future Kronologi(String Kronologi) async {
    try {
      // currentUser!.updateEmail(coba);
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({'Kronologi': Kronologi});
    } on FirebaseAuthException catch (err) {
      return Future.error(err.message!);
    }
  }

  Future Perubahan(String Perubahan) async {
    try {
      // currentUser!.updateEmail(coba);
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({'Perubahan': Perubahan});
    } on FirebaseAuthException catch (err) {
      return Future.error(err.message!);
    }
  }

  Future jenisKelamin(String jenisKelamin) async {
    try {
      // currentUser!.updateEmail(coba);
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({'jenisKelamin': jenisKelamin});
    } on FirebaseAuthException catch (err) {
      return Future.error(err.message!);
    }
  }

  Future umur(String umur) async {
    try {
      // currentUser!.updateEmail(coba);
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({'umur': umur});
    } on FirebaseAuthException catch (err) {
      return Future.error(err.message!);
    }
  }
}
