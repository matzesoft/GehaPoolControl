import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:geha_pool_webapp/providers/user_provider.dart';
import 'package:intl/intl.dart';

const _ARDUINO_POOL_PATH = "/arduino-pool/";
const _ARDUINO_PUMP_PATH = "/arduino-pump/";
const _REQ_TEMP_PATH = "/requested-temperature/";
const _SYSTEM_STATE_PATH = "/system-state/";
const _SYSTEM_STATE_VAR_PATH = "/system-state/state/";

enum AppState {
  noErrors,
  initalizing,
  failedConnectingToServer,
  timeoutServerConnection, // Currently not in use.
}

enum SystemState {
  noErrors,
  disabled,
  maintenance,
}

SystemState _systemStateByInt(int? state) {
  if (state == null) return SystemState.disabled;
  return SystemState.values[state];
}

class DbProvider extends ChangeNotifier {
  DbProvider() {
    _setup();
  }

  late final FirebaseDatabase _database;
  late final PoolData poolData;
  late final PumpData pumpData;
  late final ReqTempData reqTempData;

  AppState _appState = AppState.initalizing;
  SystemState _systemState = SystemState.disabled;

  AppState get appState => _appState;
  SystemState get systemState => _systemState;

  Future _setup() async {
    await Firebase.initializeApp().then((fbApp) {
      _database = FirebaseDatabase(app: fbApp);
    });

    await _loadInitalData();
  }

  Future _loadInitalData() async {
    try {
      final databaseRef = _database.reference();
      final dbRefPool = databaseRef.child(_ARDUINO_POOL_PATH);
      final dbRefPump = databaseRef.child(_ARDUINO_PUMP_PATH);
      final dbRefReqTemp = databaseRef.child(_REQ_TEMP_PATH);
      poolData = PoolData();
      pumpData = PumpData();
      reqTempData = ReqTempData(dbRefReqTemp);

      final sysStateInt = await databaseRef.child(_SYSTEM_STATE_VAR_PATH).get();
      final snapshotPool = await dbRefPool.get();
      final snapshotPump = await dbRefPump.get();
      final snapshotReqTemp = await dbRefReqTemp.get();
      poolData._setFromJSON(snapshotPool.value);
      pumpData._setFromJSON(snapshotPump.value);
      reqTempData._setFromJSON(snapshotReqTemp.value);
      _systemState = _systemStateByInt(sysStateInt.value);

      databaseRef.child(_ARDUINO_POOL_PATH).onChildChanged.listen((event) {
        poolData._onArduinoPoolUpdated(event);
        notifyListeners();
      });
      databaseRef.child(_ARDUINO_PUMP_PATH).onChildChanged.listen((event) {
        pumpData._onArduinoPumpUpdated(event);
        notifyListeners();
      });
      databaseRef.child(_REQ_TEMP_PATH).onChildChanged.listen((event) {
        reqTempData._onDbDataUpdated(event);
        notifyListeners();
      });
      databaseRef.child(_SYSTEM_STATE_PATH).onChildChanged.listen((event) {
        _onSystemStateUpdated(event);
        notifyListeners();
      });
      _appState = AppState.noErrors;
    } catch (error) {
      _appState = AppState.failedConnectingToServer;
    }
    notifyListeners();
  }

  void _onSystemStateUpdated(Event event) {
    _systemState = _systemStateByInt(event.snapshot.value);
  }

  Future retryLoadInitalData() async {
    _appState = AppState.initalizing;
    notifyListeners();

    await _loadInitalData();
  }
}

DateTime? _dateTimeByIntTimestamp(int? timestampInt) {
  if (timestampInt == null) return null;
  return DateTime.fromMillisecondsSinceEpoch(timestampInt);
}

String? _dateTimeFormatted(DateTime? date) {
  if (date == null) return null;
  return DateFormat('dd.MM.yyyy kk:mm').format(date);
}

const _ARPOOL_LAST_CONNECTION_KEY = "last-connection";
const _ARPOOL_LAST_UPDATE_KEY = "last-update";
const _ARPOOL_STATE_KEY = "state";
const _ARPOOL_TEMPERATURE_KEY = "temperature";

enum ArduinoPoolState {
  noErrors,
  failedReadingSensor,
  failedSettingTemp,
  failedReadingSysState,
}

ArduinoPoolState? _arduinoPoolStateByInt(int? state) {
  if (state == null) return null;
  return ArduinoPoolState.values[state];
}

class PoolData {
  PoolData();

  int? _lastUpdate;
  int? _lastConnection;
  int? _state;
  double? _temperature;

  double? get temperature => _temperature;
  int? get temperatureRounded {
    if (temperature == null) return null;
    return temperature!.round();
  }

  ArduinoPoolState? get state => _arduinoPoolStateByInt(_state);
  DateTime? get lastUpdate => _dateTimeByIntTimestamp(_lastUpdate);
  DateTime? get lastConnection => _dateTimeByIntTimestamp(_lastConnection);
  String? get lastUpdateFormatted => _dateTimeFormatted(lastUpdate);

