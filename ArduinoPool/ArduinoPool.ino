#include "constants.h"

void setup() {
  Serial.begin(9600);

  setupErrorCode();
  setupTempSensor();

  while (connectToWifi() < 0) {
    setErrorCode(CONNECTION_ERROR);
  }
  while (setupFirebase() < 0) {
    setErrorCode(CONNECTION_ERROR);
  }
}

void loop() {
  while (!wifiIsConnected()) {
    connectToWifi();
    setErrorCode(CONNECTION_ERROR);
  }

  if (getSystemState() == SYSTEM_STATE_OFF) {
    Serial.println("Pool control is deactivated by server.");
  } else {
    checkArduinoPumpState();

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

  delay(HEARTBEAT_IN_MS);
}

void onTempReadFailed(void) {
  Serial.println("Failed reading temperature.");
  removeOldestTemperature();
  setErrorCode(FAILED_READ_TEMP);
  setArduinoPoolState(FAILED_READ_TEMP);
}

void onTempReadSucess(float temp) {
  int arduinoPoolState = getArduinoPoolState();
  if (arduinoPoolState > 0) {
    setArduinoPoolState(0);
  }

  setTemperature(temp);
  float finalTemp = getTemperature();
  Serial.print("Final pool temp: ");
  Serial.println(finalTemp);
  if (setPoolTemp(finalTemp) < 0) {
    setErrorCode(CONNECTION_ERROR);
  }
}

void checkArduinoPumpState(void) {
  unsigned long long currentTimestamp = getCurrentTimestamp();
  unsigned long long arduinoPumpLastUpdate = getArduinoPumpLastUpdate();

  if (currentTimestamp > 0 && arduinoPumpLastUpdate > 0) {
    int arduinoPumpState = getArduinoPumpState();

    if ((currentTimestamp - arduinoPumpLastUpdate) > DATA_TO_OLD_DIF) {
      if (arduinoPumpState != ARDUINO_NOT_REACHABLE_ERROR) {
        setArduinoPumpState(ARDUINO_NOT_REACHABLE_ERROR);
      }
    } else {
      if (arduinoPumpState == ARDUINO_NOT_REACHABLE_ERROR) {
        setArduinoPumpState(0);
      }
    }
  }
}
