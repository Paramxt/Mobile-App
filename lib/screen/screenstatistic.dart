import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_summer/constants/color.dart';
import 'package:flutter_summer/constants/indicator.dart';
import 'package:flutter_summer/screen/Device.dart';
import 'package:flutter_summer/screen/screenhome.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_switch/flutter_switch.dart';

Future<int?> getDeviceData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('device');
}

bool _isLoading = true;

class ScreenStus extends StatefulWidget {
  const ScreenStus({Key? key}) : super(key: key);

  @override
  State<ScreenStus> createState() => _ScreenStusState();
}

class _ScreenStusState extends State<ScreenStus> {
  int? device;
  @override
  void initState() {
    super.initState();
    loadDeviceData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadDeviceData(); // เรียกทุกครั้งที่มีการเปลี่ยนแปลง dependencies
  }

  Future<void> loadDeviceData() async {
    try {
      device = await getDeviceData();
    } catch (e) {
      print('Error loading device data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: whiteColor,
        body: Center(
          child: CircularProgressIndicator(), // Show loading indicator
        ),
      );
    }

    return Scaffold(
      backgroundColor: whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Builder(
          builder: (BuildContext context) {
            if (device == 1) {
              return ScreenHis();
            } else {
              return NoDeviceScreen();
            }
          },
        ),
      ),
    );
  }
}

class ScreenHis extends StatefulWidget {
  const ScreenHis({super.key});

  @override
  State<ScreenHis> createState() => _ScreenHisState();
}

class _ScreenHisState extends State<ScreenHis> {
  Map<int, int> numbinStats = {};
  List<Map<String, dynamic>> statsData = [];
  String? _errorMessage;
  bool isPoweredOn = true;

  @override
  void initState() {
    super.initState();
    _fetchNumbinStats();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchNumbinStats(); // เรียกทุกครั้งที่มีการเปลี่ยนแปลง dependencies
  }

