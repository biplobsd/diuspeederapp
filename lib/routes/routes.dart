import 'package:diuspeeder/app/view/login_page/login_page.dart';
import 'package:diuspeeder/app/view/mark_as_done_page/mark_as_done_page.dart';
import 'package:diuspeeder/app/view/menus_page/menus_page.dart';
import 'package:diuspeeder/app/view/vpl_post_page/vpl_post_page.dart';
import 'package:flutter/material.dart';

class Routes {
  Route? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;


    switch (settings.name) {
      case MenuesPage.pathName:
        return MaterialPageRoute<MenuesPage>(
          builder: (context) => const MenuesPage(),
        );
      case LoginPage.pathName:
        return MaterialPageRoute<LoginPage>(
          builder: (context) => LoginPage(
            wantThisPage: args is String ? args : MenuesPage.pathName,
          ),
        );
      case VPLPostPage.pathName:
        return MaterialPageRoute<VPLPostPage>(
          builder: (context) => VPLPostPage(),
        );
      case MarkAsDonePage.pathName:
        return MaterialPageRoute<MarkAsDonePage>(
          builder: (context) => MarkAsDonePage(),
        );
      default:
        return null;
    }
  }
}
