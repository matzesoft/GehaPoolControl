import 'dart:async';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geha_pool_webapp/design/theme.dart';
import 'package:geha_pool_webapp/providers/db_provider.dart';
import 'package:geha_pool_webapp/strings.dart';
import 'package:geha_pool_webapp/widgets/change_temperature.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DbProvider>(
      builder: (context, fbProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Temperature(fbProvider.poolData),
              ReqTemp(fbProvider.reqTempData),
              Pump(fbProvider.pumpData),
            ],
          ),
        );
      },
    );
  }
}

class CardTemplate extends StatelessWidget {
  CardTemplate({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        child: SizedBox(
          width: double.infinity,
          child: child,
        ),
      ),
    );
  }
}

class Temperature extends StatelessWidget {
  Temperature(this.pool);
  final PoolData pool;

  Color textColor(BuildContext context) {
    if (pool.temperature != null) {
      final temp = pool.temperature!;
      final light = (Theme.of(context).brightness == Brightness.light);
      if (temp < 21.0) {
        return light ? Colors.blue.shade900 : Colors.blue.shade100;
      } else if (temp < 28.0) {
        return light ? Colors.orange.shade700 : Colors.orange.shade300;
      } else {
        return light ? Colors.red.shade600 : Colors.red.shade400;
      }
    }
    return Theme.of(context).textTheme.headline2!.color!;
  }

  String get errorMessage {
    if (pool.state == ArduinoPoolState.failedReadingSensor)
      return Strings.failedReadingTempSensor;
    if (pool.state == ArduinoPoolState.failedSettingTemp)
      return Strings.failedSettingTemp;
    if (pool.state == ArduinoPoolState.failedReadingSysState)
      return Strings.failedReadingSysStatePool;
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return CardTemplate(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 0.0),
            child: Text(
              "${pool.temperatureRounded}°C",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: textColor(context),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0, bottom: 4.0),
            child: Text(
              Strings.poolTemperature,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
            child: LastUpdateText(pool.lastUpdate),
          ),
          ErrorBanner(
            errorMessage,
            currentError: pool.state != ArduinoPoolState.noErrors,
          ),
        ],
      ),
    ));
  }
}

class ReqTemp extends StatelessWidget {
  ReqTemp(this.reqTemp);
  final ReqTempData reqTemp;

  String get tempText {
    if (reqTemp.temperature == null) {
      return Strings.noRequestedTemperature;
    }
    if (!reqTemp.active!) {
      return "< 0°C";
    }
    return "${reqTemp.temperature}°C";
  }

  void changeTemperature(BuildContext context) {
    showDialog(context: context, builder: (context) => ChangeTemperature());
  }

  @override
  Widget build(BuildContext context) {
    return CardTemplate(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 2.0),
              child: Text(
                tempText,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Colors.green.shade700,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 6.0),
              child: Text(
                Strings.requestedTemperature,
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6.0, bottom: 12.0),
              child: MaterialButton(
                onPressed: () => changeTemperature(context),
                child: Text(Strings.changeTemperature),
                textColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Pump extends StatelessWidget {
  Pump(this.pump);
  final PumpData pump;

  bool get active {
    if (pump.active == null) return false;
    return pump.active!;
  }

  String get errorMessage {
    if (pump.state == ArduinoPumpState.failedReadingTemp)
      return Strings.failedReadingTemp;
    if (pump.state == ArduinoPumpState.tempDataOutdated)
      return Strings.tempDataOutdated;
    if (pump.state == ArduinoPumpState.failedReadingSysState)
      return Strings.failedReadingSysStatePump;
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return CardTemplate(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                active ? EvaIcons.thermometerPlus : EvaIcons.thermometer,
                color: active ? Colors.orangeAccent : Colors.grey,
                size: 30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                active ? Strings.pumpActive : Strings.pumpInactive,
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 12.0),
              child: LastUpdateText(pump.lastUpdate),
            ),
            ErrorBanner(
              errorMessage,
              currentError: pump.state != ArduinoPumpState.noErrors,
            ),
          ],
        ),
      ),
    );
  }
}

class LastUpdateText extends StatefulWidget {
  LastUpdateText(this.lastUpdate);

  final DateTime? lastUpdate;

  @override
  State<LastUpdateText> createState() => _LastUpdateTextState();
}

class _LastUpdateTextState extends State<LastUpdateText> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (_) => setState(() {}));
  }

  String get dateTimeDifferenceFormatted {
    final difference = DateTime.now().difference(widget.lastUpdate!);
    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return "Vor einem Tag";
      } else {
        return "Vor ${difference.inDays} Tagen";
      }
    } else if (difference.inHours > 0) {
      if (difference.inHours == 1) {
        return "Vor einer Stunde";
      } else {
        return "Vor ${difference.inHours} Stunden";
      }
    } else if (difference.inMinutes > 0) {
      if (difference.inMinutes == 1) {
        return "Vor einer Minute";
      } else {
        return "Vor ${difference.inMinutes} Minuten";
      }
    } else {
      return "Gerade eben";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lastUpdate == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            EvaIcons.close,
            color: Theme.of(context).errorColor,
            size: 18,
          ),
          Text(
            Strings.lastUpdateUnknown,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      );
    }
    return Text(
      Strings.lastUpdate + dateTimeDifferenceFormatted,
      style: Theme.of(context).textTheme.subtitle2,
    );
  }
}

class ErrorBanner extends StatelessWidget {
  ErrorBanner(this.errorMessage, {this.currentError: true});

  final bool currentError;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 350),
      child: !currentError
          ? SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Material(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                child: Container(
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          EvaIcons.alertCircleOutline,
                          color: Theme.of(context).errorColor,
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            errorMessage,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
