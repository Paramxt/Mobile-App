import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_summer/constants/color.dart';
import 'package:http/http.dart' as http;
import 'verify_otp_page.dart';
import 'package:flutter_summer/screen/verify_otp_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  bool _isSendingOtp = false;

  String? _errorMessage;

  String getBaseUrl() {
    if (Platform.isAndroid) return dotenv.env['BASE_URL_ANDROID']!;
    if (Platform.isIOS) return dotenv.env['BASE_URL_OTHER']!;
    return dotenv.env['WEB_BASE_URL']!;
  }

  Future<void> _sendOtp(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    final url = Uri.parse('${getBaseUrl()}/sendOPT');

    setState(() {
      _isSendingOtp = true;
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => VerifyOtpPage(email: email)),
        );
      } else {
        _errorMessage = ' ${response.body}';
      }
    } catch (e) {
      _errorMessage = 'เกิดข้อผิดพลาด: $e';
    } finally {
      setState(() {
        _isSendingOtp = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        foregroundColor: FontColor,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.forget_pass,
          style: TextStyle(
            fontSize: 20.0,
            color: FontColor,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.email_otp,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
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
                      return AppLocalizations.of(context)!.pls_email;
                    }
                    // คุณสามารถเพิ่ม validate email format ได้ที่นี่
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 90.0,
                child: Stack(
                  children: [
                    ElevatedButton(
                      onPressed: _isSendingOtp
                          ? null
                          : () async {
                              await _sendOtp(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PrimaryColor,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: _isSendingOtp
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              AppLocalizations.of(context)!.confirm,
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
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                    color: RedColor, fontSize: 14),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
