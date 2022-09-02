// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD-v6NPZh2mNXAsEmRy0Ag0zT0p0jcKuTw',
    appId: '1:830619578040:android:b4d30288496a45d62e8e4d',
    messagingSenderId: '830619578040',
    projectId: 'psikomorfosa-10500',
    databaseURL: 'https://psikomorfosa-10500-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'psikomorfosa-10500.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDl3s1U21aHdwmlBweKbbA0TFtEpA9HA2U',
    appId: '1:830619578040:ios:70b90c11fdd48de52e8e4d',
    messagingSenderId: '830619578040',
    projectId: 'psikomorfosa-10500',
    databaseURL: 'https://psikomorfosa-10500-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'psikomorfosa-10500.appspot.com',
    androidClientId: '830619578040-2at9o0m88vgn8ds3ve3dn56mc7kg04k4.apps.googleusercontent.com',
    iosClientId: '830619578040-vn69ctstli7v93jja7t97ailk0emtmpp.apps.googleusercontent.com',
    iosBundleId: 'com.psikomorfosa.telekonseling',
  );
}