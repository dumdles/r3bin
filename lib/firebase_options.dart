// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBaGh-XUtSMRr-KMkJuSuOl9F3jAMeA1ZA',
    appId: '1:783197773625:web:edd68cbc1162ab501152e8',
    messagingSenderId: '783197773625',
    projectId: 'r3bin-44186',
    authDomain: 'r3bin-44186.firebaseapp.com',
    storageBucket: 'r3bin-44186.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCwxnFwzBxkMe2NTUpFQ-79kO8t7lkr2yE',
    appId: '1:783197773625:android:2e5d5db9790a38bc1152e8',
    messagingSenderId: '783197773625',
    projectId: 'r3bin-44186',
    storageBucket: 'r3bin-44186.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCyeBQi8UWAvGxidG3tV70tgzqFI9T_vxQ',
    appId: '1:783197773625:ios:c81e6f14165c77f51152e8',
    messagingSenderId: '783197773625',
    projectId: 'r3bin-44186',
    storageBucket: 'r3bin-44186.firebasestorage.app',
    iosBundleId: 'com.example.r3bin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCyeBQi8UWAvGxidG3tV70tgzqFI9T_vxQ',
    appId: '1:783197773625:ios:c81e6f14165c77f51152e8',
    messagingSenderId: '783197773625',
    projectId: 'r3bin-44186',
    storageBucket: 'r3bin-44186.firebasestorage.app',
    iosBundleId: 'com.example.r3bin',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBaGh-XUtSMRr-KMkJuSuOl9F3jAMeA1ZA',
    appId: '1:783197773625:web:555b40c2b32be44d1152e8',
    messagingSenderId: '783197773625',
    projectId: 'r3bin-44186',
    authDomain: 'r3bin-44186.firebaseapp.com',
    storageBucket: 'r3bin-44186.firebasestorage.app',
  );
}
