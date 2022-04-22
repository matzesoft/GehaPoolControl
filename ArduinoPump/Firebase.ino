#include <WiFiNINA.h>
#include "Firebase_Arduino_WiFiNINA.h"
#include "secrets.h"

FirebaseData firebaseData;

String arduinoPumpPath = "/arduino-pump/";
String arduinoPoolPath = "/arduino-pool/";
String systemStatePath = "/system-state/";
String requestedTemperaturePath = "/requested-temperature/";

int setupFirebase(void) {
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH, WIFI_SSID, WIFI_PASS);
}

int getSystemState(void) {
  return getIntFromFB(systemStatePath + "state", -1);
}

int getArduinoPumpState(void) {
  return getIntFromFB(arduinoPumpPath + "state", -1);
}

int getArduinoPoolState(void) {
  return getIntFromFB(arduinoPoolPath + "state", -1);
}

double getPoolTemperature(void) {
  return getTemperatureFromFB(arduinoPoolPath + "temperature", -127.0);
}

double getRequestedTemperature(void) {
  return getTemperatureFromFB(requestedTemperaturePath + "temperature", -127.0);
}

unsigned long long getArduinoPoolLastUpdate(void) {
  return getTimestampFromFB(arduinoPoolPath + "last-update");
}

unsigned long long getCurrentTimestamp(void) {
  if (!Firebase.setTimestamp(firebaseData, "current-timestamp")) {
    return -1;
  }
  return getTimestampFromFB("current-timestamp");
}

double getTemperatureFromFB(String path, double errorValue) {
  if (Firebase.getDouble(firebaseData, path)) {
    return firebaseData.doubleData();
  } else {
    Serial.print("Unable to read float from: ");
    Serial.println(path);
    Serial.println(firebaseData.errorReason());
  }
  return errorValue;
}

int getIntFromFB(String path, int errorValue) {
  if (Firebase.getInt(firebaseData, path)) {
    if (firebaseData.dataType() == "int") {
      return firebaseData.intData();
    }
  } else {
    Serial.print("Unable to read int from: ");
    Serial.println(path);
    Serial.println(firebaseData.errorReason());
  }
  return errorValue;
}

unsigned long long getTimestampFromFB(String path) {
  if (Firebase.getInt(firebaseData, path)) {
    if (firebaseData.dataType() == "uint64") {
      return firebaseData.uint64Data();
    }
  } else {
    Serial.print("Unable to read timestamp from: ");
    Serial.println(path);
    Serial.println(firebaseData.errorReason());
    return 0;
  }
}

int setPumpActive(bool value) {
  if (!Firebase.setBool(firebaseData, arduinoPumpPath + "active", value)) {
    Serial.print("Unable to set pump active: ");
    Serial.println(firebaseData.errorReason());
    return -1;
  } else if (!setLastUpdate()) {
    return -1;
  }
  return 0;
}

int setLastUpdate(void) {
  if (!Firebase.setTimestamp(firebaseData, arduinoPumpPath + "last-update")) {
    Serial.print("Unable to set pool temp timestamp. ");
    Serial.println(firebaseData.errorReason());
    return -1;
  }
  return 0;
}

int setArduinoPumpState(int state) {
  if (!Firebase.setInt(firebaseData, arduinoPumpPath + "state", state)) {
    Serial.print("Unable to set Arduino state: ");
    Serial.println(firebaseData.errorReason());
    return -1;
  }
  return 0;
}

int setArduinoPoolState(int state) {
  if (!Firebase.setInt(firebaseData, arduinoPoolPath + "state", state)) {
    Serial.print("Unable to set ArduinoPool state: ");
    Serial.println(firebaseData.errorReason());
    return -1;
  }
  return 0;
}
