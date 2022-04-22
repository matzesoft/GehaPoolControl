class Strings {
  static String get poolHasTemperature => _STRINGS['pool_has_temperature']!;
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
  static String get requestedTemperatureIs =>
      _STRINGS['requested_temperature_is']!;
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
}

const _STRINGS = {
  "pool_has_temperature": "Der Pool hat aktuell ",
  "last_update": "Zuletzt aktualisiert: ",
  "error_reading_temp_data": "Keine aktuellen Temperatur-Daten lesbar.",
  "error_reading_pump_data": "Keine aktuellen Wärmepumpe-Daten lesbar.",
  "pump_active": "Die Wärmepumpe ist aktiv.",
  "pump_inactive": "Die Wärmepumpe ist inaktiv.",
  "last_update_unknown": "Letzte Aktualisierung der Daten unbekannt.",
  "system_is_disabled": "Das System ist deaktiviert.",
  "system_is_in_maintenance": "Das System ist in Wartung.",
  "requested_temperature_is": "Die Wunschtemperatur liegt bei ",
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
  "failed_changing_reg_temp": "Wunschtemperatur konnte nicht geändert werden :/"
};
