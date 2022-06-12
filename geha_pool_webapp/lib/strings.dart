class Strings {
  static String get poolTemperature => _STRINGS['pool_temperature']!;
  static String get lastUpdate => _STRINGS['last_update']!;
  static String get errorReadingTempData =>
      _STRINGS['error_reading_temp_data']!;
  static String get errorReadingPumpData =>
      _STRINGS['error_reading_pump_data']!;
  static String get pumpActive => _STRINGS['pump_active']!;
  static String get pumpInactive => _STRINGS['pump_inactive']!;
  static String get lastUpdateUnknown => _STRINGS['last_update_unknown']!;
  static String get systemIsDisabled => _STRINGS['system_is_disabled']!;
  static String get systemIsInMaintenance =>
      _STRINGS['system_is_in_maintenance']!;
  static String get requestedTemperature => _STRINGS['requested_temperature']!;
  static String get noRequestedTemperature =>
      _STRINGS['no_requested_temperature']!;
  static String get changeTemperature => _STRINGS['change_temperature']!;
  static String get logIn => _STRINGS['log_in']!;
  static String get email => _STRINGS['email']!;
  static String get password => _STRINGS['password']!;
  static String get logInFailed => _STRINGS['log_in_failed']!;
  static String get cancel => _STRINGS['cancel']!;
  static String get next => _STRINGS['next']!;
  static String get setRequestedTemperature =>
      _STRINGS['set_requested_temperature']!;
  static String get failedChangingReqTemp =>
      _STRINGS['failed_changing_reg_temp']!;
  static String get save => _STRINGS['save']!;
  static String get failedReadingTempSensor =>
      _STRINGS['failed_reading_temp_sensor']!;
  static String get failedSettingTemp => _STRINGS['failed_setting_temp']!;
  static String get failedReadingTemp => _STRINGS['failed_reading_temp']!;
  static String get tempDataOutdated => _STRINGS['temp_data_outdated']!;
  static String get connectToServer => _STRINGS['connect_to_server']!;
  static String get failedConnectingToServer =>
      _STRINGS['failed_connecting_to_server']!;
  static String get failedConnectingToServerDueTimeout =>
      _STRINGS['failed_connecting_to_server_due_timeout']!;
  static String get failedReadingSysStatePool =>
      _STRINGS['failed_reading_sys_state_pool']!;
  static String get failedReadingSysStatePump =>
      _STRINGS['failed_reading_sys_state_pump']!;
  static String get tryAgain => _STRINGS['try_again']!;
}

const _STRINGS = {
  "pool_temperature": "Pooltemperatur",
  "last_update": "Zuletzt aktualisiert: ",
  "error_reading_temp_data": "Keine aktuellen Temperatur-Daten lesbar.",
  "error_reading_pump_data": "Keine aktuellen Wärmepumpe-Daten lesbar.",
  "pump_active": "Wärmepumpe an",
  "pump_inactive": "Wärmepumpe aus",
  "last_update_unknown": "Letzte Aktualisierung der Daten unbekannt.",
  "system_is_disabled": "Das System ist deaktiviert.",
  "system_is_in_maintenance": "Das System ist in Wartung.",
  "requested_temperature": "Wunschtemperatur",
  "no_requested_temperature": "Keine Wunschtemperatur festgelegt.",
  "change_temperature": "Temperatur ändern",
  "log_in": "Anmelden",
  "email": "E-Mail:",
  "password": "Passwort:",
  "log_in_failed": "Anmeldung fehlgeschlagen",
  "cancel": "Abbrechen",
  "next": "Weiter",
  "save": "Speichern",
  "set_requested_temperature": "Stelle die Wunschtemperatur ein.",
  "failed_changing_reg_temp":
      "Wunschtemperatur konnte nicht geändert werden :/",
  "failed_reading_temp_sensor":
      "Aktuell können keine Temperaturwerte über den Sensor ausgelesen werden.",
  "failed_setting_temp":
      "Aktuell kann die Temperatur des Pools nicht aktualisiert werden.",
  "failed_reading_temp":
      "Aktuell gibt es einen Fehler beim Abrufen der Pooltemperatur.",
  "temp_data_outdated":
      "Aufgrund veralteter Temperaturdaten wurde die Pumpe deaktiviert.",
  "connect_to_server": "Verbindung mit Server...",
  "failed_connecting_to_server": "Verbindung mit Server fehlgeschlagen",
  "failed_connecting_to_server_due_timeout":
      "Zeitüberschreitung bei Verbindung mit Server",
  "failed_reading_sys_state_pool":
      "Da der System-Status nicht gelesen werden kann, wird die Temperatur nicht aktualisiert.",
  "failed_reading_sys_state_pump":
      "Da der System-Status nicht gelesen werden kann, wurde die Pumpe deaktiviert.",
  "try_again": "Erneut versuchen"
};
