import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBxOQil7o96FTK6rD2Trjeg2sJ-3h0rIlc',
    appId: '1:254238768355:web:a9d931abb0304f67d859d6',
    messagingSenderId: '254238768355',
    projectId: 'pfe---fhamni',
    authDomain: 'pfe---fhamni.firebaseapp.com',
    storageBucket: 'pfe---fhamni.firebasestorage.app',
    measurementId: 'G-LZ2FJKKFF4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBxOQil7o96FTK6rD2Trjeg2sJ-3h0rIlc',
    appId: '1:254238768355:android:a9d931abb0304f67d859d6',
    messagingSenderId: '254238768355',
    projectId: 'pfe---fhamni',
    databaseURL: 'https://pfe---fhamni.firebaseio.com',
    storageBucket: 'pfe---fhamni.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyArECVkcSFWMfTuclKvFxLdswyaZ3uofHs',
    appId: '1:254238768355:ios:13e45abd71b8e111d859d6',
    messagingSenderId: '254238768355',
    projectId: 'pfe---fhamni',
    storageBucket: 'pfe---fhamni.firebasestorage.app',
    iosClientId:
        '254238768355-efe9ja1uu3gaao0dv6k25l1vr61vg47q.apps.googleusercontent.com',
    iosBundleId: 'com.example.pfeS6',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyArECVkcSFWMfTuclKvFxLdswyaZ3uofHs',
    appId: '1:254238768355:ios:13e45abd71b8e111d859d6',
    messagingSenderId: '254238768355',
    projectId: 'pfe---fhamni',
    storageBucket: 'pfe---fhamni.firebasestorage.app',
    iosClientId:
        '254238768355-efe9ja1uu3gaao0dv6k25l1vr61vg47q.apps.googleusercontent.com',
    iosBundleId: 'com.example.pfeS6',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBxOQil7o96FTK6rD2Trjeg2sJ-3h0rIlc',
    appId: '1:254238768355:web:1730c6e778f06ee9d859d6',
    messagingSenderId: '254238768355',
    projectId: 'pfe---fhamni',
    authDomain: 'pfe---fhamni.firebaseapp.com',
    storageBucket: 'pfe---fhamni.firebasestorage.app',
    measurementId: 'G-YR4Y8ZBWDZ',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyBxOQil7o96FTK6rD2Trjeg2sJ-3h0rIlc',
    appId: '1:254238768355:web:a9d931abb0304f67d859d6',
    messagingSenderId: '254238768355',
    projectId: 'pfe---fhamni',
    authDomain: 'pfe---fhamni.firebaseapp.com',
    databaseURL: 'https://pfe---fhamni.firebaseio.com',
    storageBucket: 'pfe---fhamni.firebasestorage.app',
  );

  static FirebaseOptions get currentPlatform {
    return web; // Default to web - update this based on your platform
  }
}
