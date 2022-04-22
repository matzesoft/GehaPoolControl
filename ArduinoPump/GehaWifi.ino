#include <SPI.h>
#include <WiFiNINA.h>

#include "secrets.h"
char ssid[] = WIFI_SSID;
char pass[] = WIFI_PASS;
int status = WL_IDLE_STATUS;

int connectToWifi() {
  if (WiFi.status() == WL_NO_MODULE) {
    Serial.println("Communication with WiFi module failed!");
    return -1;
  }

  Serial.print("Attempting to connect to WPA SSID: ");
  Serial.println(ssid);
  for (int i = 0; i < 8; i++) {
    status = WiFi.begin(ssid, pass);
    if (status == WL_CONNECTED) {
      break;
    }
    delay(1000);
  }

  if (status == WL_CONNECTED) {
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
