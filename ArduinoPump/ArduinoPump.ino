#include "constants.h"

void setup() {
  Serial.begin(9600);
  setupErrorCode();

  while (connectToWifi() < 0) {
    setErrorCode(CONNECTION_ERROR);
  }
  while (setupFirebase() < 0) {
    setErrorCode(CONNECTION_ERROR);
  }

  setupPump();
}

void loop() {
  while (!wifiIsConnected()) {
    connectToWifi();
    setErrorCode(CONNECTION_ERROR);
  }

  if (getSystemState() == SYSTEM_STATE_OFF) {
    Serial.println("Pool control is system-wide off.");
    disablePump();
  } else {
    bool arduinoPoolReachable = checkArduinoPoolState();

    if (!arduinoPoolReachable) {
      Serial.println("ArduinoPool not reachable. Disableing pump.");
      disablePump();
      resetArduinoState();
    } else {
      double poolTemp = getPoolTemperature();
      double requestedTemp = getRequestedTemperature();

      if (poolTemp <= -127.0 || requestedTemp <= -127.0) {
        Serial.println("Failed reading temperatures from server.");
        //TODO: Look after correct error codes
        setArduinoPumpState(CONTROL_ERROR);
        setErrorCode(CONTROL_ERROR);
      } else {
        resetArduinoState();
        controlPump(poolTemp, requestedTemp);
      }
    }
  }

  delay(HEARTBEAT_IN_MS);
}

void resetArduinoState() {
  int arduinoPumpState = getArduinoPumpState();
  if (arduinoPumpState > 0) {
    setArduinoPumpState(0);
  }
}

void controlPump(double poolTemp, double requestedTemp) {
  Serial.print("poolTemp: ");
  Serial.println(poolTemp);

  Serial.print("requestedTemp: ");
  Serial.println(requestedTemp);

  if (pumpIsActive()) {
    Serial.println("Pump is active");
    if ((requestedTemp + 1) <= poolTemp) {
      disablePump();
    } else {
      setLastUpdate();
    }
  } else {
    Serial.println("Pump is inactive");
    if ((requestedTemp - 1) >= poolTemp) {
      activatePump();
    } else {
      setLastUpdate();
    }
  }
}

bool checkArduinoPoolState(void) {
  unsigned long long currentTimestamp = getCurrentTimestamp();
  unsigned long long arduinoPoolLastUpdate = getArduinoPoolLastUpdate();

  if (currentTimestamp > 0 && arduinoPoolLastUpdate > 0) {
    int arduinoPoolState = getArduinoPoolState();

    if ((currentTimestamp - arduinoPoolLastUpdate) > DATA_TO_OLD_DIF) {
      if (arduinoPoolState != ARDUINO_NOT_REACHABLE_ERROR) {
        setArduinoPoolState(ARDUINO_NOT_REACHABLE_ERROR);
      }
      return false;
    } else {
      if (arduinoPoolState == ARDUINO_NOT_REACHABLE_ERROR) {
        setArduinoPoolState(0);
      }
      return true;
    }
  }
  return false;
}