  void _setFromJSON(Map<String, dynamic> json) {
    _lastUpdate = json[_ARPOOL_LAST_UPDATE_KEY];
    _lastConnection = json[_ARPOOL_LAST_CONNECTION_KEY];
    _state = json[_ARPOOL_STATE_KEY];
    _temperature = json[_ARPOOL_TEMPERATURE_KEY];
  }

  void _onArduinoPoolUpdated(Event event) {
    final key = event.snapshot.key;
    final value = event.snapshot.value;

    if (key == _ARPOOL_LAST_UPDATE_KEY) {
      _lastUpdate = value;
    } else if (key == _ARPOOL_STATE_KEY) {
      _state = value;
    } else if (key == _ARPOOL_TEMPERATURE_KEY) {
      _temperature = value;
    }
  }
}

const _ARPUMP_LAST_CONNECTION_KEY = "last-connection";
const _ARPUMP_LAST_UPDATE_KEY = "last-update";
const _ARPUMP_STATE_KEY = "state";
const _ARPUMP_ACTIVE_KEY = "active";

enum ArduinoPumpState {
  noErrors,
  failedReadingTemp,
  tempDataOutdated,
  failedReadingSysState,
}

ArduinoPumpState? _arduinoPumpStateByInt(int? state) {
  if (state == null) return null;
  return ArduinoPumpState.values[state];
}

class PumpData {
  PumpData();

  int? _lastUpdate;
  int? _lastConnection;
  int? _state;
  bool? _active;

  bool? get active => _active;
  ArduinoPumpState? get state => _arduinoPumpStateByInt(_state);
  DateTime? get lastUpdate => _dateTimeByIntTimestamp(_lastUpdate);
  DateTime? get lastConnection => _dateTimeByIntTimestamp(_lastConnection);
  String? get lastUpdateFormatted => _dateTimeFormatted(lastUpdate);

  void _setFromJSON(Map<String, dynamic> json) {
    _lastUpdate = json[_ARPUMP_LAST_UPDATE_KEY];
    _lastConnection = json[_ARPUMP_LAST_CONNECTION_KEY];
    _state = json[_ARPUMP_STATE_KEY];
    _active = json[_ARPUMP_ACTIVE_KEY];
  }

  void _onArduinoPumpUpdated(Event event) {
    final key = event.snapshot.key;
    final value = event.snapshot.value;

    if (key == _ARPUMP_LAST_UPDATE_KEY) {
      _lastUpdate = value;
    } else if (key == _ARPUMP_STATE_KEY) {
      _state = value;
    } else if (key == _ARPUMP_ACTIVE_KEY) {
      _active = value;
    }
  }
}

const _REQTEMP_LAST_UPDATE_KEY = "last-update";
const _REQTEMP_TEMPERATURE_KEY = "temperature";
const _REQTEMP_UPDATE_UID_KEY = "update-uid";

const MIN_TEMP = 0;
const MAX_TEMP = 40;

/// Temperature the requested temp is set to, when user wants to disable the pump.
/// Should be way under normal temperature values.
const _PUMP_DISABLED_TEMP = -100;

class ReqTempData {
  ReqTempData(this._dbRef);

  DatabaseReference _dbRef;
  int? _lastUpdate;
  int? _temperature;

  DateTime? get lastUpdate => _dateTimeByIntTimestamp(_lastUpdate);
  String? get lastUpdateFormatted => _dateTimeFormatted(lastUpdate);
  int? get temperature => _temperature;
  bool? get active => temperature != null ? temperature! >= MIN_TEMP : null;

  void _setFromJSON(Map<String, dynamic> json) {
    _lastUpdate = json[_ARPUMP_LAST_UPDATE_KEY];
    _temperature = json[_REQTEMP_TEMPERATURE_KEY];
  }

  Future<bool> setTemperature(UserProvider users, int temperature) async {
    if (!users.isSignedIn) {
      throw StateError("Temperature can only be changed when logged in.");
    }
    if (temperature > MAX_TEMP) {
      throw ArgumentError("Requested temperature must be <= $MAX_TEMP.");
    }
    if (temperature < MIN_TEMP) {
      temperature = _PUMP_DISABLED_TEMP;
    }

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      await _dbRef.update({
        _REQTEMP_LAST_UPDATE_KEY: timestamp,
        _REQTEMP_TEMPERATURE_KEY: temperature,
        _REQTEMP_UPDATE_UID_KEY: users.user!.uid,
      });
    } catch (_) {
      return false;
    }
    return true;
  }

  void _onDbDataUpdated(Event event) {
    final key = event.snapshot.key;
    final value = event.snapshot.value;

    if (key == _REQTEMP_LAST_UPDATE_KEY) {
      _lastUpdate = value;
    } else if (key == _REQTEMP_TEMPERATURE_KEY) {
      _temperature = value;
    }
  }
}
