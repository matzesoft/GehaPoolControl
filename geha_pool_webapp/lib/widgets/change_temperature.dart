import 'package:flutter/material.dart';
import 'package:geha_pool_webapp/providers/db_provider.dart';
import 'package:geha_pool_webapp/providers/user_provider.dart';
import 'package:geha_pool_webapp/strings.dart';
import 'package:provider/provider.dart';

class ChangeTemperature extends StatefulWidget {
  @override
  _ChangeTemperatureState createState() => _ChangeTemperatureState();
}

class _ChangeTemperatureState extends State<ChangeTemperature> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, _) {
      if (!userProvider.isSignedIn) {
        return LogInDialog(userProvider);
      }
      return ChangeTemperatureDialog(userProvider);
    });
  }
}

class ChangeTemperatureDialog extends StatefulWidget {
  ChangeTemperatureDialog(this.userProvider);

  final UserProvider userProvider;

  @override
  State<ChangeTemperatureDialog> createState() =>
      _ChangeTemperatureDialogState();
}

class _ChangeTemperatureDialogState extends State<ChangeTemperatureDialog> {
  int? temperature;
  bool failedUpdating = false;

  void updateTemperature(ReqTempData reqTemp) async {
    if (temperature != null) {
      if (await reqTemp.setTemperature(widget.userProvider, temperature!)) {
        Navigator.pop(context);
      } else {
        setState(() => failedUpdating = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DbProvider>(
      builder: (context, dbProvider, child) {
        final reqTemp = dbProvider.reqTempData;
        if (temperature == null) {
          if (reqTemp.temperature == null) {
            temperature = 20;
          } else {
            reqTemp.active!
                ? temperature = reqTemp.temperature
                : temperature = (MIN_TEMP - 1);
          }
        }

        return AlertDialog(
          scrollable: true,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  this.temperature! >= MIN_TEMP ? "$temperature°C" : "OFF",
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Slider(
                value: temperature!.toDouble(),
                onChanged: (newTemp) {
                  setState(() => temperature = newTemp.round());
                },
                min: (MIN_TEMP - 1).toDouble(),
                max: MAX_TEMP.toDouble(),
              ),
              Text(
                Strings.setRequestedTemperature,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: failedUpdating
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Strings.failedChangingReqTemp,
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: Theme.of(context).errorColor,
                                  ),
                        ),
                      )
                    : SizedBox.shrink(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(Strings.cancel),
            ),
            TextButton(
              onPressed: () => updateTemperature(reqTemp),
              child: Text(Strings.save),
            ),
          ],
        );
      },
    );
  }
}

class LogInDialog extends StatefulWidget {
  LogInDialog(this._userProvider);

  final UserProvider _userProvider;

  @override
  _LogInDialogState createState() => _LogInDialogState();
}

class _LogInDialogState extends State<LogInDialog> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool loading = false;
  bool failedSignIn = false;

  void signIn() async {
    setState(() => loading = true);
    if (!await widget._userProvider.signIn(email.text, password.text)) {
      setState(() {
        failedSignIn = true;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Center(child: CircularProgressIndicator());
    return AlertDialog(
      scrollable: true,
      title: Text(Strings.logIn),
      content: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 0, maxWidth: 350),
        child: AutofillGroup(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: TextField(
                  controller: email,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(labelText: Strings.email),
                  textInputAction: TextInputAction.next,
                  autofillHints: [AutofillHints.email],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: TextField(
                  controller: password,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(labelText: Strings.password),
                  obscureText: true,
                  autofillHints: [AutofillHints.password],
                  onSubmitted: (_) {
                    signIn();
                  },
                ),
              ),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: failedSignIn
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Strings.logInFailed,
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: Theme.of(context).errorColor,
                                  ),
                        ),
                      )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(Strings.cancel),
        ),
        TextButton(
          onPressed: () => signIn(),
          child: Text(Strings.next),
        ),
      ],
    );
  }
}
