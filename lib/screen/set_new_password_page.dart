import 'dart:convert';
import 'dart:io' show Platform;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_summer/constants/color.dart';
import 'package:flutter_summer/router/routes.gr.dart';
import 'package:flutter_summer/screen/v2_SignIn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class SetNewPasswordPage extends StatefulWidget {
  final String email;
  const SetNewPasswordPage({super.key, required this.email});

  @override
  State<SetNewPasswordPage> createState() => _SetNewPasswordPageState();
}

class _SetNewPasswordPageState extends State<SetNewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  String getBaseUrl() {
    if (kIsWeb) return dotenv.env['WEB_BASE_URL']!;
    if (Platform.isAndroid) return dotenv.env['BASE_URL_ANDROID']!;
    return dotenv.env['BASE_URL_OTHER']!;
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (password != confirm) {
      setState(() {
        _errorMessage = '${AppLocalizations.of(context)!.unmatch}';
      });
      return;
    }

    final url = Uri.parse('${getBaseUrl()}/resetpass');

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email, 'newPassword': password}),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Login2Page()),
        );
      } else {
        setState(() {
          _errorMessage =
              '${AppLocalizations.of(context)!.error_pass}: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'เกิดข้อผิดพลาด: $e';
      });
    } finally {
      setState(() {
        _isSubmitting = false;
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
        title: Text(
          AppLocalizations.of(context)!.set_pass,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildPasswordField("${AppLocalizations.of(context)!.new_pass}",
                  _passwordController),
              const SizedBox(height: 10),
              _buildPasswordField(
                  "${AppLocalizations.of(context)!.com_new_pass}",
                  _confirmController),
              const SizedBox(height: 20),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '${AppLocalizations.of(context)!.pls_pass}';
        }

        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 80.0,
      child: Stack(
        children: [
          ElevatedButton(
            onPressed: _isSubmitting ? null : _resetPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: PrimaryColor,
              foregroundColor: FontColor,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    AppLocalizations.of(context)!.confirm,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
          if (_errorMessage != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
