#define PUMP_PIN 4

bool pumpEnabled = false;

void setupPump(void) {
  pinMode(PUMP_PIN, OUTPUT);
  disablePump();
}

void activatePump(void) {
  Serial.println("Pump will be enabled.");
  digitalWrite(PUMP_PIN, HIGH);
  pumpEnabled = true;
  setPumpActive(true);
}

void disablePump(void) {
  Serial.println("Pump will be disabled.");
  digitalWrite(PUMP_PIN, LOW);
  pumpEnabled = false;
  setPumpActive(false);
}

bool pumpIsEnabled(void) {
  return pumpEnabled;
}
