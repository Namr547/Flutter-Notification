// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_notifications/notifications_services.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);

    // notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      print('device token');
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          /// Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/back.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () {
                notificationServices.getDeviceToken().then((value) async {
                  var data = {
                    // yahan pr "to" yani jis device pr bhejni hain to usi device ki toke value yahan "value" ki jagha denghy
                    'to': value.toString(),
                    'priority': 'high',
                    'notification': {
                      'title': 'Namar',
                      'body': 'Subscribe to my channel'
                    },
                    //for redirecting to specific screen
                    // 'data':{
                    //   'type': 'msg',
                    //   'id': 'Namar12345'
                    // }
                  };
                  await http.post(
                      Uri.parse('https://fcm.googleapis.com/fcm/send'),
                      body: jsonEncode(data),
                      headers: {
                        'Content-Type': 'application/json; charset=UTF-8',
                        //project setting>cloud messaging>cloud messaging API(Legacy)>Enable it and copy this token
                        'Authorization':
                        'key=AAAA6YUh-Bc:APA91bFr_jG-JSik-WGk4WGw_7TqSLTjZrzokVvP_Grik9kOVvgmwvpjY85CchXgjvN-G0Xq0f0sbirCcomyvUqGMYEtpev1XcFIDBtFttoKBoyTCS1jF9la-2UrqCTEiiDDBECukloE'
                      });
                });
              },
              child: Text('Send Notifications', style: TextStyle(color: Colors.black)),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
