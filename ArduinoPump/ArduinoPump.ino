#include "constants.h"

void setup() {
  Serial.begin(9600);
  setupErrorCode();
  setupPump();

  // TODO: Make clear on boot whats wrong
  while (connectToWifi() < 0) {}
  while (setupFirebase() < 0) {}
}

void loop() {
  Serial.println("=== HEARTBEAT ===");
  while (!wifiIsConnected()) {
    connectToWifi();
  }

  if (getSystemState() == SYSTEM_STATE_OFF) {
    Serial.println("Pool control is system-wide off.");
    disablePump();
    setArduinoPumpState(NO_ERRORS_STATE);
  } else {
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

void controlPump(double poolTemp, double requestedTemp) {
  Serial.print("poolTemp: ");
  Serial.println(poolTemp);

  Serial.print("requestedTemp: ");
  Serial.println(requestedTemp);

  if (pumpIsActive()) {
    Serial.println("Pump is active.");
    if ((requestedTemp + 1) <= poolTemp) {
      disablePump();
    }
  } else {
    Serial.println("Pump is inactive.");
    if ((requestedTemp - 1) >= poolTemp) {
      activatePump();
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
