#include "constants.h"

void setup() {
  Serial.begin(9600);

  setupErrorCode();
  setupTempSensor();

  while (connectToWifi() < 0) {
    setErrorCode(FAILED_CONNECTING_TO_WIFI);
  }
  while (setupFirebase() < 0) {
    setErrorCode(FAILED_CONNECTING_TO_FIREBASE);
  }
}

void loop() {
  Serial.println("=== HEARTBEAT ===");
  while (!wifiIsConnected()) {
    connectToWifi();
    setErrorCode(FAILED_CONNECTING_TO_WIFI);
  }

  if (getSystemState() == SYSTEM_STATE_OFF) {
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
    setErrorCode(FAILED_SET_TEMP);
  } else {
    setArduinoPoolState(NO_ERRORS_STATE);
  }
}

void resetArduinoState() {
  int arduinoPoolState = getArduinoPoolState();
  if (arduinoPoolState > 0) {
    
  }
}
