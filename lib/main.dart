import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:riderapp/pages/homelayout.dart';
import 'package:riderapp/pages/login.dart';
import 'shared/cached_helper.dart';


final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future<void> setup() async {
  const androidInitializationSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosInitializationSetting = DarwinInitializationSettings();
  const initSettings = InitializationSettings(android: androidInitializationSetting, iOS: iosInitializationSetting);
  await _flutterLocalNotificationsPlugin.initialize(initSettings);
}

void showLocalNotification(String title, String body) {
  const androidNotificationDetail = AndroidNotificationDetails('0', 'general'
  );
  const iosNotificatonDetail = DarwinNotificationDetails();
  const notificationDetails = NotificationDetails(
    iOS: iosNotificatonDetail,
    android: androidNotificationDetail,
  );
  _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Cachehelper.init();

  await Firebase.initializeApp();
  setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String token = Cachehelper.getData(key: "token");
    print(token);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'canari rider',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home:token==null?Login():HomeLayout(Index: 0),
    );
  }
}

