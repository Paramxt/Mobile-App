import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_summer/constants/color.dart';
import 'package:http/http.dart' as http;
import 'set_new_password_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerifyOtpPage extends StatefulWidget {
  final String email;
  const VerifyOtpPage({super.key, required this.email});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isVerifying = false;
  String? _errorMessage;

  String getBaseUrl() {
    if (kIsWeb) return dotenv.env['BASE_URL_WEB']!;
    if (Platform.isAndroid) return dotenv.env['BASE_URL_ANDROID']!;
    return dotenv.env['BASE_URL_OTHER']!;
  }

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final otp = _otpController.text.trim();
    final url = Uri.parse('${getBaseUrl()}/confirm');

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SetNewPasswordPage(email: widget.email),
          ),
        );
      } else {
        setState(() {
          _errorMessage =
              '${AppLocalizations.of(context)!.in_otp} : ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'เกิดข้อผิดพลาด: $e';
      });
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.confirm_otp,
            style: const TextStyle(
              fontSize: 20,
              color: FontColor,
            )),
        backgroundColor: whiteColor,
        foregroundColor: FontColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.enter_otp,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: FontColor,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.otp,
                  labelStyle: const TextStyle(color: Colors.brown),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '${AppLocalizations.of(context)!.pls_otp}';
                  }
                  if (value.length != 6) {
                    return '${AppLocalizations.of(context)!.sixotp}';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 80,
                child: Stack(
                  children: [
                    ElevatedButton(
                      onPressed: _isVerifying ? null : _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PrimaryColor,
                        foregroundColor: FontColor,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isVerifying
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
                              AppLocalizations.of(context)!.confirm_otp,
                              style: TextStyle(fontSize: 18),
                            ),
                    ),
                    if (_errorMessage != null)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14),
                          ),
                        ),
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
