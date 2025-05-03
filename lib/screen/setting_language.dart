import 'package:flutter/material.dart';
import 'package:flutter_summer/constants/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_summer/l10n/language.dart';
import 'package:flutter_summer/l10n/language2.dart';
import 'package:flutter_summer/main.dart';

class ChangeLanguagePage extends StatefulWidget {
  const ChangeLanguagePage({super.key});

  @override
  State<ChangeLanguagePage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguagePage> {
  Language? _selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.change_lang,
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
          child: Column(
            children: Language.languageList().asMap().entries.map((entry) {
              int index = entry.key;
              Language language = entry.value;
              return Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    title: Text(
                      language.name,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () async {
                      Locale locale = await setLocale(language.languageCode);
                      MyApp.setLocale(context, locale);
                      setState(() {
                        _selectedLanguage = language;
                      });
                    },
                  ),
                  if (index != Language.languageList().length - 1)
                    const Divider(color: Colors.grey, thickness: 1.0),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
