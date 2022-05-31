#define PUMP_PIN 4

void setupPump(void) {
  pinMode(PUMP_PIN, OUTPUT);
  digitalWrite(PUMP_PIN, LOW);
}

void activatePump(void) {
  Serial.println("Pump will be enabled.");
  digitalWrite(PUMP_PIN, HIGH);
  setPumpActive(true);
}

void disablePump(void) {
  Serial.println("Pump will be disabled.");
  digitalWrite(PUMP_PIN, LOW);
  setPumpActive(false);
}

bool pumpIsActive(void) {
  return (digitalRead(PUMP_PIN) == HIGH);
}
