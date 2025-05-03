import 'package:auto_route/auto_route.dart';
import 'package:flutter_summer/router/routes.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        CustomRoute(
          path: '/homedevice/adddevice',
          page: AdddeviceRoute.page,
        ),
        CustomRoute(
          path: '/signinv2',
          page: Login2Route.page,
          initial: true,
        ),
        CustomRoute(
          path: '/signupv2',
          page: SignUp2Route.page,
        ),
        CustomRoute(
          path: '/examplev2',
          page: ExampleRoute.page,
        ),
        CustomRoute(
          path: '/homedevice',
          page: HomeDeviceRoute.page,
        ),
        CustomRoute(
          path: '/setting',
          page: SettingRoute.page,
        ),
        CustomRoute(
          path: '/examplev3',
          page: Examplev3Route.page,
        ),
      ];
}
