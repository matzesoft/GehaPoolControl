
void setupErrorCode(void) {
  pinMode(LED_BUILTIN, OUTPUT);
}

void setErrorCode(int code) {
  for (int i = 0; i < code; i++) {
    digitalWrite(LED_BUILTIN, HIGH);
    delay(300);
    digitalWrite(LED_BUILTIN, LOW);
    delay(300);
  }
  delay(1500);
}
