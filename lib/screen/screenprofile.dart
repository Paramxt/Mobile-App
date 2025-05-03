import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_summer/constants/color.dart';
import 'package:flutter_summer/screen/infomation.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter_summer/screen/ProfileMenuWidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getUsername() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}

Future<String?> getPassword() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('password');
}

Future<String?> getEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}

class ScreenProfile extends StatefulWidget {
  const ScreenProfile({Key? key}) : super(key: key);

  @override
  State<ScreenProfile> createState() => _ScreenProfileState();
}

class _ScreenProfileState extends State<ScreenProfile> {
  String? _username;
  String? _password;
  String? _email;
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
      _email = prefs.getString('email');
    });
    print('Loaded username: $_username');
    print('Loaded password: $_password');
    print('Loaded email: $_email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: const TextStyle(
            fontSize: 22,
            color: SecondaryColor,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Image.asset('assets/logo.png'),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '$_username',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 5),
              Text(
                '$_email',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              const Divider(),
              ProfileMenuWidget(
                  title: AppLocalizations.of(context)!.setting,
                  icon: Icons.settings,
                  onPress: () {
                    print('Click Setting');
                    context.router.pushNamed('/setting');
                  }),
              ProfileMenuWidget(
                  title: AppLocalizations.of(context)!.history,
                  icon: Icons.history_rounded,
                  onPress: () {
                    print('Click History');
                    context.router.pushNamed('/examplev3');
                  }),
              const Divider(),
              ProfileMenuWidget(
                  title: AppLocalizations.of(context)!.info,
                  icon: Icons.info_rounded,
                  onPress: () {
                    print('Click Infomation');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return InfomationPage();
                      },
                    );
                  }),
              ProfileMenuWidget(
                  title: AppLocalizations.of(context)!.logout,
                  icon: Icons.logout_outlined,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    print('Click Log Out');
                    context.router.pushNamed('/signinv2');
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
