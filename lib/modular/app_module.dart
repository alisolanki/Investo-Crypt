import 'package:flutter_modular/flutter_modular.dart';
import 'package:riskmanagement/Login/login_page.dart';
import 'package:riskmanagement/Login/register_page.dart';
import 'package:riskmanagement/about_us/about_us_page.dart';

import 'package:riskmanagement/home_page.dart';
import 'package:riskmanagement/result_page/result_page.dart';

class AppModule extends Module {
  // Provide all the routes for your module
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, args) => HomePage()),
        ChildRoute(LoginPage.route, child: (_, args) => LoginPage()),
        ChildRoute(RegisterPage.route, child: (_, args) => RegisterPage()),
        ChildRoute(ResultPage.route, child: (_, args) => ResultPage()),
        ChildRoute(AboutUsPage.route, child: (_, args) => AboutUsPage())
      ];
}
