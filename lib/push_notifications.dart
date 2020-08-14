import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;
  String _token = "bla";

  Future<String> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure();

      _initialized = true;

      _token = "something";
      // For testing purposes print the Firebase Messaging token
      _token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $_token");
    }
    return _token;
  }
}
