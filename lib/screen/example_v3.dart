import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_summer/constants/color.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class Examplev3Page extends StatefulWidget {
  const Examplev3Page({super.key});

  @override
  State<Examplev3Page> createState() => _exmplev3pageState();
}

class _exmplev3pageState extends State<Examplev3Page> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.history,
          style: const TextStyle(
            fontSize: 22,
            color: SecondaryColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(5),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              Expanded(
                child: historyList.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.grey.shade700),
                          backgroundColor: Colors.grey.shade300,
                        ),
                      )
                    : ListView.builder(
                        itemCount: historyList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Grey2Color.withOpacity(1),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Image.memory(
                                    base64Decode(
                                        historyList[index]['imageBase64']),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${AppLocalizations.of(context)!.typr}: ${historyList[index]['type']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                            '${AppLocalizations.of(context)!.bin_num}: ${historyList[index]['numbin']}'),
                                        Text(
                                          '${AppLocalizations.of(context)!.classi_at}: ${_formatDateTime(historyList[index]['create_at'])}',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
