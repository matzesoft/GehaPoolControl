#define PUMP_PIN 4

bool pumpEnabled = false;

void setupPump(void) {
  pinMode(PUMP_PIN, OUTPUT);
  disablePump();
}

void activatePump(void) {
  digitalWrite(PUMP_PIN, HIGH);
  pumpEnabled = true;
  setPumpOnOff(true);
  Serial.println("Pump is enabled.");
}

void disablePump(void) {
  digitalWrite(PUMP_PIN, LOW);
  pumpEnabled = false;
  setPumpOnOff(false);
  Serial.println("Pump is disabled.");
}

bool pumpIsEnabled(void) {
  return pumpEnabled;
}
