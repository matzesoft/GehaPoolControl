#define TEMPS_SIZE 4

int currentIndex = 0;
float temps[TEMPS_SIZE] = { -127.0, -127.0, -127.0, -127.0};

float getTemperature(void) {
  int count = 0;
  float temp = -127.0;
  for (int i = 0; i < TEMPS_SIZE; i++) {
    Serial.print("Temp: ");
    Serial.println(temps[i]);
    if (temps[i] > -127.0) {
      if (temp <= -127.0) {
        temp = temps[i];
      } else {
        temp += temps[i];
      }
      count += 1;
    }
  }
  return (temp / count);
}

void setTemperature(float temp) {
  temps[currentIndex] = temp;

  currentIndex += 1;
  if (currentIndex >= TEMPS_SIZE) {
    currentIndex = 0;
  }
}

void removeOldestTemperature(void) {
  temps[currentIndex] = -127;
}
