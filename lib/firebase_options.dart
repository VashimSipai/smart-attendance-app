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
      return const FirebaseOptions(
        apiKey: 'AIzaSyAgnCgrI56xZg-LcWIYCOsms8qPOUOJE6o',
        appId: '1:251643152302:web:30e5ed61cb14974325ea3f',
        messagingSenderId: '251643152302',
        projectId: 'smart-attendance-app-d6bef',
        authDomain: 'smart-attendance-app-d6bef.firebaseapp.com',
        storageBucket: 'smart-attendance-app-d6bef.firebasestorage.app',
        measurementId: 'G-MVYY46RHSP',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: 'android-api-key',
          appId: 'android-app-id',
          messagingSenderId: 'sender-id',
          projectId: 'smart-attendance-mock',
          storageBucket: 'smart-attendance-mock.firebasestorage.app',
        );
      case TargetPlatform.iOS:
        return const FirebaseOptions(
          apiKey: 'ios-api-key',
          appId: 'ios-app-id',
          messagingSenderId: 'sender-id',
          projectId: 'smart-attendance-mock',
          storageBucket: 'smart-attendance-mock.firebasestorage.app',
          iosBundleId: 'com.smartattendance.app',
        );
      case TargetPlatform.macOS:
        return const FirebaseOptions(
          apiKey: 'macos-api-key',
          appId: 'macos-app-id',
          messagingSenderId: 'sender-id',
          projectId: 'smart-attendance-mock',
          storageBucket: 'smart-attendance-mock.firebasestorage.app',
          iosBundleId: 'com.smartattendance.app',
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
}
