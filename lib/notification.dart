import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationShow extends StatefulWidget {
  const NotificationShow({Key? key}) : super(key: key);

  @override
  State<NotificationShow> createState() => _NotificationShowState();
}

class _NotificationShowState extends State<NotificationShow> {
  String? mToken = "";
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
    getToken();
    initInfo();
    
  }
  initInfo() async {
    var androidInitialize = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? payload) async {
      try{
        if(payload != null && payload.isNotEmpty) {

        }else {

        }
      } catch (e) {
        print(e.toString());
      }
      return;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(".............onMessage.......");
      print("onMessage: ${message.notification?.title}/${message.notification?.body}");

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(), htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(), htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('dbfood', 'debfood', importance: Importance.high, styleInformation: bigTextStyleInformation, priority: Priority.high, playSound: true);
      NotificationDetails platfprmChannelSpecifics = NotificationDetails(android: androidNotificationDetails, iOS: const IOSNotificationDetails());
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title, message.notification?.body, platfprmChannelSpecifics, payload: message.data['body']);
    });


  }
  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mToken = token;
        print("My token is $mToken");
      });
      saveToken(token!);
    });
  }

void saveToken(String token) async {
    await FirebaseFirestore.instance.collection("UserToken").doc("User2").set({
      'token': token,
    });
}

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User Granted Permission");
    } else if(settings.authorizationStatus == AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User dislined or has not accepted permission");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
