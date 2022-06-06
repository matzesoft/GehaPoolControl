import 'package:flutter/material.dart';
import 'package:geha_pool_webapp/design/theme.dart';
import 'package:geha_pool_webapp/providers/db_provider.dart';
import 'package:geha_pool_webapp/providers/user_provider.dart';
import 'package:geha_pool_webapp/widgets/app_setup.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(GehaPoolWebApp());
}

class GehaPoolWebApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DbProvider(),
      lazy: false,
      child: ChangeNotifierProvider(
        create: (context) => UserProvider(),
        child: MaterialApp(
          title: 'GeHa Pool',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: AppConstraints(),
        ),
      ),
    );
  }
}

class AppConstraints extends StatelessWidget {
  static const appMaxMobileWidth = 600.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 0,
                maxWidth: appMaxMobileWidth,
              ),
              child: AppStateHandler(),
            ),
          ),
        ),
      ),
    );
  }
}
