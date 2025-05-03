import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_summer/constants/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String? _password;
  String? _username;
  final _formKey = GlobalKey<FormState>();
  final _compasswordController = TextEditingController();
  final TextEditingController _oldpasswordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _password = prefs.getString('password');
      _username = prefs.getString('username');
    });
  }

  Future<void> _updatepass() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _errorMessage = null;
      });

      final oldPassword = _oldpasswordController.text;
      final newPassword = _newpasswordController.text;

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

      final url = Uri.parse('$baseUrl/updatepassword');

      try {
        final response = await http.put(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'username': _username,
            'old_password': oldPassword,
            'new_password': newPassword,
          }),
        );

        if (response.statusCode == 200) {
          print('Password updated successfully');
          print('Loaded username: $_username');
          print('Loaded newpassword: $newPassword');
          context.router.pop();
        } else {
          setState(() {
            _errorMessage = 'Failed to update password: ${response.body}';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Error occurred: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.change_pass,
          style: const TextStyle(
            fontSize: 22,
            color: BlackColor,
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 80.0,
                            child: TextFormField(
                              controller: _oldpasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context)!.old_pass,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.pls_pass;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 80.0,
                            child: TextFormField(
                              controller: _newpasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context)!.new_pass,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.pls_pass;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 80.0,
                            child: TextFormField(
                              controller: _compasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context)!.com_new_pass,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.pls_pass;
                                } else if (value !=
                                    _newpasswordController.text) {
                                  return AppLocalizations.of(context)!.unmatch;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () async {
                      await _updatepass();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SecondaryColor,
                      side: BorderSide.none,
                      minimumSize: const Size(double.infinity, 55),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.change_pass,
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(color: PrimaryColor, fontSize: 20.0),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _errorMessage != null
                        ? Text(
                            _errorMessage!,
                            style: const TextStyle(color: RedColor),
                          )
                        : const SizedBox(),
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
