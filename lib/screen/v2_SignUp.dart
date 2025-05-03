import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_summer/constants/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

@RoutePage()
class SignUp2Page extends StatefulWidget {
  const SignUp2Page({super.key});

  @override
  State<SignUp2Page> createState() => _Signup2PageState();
}

class _Signup2PageState extends State<SignUp2Page> {
  final _formKey = GlobalKey<FormState>();
  final _compasswordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _compasswordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _errorMessage = null;
      });

      final username = _usernameController.text;
      final password = _passwordController.text;
      final email = _emailController.text;
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

      final url = Uri.parse('$baseUrl/adduser');
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'username': username,
            'password': password,
            'email': email,
            'device': 0,
          }),
        );

        if (response.statusCode == 200) {
          print('User added successfully');
          await Future.delayed(const Duration(seconds: 1));
          context.router.replaceNamed('/signinv2');
        } else {
          print('Failed to add user: ${response.body}');
        }
      } catch (e) {
        print('Error occurred: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 150.0,
                      maxHeight: 150.0,
                    ),
                    child: Image.asset('assets/logo.png'),
                  ),
                  const SizedBox(height: 10.0),
                  Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 80.0,
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.email,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .pls_email;
                                } else {
                                  final specialCharPattern = RegExp(
                                      r"[!#\$%\^&\*\(\)\-\+\=\{\}\[\]:;\<>?,\\|]");
                                  if (specialCharPattern.hasMatch(value)) {
                                    return AppLocalizations.of(context)!
                                        .can_not_email;
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 80.0,
                            child: TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.user,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.pls_user;
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
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context)!.password,
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
                                    AppLocalizations.of(context)!.compassword,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.pls_pass;
                                } else if (value != _passwordController.text) {
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
                      await _submitData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PrimaryColor,
                      minimumSize:
                          const Size(double.infinity, 55), // Set button height
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.signup,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: FontColor, fontSize: 20.0),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  GestureDetector(
                    onTap: () {
                      print('click Sign In!');
                      context.router.replaceNamed('/signinv2');
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: AppLocalizations.of(context)!.have_acc,
                              style: const TextStyle(
                                  fontSize: 17, color: FontColor)),
                          TextSpan(
                            text: AppLocalizations.of(context)!.signin,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: FontInUp),
                          ),
                        ],
                      ),
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
