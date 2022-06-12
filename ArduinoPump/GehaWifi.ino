#include <SPI.h>
#include <WiFiNINA.h>

#include "secrets.h"
char ssid[] = WIFI_SSID;
char pass[] = WIFI_PASS;

int connectToWifi() {
  if (WiFi.status() == WL_NO_MODULE) {
    Serial.println("Communication with WiFi module failed!");
    return -1;
  }

  Serial.print("Attempting to connect to WPA SSID: ");
  Serial.println(ssid);
  for (int i = 0; i < 3; i++) {
    WiFi.begin(ssid, pass);
    if (wifiIsConnected()) break;
  }

  if (wifiIsConnected()) {
    WiFi.lowPowerMode();
    Serial.print("You're connected to the network.");
    printWifiData();
  } else {
    Serial.println("Failed connecting to network!");
    return -1;
  }
  return 0;
}

bool wifiIsConnected() {
  return (WiFi.status() == WL_CONNECTED);
}

int reconnectToWifi() {
  WiFi.end();
  return connectToWifi();
}

void printWifiData() {
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);
  Serial.println(ip);

  byte mac[6];
  WiFi.macAddress(mac);
  Serial.print("MAC address: ");
  printMacAddress(mac);

  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI):");
  Serial.println(rssi);

  Serial.println("");
}


void printMacAddress(byte mac[]) {
  for (int i = 5; i >= 0; i--) {
    if (mac[i] < 16) {
      Serial.print("0");
    }
    Serial.print(mac[i], HEX);
    if (i > 0) {
      Serial.print(":");
    }
  }
  Serial.println();
}
