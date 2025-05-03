import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_summer/constants/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_summer/screen/setting_changepass.dart';
import 'package:flutter_summer/screen/setting_language.dart';

@RoutePage()
class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.setting,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    title: Text(
                      AppLocalizations.of(context)!.language,
                      style: const TextStyle(
                        fontSize: 17,
                        color: BlackColor,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.navigate_next_outlined,
                      size: 30,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangeLanguagePage()),
                      );
                    },
                  ),
                  const Divider(color: Colors.grey),
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    title: Text(
                      AppLocalizations.of(context)!.pass_and_secu,
                      style: const TextStyle(
                        fontSize: 17,
                        color: BlackColor,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.navigate_next_outlined,
                      size: 30,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangePassword()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