  Future<void> _fetchNumbinStats() async {
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

    final url = Uri.parse('$baseUrl/getnumbinstats');
    final response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print('Response data: $responseBody');
      } else {
        print('Failed to load numbin stats');
      }
    } catch (e) {
      print('Error parsing response: $e');
    }

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print('Response data: $responseBody');

      setState(() {
        // final oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));

        // Clear previous data
        numbinStats = {};
        statsData = [];

        Map<String, dynamic> data = Map<String, dynamic>.from(responseBody);

        data.forEach((key, value) {
          try {
            int numbin = int.parse(key);
            int count = value; // ใช้ value โดยตรงเป็น count
            // Update numbinStats for all-time data
            numbinStats[numbin] = (numbinStats[numbin] ?? 0) + count;
            // Add data to statsData
            statsData.add({
              'type': numbin,
              'count': count,
              // 'date': dataDate.toString(), // ไม่มีการใช้ date ในที่นี้
            });
          } catch (e) {
            print('Error processing key: $key, error: $e');
          }
        });
      });
    } else {
      print('Failed to load numbin stats');
    }
  }

  List<FlSpot> _getSpots() {
    if (statsData.isEmpty) {
      return [];
    }

    return statsData.map((entry) {
      final type = entry['type'] as int;
      final count = entry['count'] as int;
      return FlSpot(type.toDouble() - 1, count.toDouble());
    }).toList();
  }

  List<PieChartSectionData> _getSections() {
    if (numbinStats.isEmpty) {
      return [
        PieChartSectionData(value: 1, color: Colors.grey, title: 'No data')
      ];
    }

    return numbinStats.entries.map((entry) {
      final numbin = entry.key;
      final count = entry.value;
      final double percentage =
          count / numbinStats.values.reduce((a, b) => a + b) * 100;

      Color color;
      switch (numbin) {
        case 1:
          color = BinColor2;
          break;
        case 2:
          color = BinColor4;
          break;
        case 3:
          color = BinColor1;
          break;
        case 4:
          color = BinColor3;
          break;
        default:
          color = Colors.grey;
      }

      return PieChartSectionData(
        color: color,
        value: percentage,
        title: '${percentage.toStringAsFixed(0)}%',
        showTitle: true,
        titleStyle: const TextStyle(color: BlackColor, fontSize: 18),
      );
    }).toList();
  }

  SideTitles TypePlastic() {
    return SideTitles(
      showTitles: true,
      interval: 1,
      getTitlesWidget: (double value, TitleMeta meta) {
        const style = TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        );
        Map<int, String> typeMap = {
          1: 'Type 1',
          2: 'Type 2',
          3: 'Type 3',
          4: 'Type 4',
        };

        String title = typeMap[value.toInt()] ?? '';
        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: Text(title, style: style),
        );
      },
      reservedSize: 28,
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: (numbinStats[1] ?? 0).toDouble(),
            color: Colors.orange,
            width: 18,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: (numbinStats[2] ?? 0).toDouble(),
            color: Colors.blue,
            width: 18,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(
            toY: (numbinStats[3] ?? 0).toDouble(),
            color: Colors.red,
            width: 18,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(
            toY: (numbinStats[4] ?? 0).toDouble(),
            color: Colors.green,
            width: 18,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.statistics,
          style: const TextStyle(
            fontSize: 22,
            color: FontColor,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // กล่อง Pie Chart
                Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.percentage,
                        style: const TextStyle(color: FontColor, fontSize: 18),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 180,
                        child: numbinStats.isEmpty
                            ? const CircularProgressIndicator()
                            : PieChart(
                                PieChartData(
                                  sections: _getSections(),
                                  borderData: FlBorderData(show: false),
                                  sectionsSpace: 5,
                                  startDegreeOffset: 180,
                                ),
                              ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Indicator(
                              color: BinColor2,
                              text: AppLocalizations.of(context)!.clear,
                              isSquare: false,
                              size: 20),
                          Indicator(
                              color: BinColor4,
                              text: AppLocalizations.of(context)!.cloudy,
                              isSquare: false,
                              size: 20),
                          Indicator(
                              color: BinColor1,
                              text: AppLocalizations.of(context)!.color,
                              isSquare: false,
                              size: 20),
                          Indicator(
                              color: BinColor3,
                              text: AppLocalizations.of(context)!.other,
                              isSquare: false,
                              size: 20),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // รูปภาพย่อ
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      _isLoading = true; // แสดง Loading Indicator
                    });
                    await _fetchNumbinStats(); // เรียกฟังก์ชันโหลดข้อมูล
                  },
                  child: SizedBox(
                    height: 65,
                    width: 65,
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.contain,
                      color: Colors.white.withOpacity(0.4),
                      colorBlendMode: BlendMode.modulate,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // กล่อง Line Chart
                Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.bottleofweek,
                        style: const TextStyle(color: FontColor, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 200,
                        child: numbinStats.isEmpty
                            ? const CircularProgressIndicator()
                            : BarChart(
                                BarChartData(
                                  maxY: 100,
                                  minY: 0,
                                  barGroups: _getBarGroups(),
                                  borderData: FlBorderData(show: false),
                                  titlesData: FlTitlesData(
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 1,
                                        getTitlesWidget: (value, meta) {
                                          const style = TextStyle(
                                            color: FontColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          );
                                          Map<int, String> typeMap = {
                                            0: AppLocalizations.of(context)!
                                                .clear,
                                            1: AppLocalizations.of(context)!
                                                .cloudy,
                                            2: AppLocalizations.of(context)!
                                                .color,
                                            3: AppLocalizations.of(context)!
                                                .other,
                                          };
                                          String title =
                                              typeMap[value.toInt()] ?? '';
                                          return SideTitleWidget(
                                            axisSide: meta.axisSide,
                                            child: Text(title, style: style),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
