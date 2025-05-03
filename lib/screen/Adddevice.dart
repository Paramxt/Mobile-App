import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_summer/constants/color.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_summer/router/routes.gr.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<int?> getDeviceData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('device');
}

Future<String?> getUsername() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}

Future<String?> getPassword() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('password');
}

@RoutePage()
class AdddevicePage extends StatefulWidget {
  const AdddevicePage({super.key});

  @override
  State<AdddevicePage> createState() => _adddeviceRouteState();
}

class _adddeviceRouteState extends State<AdddevicePage> {
  final _formKey = GlobalKey<FormState>();
  String _scanBarcode = 'Unknown';
  final TextEditingController _serialNumController = TextEditingController();
  String? _errorMessage;
  String? _username;
  String? _password;
  int? _device;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
      _password = prefs.getString('password');
      _device = prefs.getInt('device');
    });
    print('Loaded username: $_username');
    print('Loaded password: $_password');
  }

  // Future<void> scanBarcode() async {
  //   try {
  //     String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //       '#ff6666',
  //       'Cancel',
  //       true,
  //       ScanMode.BARCODE,
  //     );
  //     debugPrint(barcodeScanRes);
  //     setState(() {
  //       _scanBarcode = barcodeScanRes;
  //       // อัปเดตข้อมูลในฟิลด์ TextFormField อัตโนมัติ
  //       _serialNumController.text = barcodeScanRes;
  //     });
  //   } catch (e) {
  //     print('Error scanning barcode: $e');
  //     setState(() {
  //       _scanBarcode = 'Error: $e';
  //     });
  //   }
  // }

  Future<void> updateDevice() async {
    print('Serial number entered: ${_serialNumController.text}');
    if (_serialNumController.text == 'admin' &&
        _username != null &&
        _password != null) {
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

      final url = Uri.parse('$baseUrl/updatedevice');
      try {
        final response = await http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': _username,
            'password': _password,
            'device': 1,
          }),
        );

        if (response.statusCode == 200) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('device', 1);
          print('Device updated successfully');
          context.router.replaceNamed('/homedevice');
        } else {
          setState(() {
            _errorMessage = 'Failed to update device: ${response.body}';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Error: $e';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Invalid serial number or missing credentials';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _Heightbox = 50.0;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: BottomColor2,
        title: Text(
          AppLocalizations.of(context)!.adddevice,
          style: const TextStyle(
            fontSize: 24,
            color: SecondaryColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.router.replace(HomeDeviceRoute());
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20.0),
                        Text(
                          AppLocalizations.of(context)!.textscan,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 25.0),
                        ElevatedButton(
                          onPressed: () async {
                            print('Click Scan bar code');
                            // await scanBarcode();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SecondaryColor,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.clickscan,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: PrimaryColor, fontSize: 18.0),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        Text(
                          '${AppLocalizations.of(context)!.scanresult} : $_scanBarcode\n',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          AppLocalizations.of(context)!.enterserial,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 25.0),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _serialNumController,
                                decoration: InputDecoration(
                                  labelText:
                                      AppLocalizations.of(context)!.enterserial,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .pls_serial;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                onPressed: updateDevice,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: SecondaryColor,
                                  minimumSize:
                                      Size(double.infinity, _Heightbox),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.connect,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 78, 181, 145),
                                      fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
