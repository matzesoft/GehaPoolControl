#include "constants.h"

void setup() {
  Serial.begin(9600);

  setupErrorCode();
  setupTempSensor();

  while (connectToWifi() < 0) {
    setErrorCode(FAILED_CONNECTING_TO_WIFI_LED_COUNT);
  }
  while (setupFirebase() < 0) {
    setErrorCode(FAILED_CONNECTING_TO_FIREBASE_LED_COUNT);
  }
}

void loop() {
  Serial.println("=== HEARTBEAT ===");

  int connectToWifiTrys = 0;
  while (!wifiIsConnected()) {
    setErrorCode(FAILED_CONNECTING_TO_WIFI_LED_COUNT);

    connectToWifiTrys += 1;
    if (connectToWifiTrys > CONNECT_WIFI_TRYS_MAX) {
      delay(10000);
      reconnectToWifi();
    } else {
      connectToWifi();
    }
  }


  int systemState = getSystemState();
  int rdSTrys = 1;
  while (systemState < 0) {
    delay(1500 * rdSTrys);

    systemState = getSystemState();
    Serial.print("System state: ");
    Serial.println(systemState);
    if (systemState >= 0) break;
    rdSTrys += 1;

    if (rdSTrys > READ_SYSTEM_STATE_TRYS_MAX) {
      Serial.println("'Read system state' max reached. Try reconnecting to Wifi...");
      setArduinoPoolState(FAILED_READ_SYSTEM_STATE);

      if (reconnectToWifi() < 0) {
        Serial.println("Failed reconnecting to Wifi!");
      } else {
        Serial.println("Reconnecting to Wifi sucessfull.");
      }
      break;
    }
  }

  if (systemState >= 0) {
    if (systemState == SYSTEM_STATE_OFF) {
      Serial.println("Pool control is deactivated by server.");
      setArduinoPoolState(NO_ERRORS_STATE);
    } else {
      for (int i = 0; i < 5; i++) {
        float temp = getTempInC();
        if ((temp > TEMP_UNABLE_LOW) && (temp < TEMP_UNABLE_HIGH)) {
          onTempReadSucess(temp);
          break;
        } else if (i >= 4) {
          onTempReadFailed();
        }
      }
    }
    setLastConnection();
    delay(HEARTBEAT_IN_MS);
  }
}

void onTempReadFailed(void) {
  Serial.println("Failed reading temperature sensor.");
  removeOldestTemperature();
  setArduinoPoolState(FAILED_READ_SENSOR);
}

void onTempReadSucess(float temp) {
  setTemperature(temp);
  float finalTemp = getTemperature();
  Serial.print("Final pool temp: ");
  Serial.println(finalTemp);
  if (setPoolTemp(finalTemp) < 0) {
    setArduinoPoolState(FAILED_SET_TEMP);
  } else {
    setArduinoPoolState(NO_ERRORS_STATE);
  }
}
