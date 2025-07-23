// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAZZnX8l__D43CyJu0p_wJvyptlUWx8j1U',
    appId: '1:611415675152:web:b29793d7d66f16018cd595',
    messagingSenderId: '611415675152',
    projectId: 'leafprint-4e435',
    authDomain: 'leafprint-4e435.firebaseapp.com',
    storageBucket: 'leafprint-4e435.appspot.com',
    measurementId: 'G-92JM4SZD6E',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB0eG2w7g1VTTiz6pQbOMmQmmat0c--OwU',
    appId: '1:611415675152:android:fbededbde5561a9d8cd595',
    messagingSenderId: '611415675152',
    projectId: 'leafprint-4e435',
    storageBucket: 'leafprint-4e435.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAC7GD38_Fw7mVNT__ZySiVAh3yUuBQQzY',
    appId: '1:611415675152:ios:89cfdbb6549b4b278cd595',
    messagingSenderId: '611415675152',
    projectId: 'leafprint-4e435',
    storageBucket: 'leafprint-4e435.appspot.com',
    iosBundleId: 'com.example.leafprint',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAC7GD38_Fw7mVNT__ZySiVAh3yUuBQQzY',
    appId: '1:611415675152:ios:89cfdbb6549b4b278cd595',
    messagingSenderId: '611415675152',
    projectId: 'leafprint-4e435',
    storageBucket: 'leafprint-4e435.appspot.com',
    iosBundleId: 'com.example.leafprint',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAZZnX8l__D43CyJu0p_wJvyptlUWx8j1U',
    appId: '1:611415675152:web:7a3c01ed3c81337c8cd595',
    messagingSenderId: '611415675152',
    projectId: 'leafprint-4e435',
    authDomain: 'leafprint-4e435.firebaseapp.com',
    storageBucket: 'leafprint-4e435.appspot.com',
    measurementId: 'G-FPMMQ57LHN',
  );
}
