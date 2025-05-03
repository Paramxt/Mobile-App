import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_summer/l10n/locali18n.dart';
import 'package:flutter_summer/router/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_summer/screen/web_socket_notifier.dart';
import 'package:flutter_summer/screen/web_socket_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  final webSocketService = WebSocketService();
  final notificationPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await notificationPlugin.initialize(initializationSettings);
  runApp(
    ChangeNotifierProvider(
      create: (_) => WebSocketNotifier(webSocketService, notificationPlugin),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});
  // ignore: library_private_types_in_public_api
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();
  Locale _locale = const Locale('en', '');

  String username = '';
  int countDevice = 0;
  WebSocketNotifier? _webSocketNotifier;

  @override
  void initState() {
    super.initState();
    _loadDataFromSharedPreferences();
  }

  _loadDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
      countDevice = prefs.getInt('countDevice') ?? 0;
    });
    if (username.isNotEmpty) {
      final webSocketService = WebSocketService();
      final notificationPlugin = FlutterLocalNotificationsPlugin();
      _webSocketNotifier =
          WebSocketNotifier(webSocketService, notificationPlugin);
    }
  }

  @override
  void dispose() {
    _webSocketNotifier?.dispose();
    super.dispose();
  }

  setLocale(Locale locale) async {
    await setLocaleStore(locale.toString());
    if (_locale == locale) return;
    setState(() {
      _locale = locale;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Flutter Workshop",
      debugShowCheckedModeBanner: false,
      locale: _locale,
      // hook up router to MaterialApp
      routerConfig: _appRouter.config(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
