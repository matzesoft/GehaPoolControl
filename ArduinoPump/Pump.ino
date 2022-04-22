#define PUMP_PIN 4

void setupPump(void) {
  pinMode(PUMP_PIN, OUTPUT);
  disablePump();
}

void activatePump(void) {
  digitalWrite(PUMP_PIN, HIGH);
  setPumpActive(true);
}

void disablePump(void) {
  digitalWrite(PUMP_PIN, LOW);
  setPumpActive(false);
}

bool pumpIsActive(void) {
  Serial.print("digitiakRead Pump pin: ");
  Serial.println(digitalRead(PUMP_PIN));
  return (digitalRead(PUMP_PIN) == HIGH);
}
