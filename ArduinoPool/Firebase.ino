#include <WiFiNINA.h>
#include "Firebase_Arduino_WiFiNINA.h"
#include "secrets.h"

FirebaseData firebaseData;

String arduinoPoolPath = "/arduino-pool/";
String arduinoPumpPath = "/arduino-pump/";
String systemStatePath = "/system-state/";

int setupFirebase(void) {
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH, WIFI_SSID, WIFI_PASS);
}

int getSystemState(void) {
  return getInt(systemStatePath + "state", -1);
}

int getArduinoPoolState(void) {
  return getInt(arduinoPoolPath + "state", -1);
}

int getArduinoPumpState(void) {
  return getInt(arduinoPumpPath + "state", -1);
}

unsigned long long getArduinoPumpLastUpdate(void) {
  return getTimestamp(arduinoPumpPath + "last-update");
}

unsigned long long getCurrentTimestamp(void) {
  if (!Firebase.setTimestamp(firebaseData, "current-timestamp")) {
    return -1;
  }
  return getTimestamp("current-timestamp");
}

int getInt(String path, int errorValue) {
  if (Firebase.getInt(firebaseData, path)) {
    if (firebaseData.dataType() == "int") {
      return firebaseData.intData();
    }
  } else {
    Serial.print("Unable to read int from: ");
    Serial.println(path);
    Serial.println(firebaseData.errorReason());
    return errorValue;
  }
}

unsigned long long getTimestamp(String path) {
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

int setPoolTemp(float value) {
  if (!Firebase.setFloat(firebaseData, arduinoPoolPath + "temperature", value)) {
    Serial.print("Unable to set pool temperature: ");
    Serial.println(firebaseData.errorReason());
    return -1;
  } else if (!Firebase.setTimestamp(firebaseData, arduinoPoolPath + "last-update")) {
    Serial.print("Unable to set pool temp timestamp. ");
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

int setArduinoPumpState(int state) {
  if (!Firebase.setInt(firebaseData, arduinoPumpPath + "state", state)) {
    Serial.print("Unable to set ArduinoPump state: ");
    Serial.println(firebaseData.errorReason());
    return -1;
  }
  return 0;
}
