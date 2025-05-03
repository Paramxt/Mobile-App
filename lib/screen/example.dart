import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

@RoutePage()
class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  List<Map<String, dynamic>> historyList = [];

  // ตัวแปรเก็บค่าก่อนหน้าของเซ็นเซอร์ทั้ง 4 ตัว
  int previousSensorValue1 = 0;
  int previousSensorValue2 = 0;
  int previousSensorValue3 = 0;
  int previousSensorValue4 = 0;

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String body) async {
    var androidDetails = const AndroidNotificationDetails(
      'channel_id', // channelId
      'Channel Name', // channelName
      importance: Importance.max,
      priority: Priority.high,
    );
    var notificationDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails);
  }

  final channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.43.146:8080'), //IP คอม Server
  );

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Notification'),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: channel.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                String receivedData = snapshot.data.toString();

                if (receivedData.startsWith("{") &&
                    receivedData.endsWith("}")) {
                  try {
                    var data = jsonDecode(receivedData);
                    int sensor = int.tryParse(data['sensor'] ?? '0') ?? 0;
                    int value = int.tryParse(data['value'] ?? '0') ?? 0;

                    // ตรวจสอบเซ็นเซอร์แต่ละตัว
                    if (sensor == 1 &&
                        previousSensorValue1 == 0 &&
                        value == 1) {
                      showNotification('Sensor 1 Alert',
                          'Sensor 1 value changed from 0 to 1');
                    } else if (sensor == 2 &&
                        previousSensorValue2 == 0 &&
                        value == 1) {
                      showNotification('Sensor 2 Alert',
                          'Sensor 2 value changed from 0 to 1');
                    } else if (sensor == 3 &&
                        previousSensorValue3 == 0 &&
                        value == 1) {
                      showNotification('Sensor 3 Alert',
                          'Sensor 3 value changed from 0 to 1');
                    } else if (sensor == 4 &&
                        previousSensorValue4 == 0 &&
                        value == 1) {
                      showNotification('Sensor 4 Alert',
                          'Sensor 4 value changed from 0 to 1');
                    }

                    // อัปเดตค่าก่อนหน้าของเซ็นเซอร์แต่ละตัว
                    if (sensor == 1) previousSensorValue1 = value;
                    if (sensor == 2) previousSensorValue2 = value;
                    if (sensor == 3) previousSensorValue3 = value;
                    if (sensor == 4) previousSensorValue4 = value;

                    return Center(
                        child: Text('Sensor: $sensor, Value: $value'));
                  } catch (e) {
                    return Center(child: Text('Error parsing JSON data'));
                  }
                } else {
                  return Center(
                      child: Text('Received non-JSON data: $receivedData'));
                }
              } else {
                return Center(child: Text('Waiting for data...'));
              }
            },
          ),
        ],
      ),
    );
  }
}
