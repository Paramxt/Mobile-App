// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter_summer/screen/Adddevice.dart' as _i1;
import 'package:flutter_summer/screen/reset_password.dart' as _i2;
import 'package:flutter_summer/screen/example_v3.dart' as _i3;
import 'package:flutter_summer/screen/setting.dart' as _i6;
import 'package:flutter_summer/screen/v2_HomeDevice.dart' as _i4;
import 'package:flutter_summer/screen/v2_SignIn.dart' as _i5;
import 'package:flutter_summer/screen/v2_SignUp.dart' as _i7;

abstract class $AppRouter extends _i8.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i8.PageFactory> pagesMap = {
    AdddeviceRoute.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AdddevicePage(),
      );
    },
    ExampleRoute.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.ResetPasswordPage(),
      );
    },
    Examplev3Route.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.Examplev3Page(),
      );
    },
    HomeDeviceRoute.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.HomeDevicePage(),
      );
    },
    Login2Route.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.Login2Page(),
      );
    },
    SettingRoute.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.SettingPage(),
      );
    },
    SignUp2Route.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.SignUp2Page(),
      );
    },
  };
}

/// generated route for
/// [_i1.AdddevicePage]
class AdddeviceRoute extends _i8.PageRouteInfo<void> {
  const AdddeviceRoute({List<_i8.PageRouteInfo>? children})
      : super(
          AdddeviceRoute.name,
          initialChildren: children,
        );

  static const String name = 'AdddeviceRoute';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ResetPasswordPage]
class ExampleRoute extends _i8.PageRouteInfo<void> {
  const ExampleRoute({List<_i8.PageRouteInfo>? children})
      : super(
          ExampleRoute.name,
          initialChildren: children,
        );

  static const String name = 'ExampleRoute';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i3.Examplev3Page]
class Examplev3Route extends _i8.PageRouteInfo<void> {
  const Examplev3Route({List<_i8.PageRouteInfo>? children})
      : super(
          Examplev3Route.name,
          initialChildren: children,
        );

  static const String name = 'Examplev3Route';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i4.HomeDevicePage]
class HomeDeviceRoute extends _i8.PageRouteInfo<void> {
  const HomeDeviceRoute({List<_i8.PageRouteInfo>? children})
      : super(
          HomeDeviceRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeDeviceRoute';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i5.Login2Page]
class Login2Route extends _i8.PageRouteInfo<void> {
  const Login2Route({List<_i8.PageRouteInfo>? children})
      : super(
          Login2Route.name,
          initialChildren: children,
        );

  static const String name = 'Login2Route';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i6.SettingPage]
class SettingRoute extends _i8.PageRouteInfo<void> {
  const SettingRoute({List<_i8.PageRouteInfo>? children})
      : super(
          SettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingRoute';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i7.SignUp2Page]
class SignUp2Route extends _i8.PageRouteInfo<void> {
  const SignUp2Route({List<_i8.PageRouteInfo>? children})
      : super(
          SignUp2Route.name,
          initialChildren: children,
        );

  static const String name = 'SignUp2Route';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}
