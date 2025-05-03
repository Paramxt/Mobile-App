import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_summer/constants/color.dart';
import 'package:flutter_summer/screen/screenhome.dart';
import 'package:flutter_summer/screen/screenstatistic.dart';
import 'package:flutter_summer/screen/screenprofile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'web_socket_notifier.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

@RoutePage()
class HomeDevicePage extends StatefulWidget {
  const HomeDevicePage({super.key});

  @override
  State<HomeDevicePage> createState() => _HomeDevicePageState();
}

class _HomeDevicePageState extends State<HomeDevicePage> {
  int myIndex = 0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAndSaveAllSensorData();
  }

  Future<void> _fetchAndSaveAllSensorData() async {
    String baseUrl;
    if (kIsWeb) {
      // Running on the web (Chrome, Safari, etc.)
      baseUrl = dotenv.env['BASE_URL_WEB'] ?? '';
    } else if (Platform.isAndroid) {
      // Running on an Android device
      baseUrl = dotenv.env['BASE_URL_ANDROID'] ?? '';
    } else {
      // Running on other platforms
      baseUrl = dotenv.env['BASE_URL_OTHER'] ?? '';
    }

    if (baseUrl.isEmpty) {
      setState(() {
        _errorMessage = 'Base URL is not configured properly.';
      });
      return;
    }

    final url = Uri.parse('$baseUrl/api/sensor-data');
    try {
      final response = await http.get(url);

      print(
          'Response body: ${response.body}'); // ตรวจสอบข้อมูลที่ได้รับจากเซิร์ฟเวอร์

      if (response.statusCode == 200) {
        List<dynamic> sensorData = jsonDecode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();

        // วนลูปเพื่อบันทึกเฉพาะค่า value ของแต่ละเซ็นเซอร์ลงใน SharedPreferences
        for (var sensor in sensorData) {
          String sensorId = sensor['sensor'];
          int sensorValue = int.parse(
              sensor['value']); // แปลงเป็น int ถ้าค่าใน database เป็น String

          await prefs.setInt('sensor_$sensorId',
              sensorValue); // บันทึกค่าเป็น int ใน SharedPreferences
        }

        // ข้อมูลถูกบันทึกแล้ว สามารถอัปเดต UI หรือทำงานอื่น ๆ ได้ที่นี่
      } else {
        throw Exception('Failed to load sensor data');
      }
    } catch (error) {
      print('Error fetching sensor data: $error');
    }
  }

  @override
  void dispose() {
    // ถ้าคุณต้องการให้ WebSocket ทำงานอยู่เบื้องหลังตลอดเวลา ไม่ควรปิดการเชื่อมต่อที่นี่
    Provider.of<WebSocketNotifier>(context, listen: false).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      const ScreenHome(),
      const ScreenStus(),
      const ScreenProfile(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: myIndex,
          children: widgetList,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: whiteColor,
        showUnselectedLabels: false,
        selectedItemColor: PrimaryColor,
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        currentIndex: myIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.assignment),
            label: AppLocalizations.of(context)!.info,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.profile,
          ),
        ],
      ),
    );
  }
}
