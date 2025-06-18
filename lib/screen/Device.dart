import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_summer/constants/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_summer/screen/notification.dart';

class sensorscreen extends StatefulWidget {
  const sensorscreen({super.key});

  @override
  State<sensorscreen> createState() => _sensorscreenState();
}

class _sensorscreenState extends State<sensorscreen> {
  int? sensor1Value;
  int? sensor2Value;
  int? sensor3Value;
  int? sensor4Value;

  @override
  void initState() {
    super.initState();
    _refreshSensorData();
  }

  Future<void> _refreshSensorData() async {
    String baseUrl;
    if (kIsWeb) {
      baseUrl = dotenv.env['BASE_URL_WEB'] ?? '';
    } else if (Platform.isAndroid) {
      baseUrl = dotenv.env['BASE_URL_ANDROID'] ?? '';
    } else {
      baseUrl = dotenv.env['BASE_URL_OTHER'] ?? '';
    }

    final url = Uri.parse('$baseUrl/api/sensor-data');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> sensorData = jsonDecode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        for (var sensor in sensorData) {
          String sensorId = sensor['sensor'];
          int sensorValue = int.parse(sensor['value']);
          await prefs.setInt('sensor_$sensorId', sensorValue);
        }
        print("✅ Sensor data synced on first load");
        _loadSensorValues(); // โหลดค่าเซ็นเซอร์ใหม่
      } else {
        throw Exception('Failed to load sensor data');
      }
    } catch (e) {
      print('❌ Error fetching sensor data: $e');
    }
  }

  Future<void> _loadSensorValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sensor1Value = prefs.getInt('sensor_1') ?? 0;
      sensor2Value = prefs.getInt('sensor_2') ?? 0;
      sensor3Value = prefs.getInt('sensor_3') ?? 0;
      sensor4Value = prefs.getInt('sensor_4') ?? 0;
    });

    print(
        'Sensor Values → 1:$sensor1Value  2:$sensor2Value  3:$sensor3Value  4:$sensor4Value');
  }

  final List<String> imagePathsClear = [
    'assets/bottle/clear01.png',
    'assets/bottle/clear02.png',
    'assets/bottle/clear03.png',
    'assets/bottle/clear04.png',
  ];
  final List<String> imagePathsCloudy = [
    'assets/bottle/Cloudy01.png',
    'assets/bottle/Cloudy02.png',
    'assets/bottle/Cloudy05.png',
    'assets/bottle/Cloudy04.png',
  ];
  final List<String> imagePathsColor = [
    'assets/bottle/Color01.png',
    'assets/bottle/Color02.png',
    'assets/bottle/Color03.png',
    'assets/bottle/Color04.png',
  ];
  final List<String> imagePathsOther = [
    'assets/bottle/Other01.png',
    'assets/bottle/Other02.png',
    'assets/bottle/Other03.png',
    'assets/bottle/Other04.png',
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: sensorscreenColor.withOpacity(0.25),
          ),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(), // ไม่ scroll
            padding: const EdgeInsets.only(left: 15, right: 10),
            children: [
              _buildSensorCard(context, sensor1Value, 'clear_plas', BinColor2,
                  imagePathsClear),
              const Divider(
                thickness: 2,
                height: 20,
                color: whiteColor,
              ),
              _buildSensorCard(context, sensor2Value, 'cloudy_plas', BinColor4,
                  imagePathsCloudy),
              const Divider(
                thickness: 2,
                height: 20,
                color: whiteColor,
              ),
              _buildSensorCard(context, sensor3Value, 'color_plas', BinColor1,
                  imagePathsColor),
              const Divider(
                thickness: 2,
                height: 20,
                color: whiteColor,
              ),
              _buildSensorCard(
                  context, sensor4Value, 'other', BinColor3, imagePathsOther),
              // const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSensorCard(
  BuildContext context,
  int? value,
  String titleKey,
  Color binColor,
  List<String> images,
) {
  final String title = {
        'clear_plas': AppLocalizations.of(context)!.clear_plas,
        'cloudy_plas': AppLocalizations.of(context)!.cloudy_plas,
        'color_plas': AppLocalizations.of(context)!.color_plas,
        'other': AppLocalizations.of(context)!.other,
      }[titleKey] ??
      'Unknown';

  final String description = {
        'clear_plas': AppLocalizations.of(context)!.descri_1,
        'cloudy_plas': AppLocalizations.of(context)!.descri_2,
        'color_plas': AppLocalizations.of(context)!.descri_3,
        'other': AppLocalizations.of(context)!.descri_4,
      }[titleKey] ??
      '';

  return Stack(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                color: binColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Image.asset('assets/Bin_sensor.png'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: FontblackColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 30,
                    width: 60,
                    decoration: BoxDecoration(
                      color: value == 1
                          ? FullColor.withOpacity(0.8)
                          : EmptyColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        value == 1
                            ? AppLocalizations.of(context)!.full
                            : AppLocalizations.of(context)!.empty,
                        style: const TextStyle(
                          color: FontColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.info, color: BlackColor),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Text(title,
                                    style: const TextStyle(fontSize: 20)),
                                const SizedBox(width: 10),
                                Container(
                                  width: 40,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: value == 1 ? FullColor : EmptyColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: FittedBox(
                                      child: Text(
                                        value == 1
                                            ? AppLocalizations.of(context)!.full
                                            : AppLocalizations.of(context)!
                                                .empty,
                                        style: const TextStyle(
                                            color: FontColor, fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(description,
                                style: const TextStyle(
                                    fontSize: 16, color: FontColor)),
                            const SizedBox(height: 15),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1,
                              ),
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(images[index],
                                      fit: BoxFit.cover),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                AppLocalizations.of(context)!.close,
                                style: const TextStyle(
                                    color: FontColor, fontSize: 15),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    ],
  );
}

class historyscreen extends StatefulWidget {
  const historyscreen({super.key});

  @override
  State<historyscreen> createState() => _historyscreenState();
}

class _historyscreenState extends State<historyscreen> {
  List<Map<String, dynamic>> historyList = [];
  String? _errorMessage;
  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
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

    final url = Uri.parse('$baseUrl/gethistory');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // ตรวจสอบว่าหน้าจอยังคงเปิดอยู่ก่อนเรียก setState
        if (mounted) {
          setState(() {
            historyList = data
                .map((item) => {
                      'type': item['type'],
                      'numbin': item['numbin'],
                      'imageBase64': item['imageBase64'] as String,
                      // แปลงให้เป็น String อีกครั้งหลังจากแปลงเขตเวลาเป็นท้องถิ่น
                      'create_at': DateTime.parse(item['create_at'])
                          .toLocal()
                          .toString(),
                    })
                .toList();
            historyList.sort((a, b) {
              DateTime dateA = DateTime.parse(a['create_at']);
              DateTime dateB = DateTime.parse(b['create_at']);
              return dateB
                  .compareTo(dateA); // จัดเรียงจากมากไปหาน้อย (ล่าสุดก่อน)
            });
          });
        }
      } else {
        print('Failed to load history');
      }
    } catch (e) {
      print('Error fetching history: $e');
    }
  }

  String _formatDateTime(String dateTime) {
    final dateTimeObj = DateTime.parse(dateTime);
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTimeObj);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: sensorscreenColor.withOpacity(0.25),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: historyList.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.grey.shade700),
                        backgroundColor: Colors.grey.shade300,
                      ),
                    )
                  : ListView.separated(
                      itemCount: historyList.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.white,
                        thickness: 1.2,
                        height: 10,
                      ),
                      itemBuilder: (context, index) {
                        final item = historyList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  base64Decode(item['imageBase64']),
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${AppLocalizations.of(context)!.typr}: ${item['type']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '${AppLocalizations.of(context)!.bin_num}: ${item['numbin']}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      '${AppLocalizations.of(context)!.classi_at}: ${_formatDateTime(item['create_at'])}',
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
