import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geha_pool_webapp/providers/db_provider.dart';
import 'package:geha_pool_webapp/strings.dart';
import 'package:geha_pool_webapp/widgets/dashboard.dart';
import 'package:provider/provider.dart';

class AppStateHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<DbProvider, AppState>(
      selector: (context, dbProvider) => dbProvider.appState,
      builder: (context, appState, child) {
        if (appState == AppState.initalizing) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(Strings.connectToServer),
              )
            ],
          );
        } else if (appState == AppState.failedConnectingToServer) {
          return AppStateError(
            icon: EvaIcons.hardDriveOutline,
            message: Strings.failedConnectingToServer,
            onPressed:
                Provider.of<DbProvider>(context, listen: false).retrySetup,
          );
        } else if (appState == AppState.timeoutServerConnection) {
          return AppStateError(
            icon: EvaIcons.clockOutline,
            message: Strings.failedConnectingToServerDueTimeout,
            onPressed:
                Provider.of<DbProvider>(context, listen: false).retrySetup,
          );
        }
        return SystemStateHandler();
      },
    );
  }
}

class AppStateError extends StatelessWidget {
  AppStateError({required this.icon, required this.message, this.onPressed});
  final IconData icon;
  final String message;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(48.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    icon,
                    color: Theme.of(context).errorColor,
                    size: 30,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Theme.of(context).errorColor,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: MaterialButton(
              onPressed: onPressed,
              child: Text(Strings.tryAgain),
            ),
          ),
        ],
      ),
    );
  }
}

class SystemStateHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<DbProvider, SystemState>(
      selector: (context, dbProvider) => dbProvider.systemState,
      builder: (context, systemState, child) {
        if (systemState == SystemState.disabled) {
          return SystemStateInform(
            icon: EvaIcons.powerOutline,
            message: Strings.systemIsDisabled,
          );
        }
        if (systemState == SystemState.maintenance && kReleaseMode) {
          return SystemStateInform(
            icon: EvaIcons.options2Outline,
            message: Strings.systemIsInMaintenance,
          );
        }
        return Dashboard();
      },
    );
  }
}

class SystemStateInform extends StatelessWidget {
  SystemStateInform({required this.icon, required this.message});
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(48.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
            child: Icon(
              icon,
              color: Theme.of(context).accentColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
            child: Text(
              message,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ],
      ),
    );
  }
}
