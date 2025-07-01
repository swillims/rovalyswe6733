import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    throw UnsupportedError('DefaultFirebaseOptions not configured for this platform.');
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAe5kTlgtp7KP7MuIQ6L8wqKj0jclPB9yM",
    authDomain: "swe6733wc.firebaseapp.com",
    projectId: "swe6733wc",
    storageBucket: "swe6733wc.firebasestorage.app",
    messagingSenderId: "292059682722",
    appId: "1:292059682722:web:b67ec047322f30955784fb",
    measurementId: "G-14V6B2ZW08",
  );
}