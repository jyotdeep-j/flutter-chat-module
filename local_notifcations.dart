import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



class NotificationHandler {
  final _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> firebaseMessagingBackgroundHandler(
      var remoteMessage) async {
    print('message from background handler: ${remoteMessage}');
  }

  // Future<void> han

  Future initNotifications() async {
    int id = Random().nextInt(1000);

    await _firebaseMessaging.requestPermission();

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    forgroundFirebaseCall();
    terminatedFirebaseCall();
    terminatedOverrideFirebaseCall();
  }

  //when application is on forground
  forgroundFirebaseCall() {
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      if (remoteMessage != null) {
        handleMessage(remoteMessage);
      }
    });
  }

  //when application is terminated
  terminatedFirebaseCall() {
    FirebaseMessaging.instance.getInitialMessage().then((remoteMessage) {
      if (remoteMessage != null) {
        tabOnNotifications(remoteMessage);
      }
    });
  }

  //when application is not terminated but other application overrides
  terminatedOverrideFirebaseCall() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      if (remoteMessage != null) {
        tabOnNotifications(remoteMessage);
      }
    });
  }

  void handleMessage(RemoteMessage? remoteMessage) {
    if (remoteMessage != null && remoteMessage?.data != null) {
      showLocalNotifications(remoteMessage);
    }
  }

  showLocalNotifications(RemoteMessage remoteMessage) async {
    int id = Random().nextInt(10000);
    FlutterLocalNotificationsPlugin localNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: DarwinInitializationSettings(),
            macOS: null);

    await localNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse:
            firebaseMessagingBackgroundHandler,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
      localNotificationsPlugin.cancel(id);
      if (details != null) {
        tabOnNotifications(remoteMessage);
      }
    });

    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
          'default_channel', // id
          'High Importance Notifications', // title
          description: 'This channel is used for important notifications.',
          // description
          importance: Importance.max,
          playSound: true);
      await localNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
          "default_channel", 'Testing Name',
          importance: Importance.max, priority: Priority.high);
      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );
      await localNotificationsPlugin.show(0, remoteMessage.notification?.title,
          remoteMessage.notification?.body, platformChannelSpecifics,
          payload: jsonEncode(remoteMessage.data));
    }
  }

  //handled redirection,perform routing here
  tabOnNotifications(RemoteMessage? remoteMessage) {


  }
}
