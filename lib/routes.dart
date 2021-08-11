import 'package:flutter/material.dart';

enum EnumRoutes {
  BottomNavigationPage,
}

const Map<EnumRoutes, String> Routes = {EnumRoutes.BottomNavigationPage: '/bottom-navigation-page'};

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{};
