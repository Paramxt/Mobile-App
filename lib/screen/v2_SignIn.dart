import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_summer/constants/color.dart';
import 'package:flutter_summer/l10n/language.dart';
import 'package:flutter_summer/l10n/language2.dart';
import 'package:flutter_summer/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_summer/router/routes.gr.dart';
import 'package:flutter_summer/screen/reset_password.dart';
import 'package:flutter_summer/screen/screenhome.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class Login2Page extends StatefulWidget {
  const Login2Page({Key? key}) : super(key: key);
  @override
  State<Login2Page> createState() => _LoginPageState();
}

class _LoginPageState extends State<Login2Page> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isSelected = false;
  String? _errorMessage;
  Language? _selectedLanguage;
  bool _isLoggingIn = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void itemSwitch(bool value) {
    setState(() {
      isSelected = !isSelected;
    });
  }

  Future<void> loginUser(
      BuildContext context, String username, String password) async {
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
    final url = Uri.parse('$baseUrl/login');

    if (_formKey.currentState!.validate()) {
      if (_isLoggingIn) return;
      setState(() {
        _isLoggingIn = true;
        _errorMessage = null;
      });
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': username,
            'password': password,
          }),
        );

        if (response.statusCode == 200) {
          final responseBody = jsonDecode(response.body);
          final device = responseBody['device'];
          final email = responseBody['email'];
          if (device != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('username', username);
            await prefs.setString('password', password);
            await prefs.setString('email', email);
            await prefs.setInt('device', device);
            await Future.delayed(const Duration(seconds: 3));
            context.router.replaceNamed('/homedevice');
          } else {
            setState(() {
              _errorMessage = 'Device data is missing';
            });
          }
        } else {
          setState(() {
            _errorMessage = 'Login failed : ${response.body}';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Error: $e';
        });
      } finally {
        setState(() {
          _isLoggingIn = false;
        });
      }
    } else {
      setState(() {
        _isLoggingIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: DropdownButton<Language>(
                    underline: const SizedBox(height: 0.0),
                    onChanged: (Language? language) async {
                      if (language != null) {
                        Locale _locale = await setLocale(language.languageCode);
                        MyApp.setLocale(context, _locale);
                        setState(() {
                          _selectedLanguage = language;
                        });
                      }
                    },
                    items: Language.languageList()
                        .map<DropdownMenuItem<Language>>((language) {
                      return DropdownMenuItem<Language>(
                        value: language,
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/${language.languageCode}.jpg',
                              width: 24,
                              height: 24,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    hint: Row(
                      children: [
                        if (_selectedLanguage == null)
                          Image.asset(
                            'assets/en.jpg',
                            width: 24,
                            height: 24,
                          ),
                        if (_selectedLanguage != null)
                          Image.asset(
                            'assets/${_selectedLanguage!.languageCode}.jpg',
                            width: 24,
                            height: 24,
                          ),
                      ],
                    ),
                    icon: const Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
              Center(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          constraints: const BoxConstraints(
                            maxWidth: 200.0,
                            maxHeight: 240.0,
                          ),
                          child: Image.asset('assets/logo.png'),
                        ),
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
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 80.0,
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.password,
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
                        const SizedBox(height: 2.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResetPasswordPage()),
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context)!
                                  .forget_pass, // เช่น "Forgot password?"
                              style: const TextStyle(
                                  color: FontColor, fontSize: 15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        SizedBox(
                          height: 80.0,
                          child: Stack(
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  await loginUser(
                                      context,
                                      _usernameController.text,
                                      _passwordController.text);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: PrimaryColor,
                                  minimumSize: const Size(double.infinity, 55),
                                ),
                                child: _isLoggingIn
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  PrimaryColor),
                                        ),
                                      )
                                    : Text(
                                        AppLocalizations.of(context)!.signin,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: FontColor,
                                          fontSize: 18.0,
                                        ),
                                      ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: _errorMessage != null
                                    ? Container(
                                        child: Text(
                                          _errorMessage!,
                                          style:
                                              const TextStyle(color: RedColor),
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Divider(
                                thickness: 1.5,
                                color: FontblackColor,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Text(
                                AppLocalizations.of(context)!.or,
                                style: const TextStyle(
                                    color: FontblackColor, fontSize: 17),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                thickness: 1.5,
                                color: FontblackColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: () {
                            context.router.pushNamed('/signupv2');
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: AppLocalizations.of(context)!.not_acc,
                                  style: const TextStyle(
                                      fontSize: 17, color: FontColor),
                                ),
                                TextSpan(
                                  text: AppLocalizations.of(context)!.signup,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: FontInUp,
                                    fontSize: 17,
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
