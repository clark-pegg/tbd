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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCc93iwaR8wMPVXdTTcPL7k8aBBGP2xyTQ',
    appId: '1:617925254475:web:485242491e05c2cd835cce',
    messagingSenderId: '617925254475',
    projectId: 'studentnote-192b6',
    authDomain: 'studentnote-192b6.firebaseapp.com',
    storageBucket: 'studentnote-192b6.appspot.com',
    measurementId: 'G-H42PYR1SML',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCYGw4zuZQ0YFOKXiYVoa_rijh2sZOyXFY',
    appId: '1:617925254475:android:beacf7e1a9e7c130835cce',
    messagingSenderId: '617925254475',
    projectId: 'studentnote-192b6',
    storageBucket: 'studentnote-192b6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCJyowDBHtGS3geB-bincy-b4e4yi3U8v8',
    appId: '1:617925254475:ios:276535225e4c1bdf835cce',
    messagingSenderId: '617925254475',
    projectId: 'studentnote-192b6',
    storageBucket: 'studentnote-192b6.appspot.com',
    iosClientId: '617925254475-j59ajm9v3ddcli3i5gfhpdt8botudplm.apps.googleusercontent.com',
    iosBundleId: 'com.example.tbd',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCJyowDBHtGS3geB-bincy-b4e4yi3U8v8',
    appId: '1:617925254475:ios:276535225e4c1bdf835cce',
    messagingSenderId: '617925254475',
    projectId: 'studentnote-192b6',
    storageBucket: 'studentnote-192b6.appspot.com',
    iosClientId: '617925254475-j59ajm9v3ddcli3i5gfhpdt8botudplm.apps.googleusercontent.com',
    iosBundleId: 'com.example.tbd',
  );
}