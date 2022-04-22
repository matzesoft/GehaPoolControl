import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geha_pool_webapp/providers/db_provider.dart';
import 'package:geha_pool_webapp/strings.dart';
import 'package:geha_pool_webapp/widgets/change_temperature.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DbProvider>(
      builder: (context, fbProvider, child) {
        if (!fbProvider.init) return CircularProgressIndicator();
        if (fbProvider.systemState == SystemState.disabled) {
          return SystemStateInform(
            icon: EvaIcons.powerOutline,
            message: Strings.systemIsDisabled,
          );
        }
        if (fbProvider.systemState == SystemState.maintenance && kReleaseMode) {
          return SystemStateInform(
            icon: EvaIcons.options2Outline,
            message: Strings.systemIsInMaintenance,
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Temperature(fbProvider.poolData),
            Pump(fbProvider.pumpData),
            ReqTemp(fbProvider.reqTempData),
          ],
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
      padding: const EdgeInsets.all(8.0),
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

  @override
  Widget build(BuildContext context) {
    if (pool.state == ArduinoPoolState.connectionError ||
        pool.temperature == null)
      return ErrorReadingData(Strings.errorReadingTempData);

    return CardTemplate(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "${Strings.poolHasTemperature}${pool.temperatureRounded}°C",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: pool.lastUpdate != null
                  ? Text(Strings.lastUpdate + "${pool.lastUpdateFormatted}")
                  : NoUpdatedData(),
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

  @override
  Widget build(BuildContext context) {
    if (pump.state == ArduinoPumpState.connectionError || pump.active == null)
      return ErrorReadingData(Strings.errorReadingPumpData);

    return CardTemplate(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                active ? EvaIcons.thermometerPlus : EvaIcons.thermometer,
                color: active ? Colors.orangeAccent : Colors.green,
                size: 27,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                active ? Strings.pumpActive : Strings.pumpInactive,
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 12.0),
              child: pump.lastUpdate != null
                  ? Text(Strings.lastUpdate + "${pump.lastUpdateFormatted}")
                  : NoUpdatedData(),
            ),
          ],
        ),
      ),
    );
  }
}

class ReqTemp extends StatelessWidget {
  ReqTemp(this.reqTemp);
  final ReqTempData reqTemp;

  String get text {
    if (reqTemp.temperature == null) {
      return Strings.noRequestedTemperature;
    }
    if (!reqTemp.active!) {
      return "Die Wunschtemperatur liegt bei Außentemperatur.";
    }
    return Strings.requestedTemperatureIs + "${reqTemp.temperature}°C.";
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
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                EvaIcons.droplet,
                color: Colors.blueAccent,
                size: 27,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 4.0),
              child: Text(
                text,
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
              child: MaterialButton(
                onPressed: () => changeTemperature(context),
                child: Text(Strings.changeTemperature),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown when the Pool- or PumpArduino cannot read new enough data.
class ErrorReadingData extends StatelessWidget {
  ErrorReadingData(this.message);
  final String message;

  @override
  Widget build(BuildContext context) {
    return CardTemplate(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Icon(
                EvaIcons.close,
                color: Theme.of(context).errorColor,
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
      ),
    );
  }
}

/// Shown when the `last-update` value of the Pool- or PumpArduino is null.
class NoUpdatedData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          EvaIcons.close,
          color: Theme.of(context).errorColor,
          size: 18,
        ),
        Text(Strings.lastUpdateUnknown),
      ],
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
              color: Colors.blue,
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
