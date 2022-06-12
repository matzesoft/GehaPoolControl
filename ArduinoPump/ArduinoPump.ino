#include "constants.h"

void setup() {
  Serial.begin(9600);
  setupErrorCode();

  while (connectToWifi() < 0) {
    setErrorCode(FAILED_CONNECTING_TO_WIFI_LED_COUNT);
  }
  while (setupFirebase() < 0) {
    setErrorCode(FAILED_CONNECTING_TO_FIREBASE_LED_COUNT);
  }

  setupPump();
}

void loop() {
  Serial.println("=== HEARTBEAT ===");

  int connectToWifiTrys = 0;
  while (!wifiIsConnected()) {
    setErrorCode(FAILED_CONNECTING_TO_WIFI_LED_COUNT);

    connectToWifiTrys += 1;
    if (connectToWifiTrys == CONNECT_WIFI_TRYS_MAX) {
      Serial.println("'Connect to wifi' max reached.");
      disablePump();
    }

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
      disablePump();
      setArduinoPumpState(FAILED_READ_SYSTEM_STATE);
      
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
      Serial.println("Pool control is system-wide off.");
      disablePump();
      setArduinoPumpState(NO_ERRORS_STATE);
    } else if (systemState == SYSTEM_STATE_NO_ERRORS) {
      bool arduinoPoolReachable = checkArduinoPoolLastConnection();

      if (!arduinoPoolReachable) {
        Serial.println("ArduinoPool not reachable. Disableing pump.");
        disablePump();
        setArduinoPumpState(TEMP_DATA_OUTDATED);
      } else {
        double poolTemp = getPoolTemperature();
        double requestedTemp = getRequestedTemperature();

        if (poolTemp <= -127.0 || requestedTemp <= -127.0) {
          Serial.println("Failed reading temperatures from server.");
          disablePump();
          setArduinoPumpState(FAILED_READ_TEMP);
        } else {
          controlPump(poolTemp, requestedTemp);
          setArduinoPumpState(NO_ERRORS_STATE);
        }
      }
    }
    setLastConnection();
    delay(HEARTBEAT_IN_MS);
  }
}

void controlPump(double poolTemp, double requestedTemp) {
  Serial.print("poolTemp: ");
  Serial.println(poolTemp);

  Serial.print("requestedTemp: ");
  Serial.println(requestedTemp);

  if (pumpIsEnabled()) {
    if ((requestedTemp + 1) <= poolTemp) {
      disablePump();
    } else {
      activatePump();
    }
  } else {
    if ((requestedTemp - 1) >= poolTemp) {
      activatePump();
    } else {
      disablePump();
    }
  }
}

bool checkArduinoPoolLastConnection(void) {
  unsigned long long currentTimestamp = getCurrentTimestamp();
  unsigned long long arduinoPoolLastUpdate = getArduinoPoolLastUpdate();

  if (currentTimestamp > 0 && arduinoPoolLastUpdate > 0) {
    if ((currentTimestamp - arduinoPoolLastUpdate) <= DATA_TO_OLD_DIF) {
      return true;
    }
  }
  return false;
}
