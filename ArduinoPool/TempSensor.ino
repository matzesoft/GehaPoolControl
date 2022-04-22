#include <OneWire.h>
#include <DallasTemperature.h>

// Data wire is conntec to the Arduino digital pin 4
#define ONE_WIRE_BUS 4

OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

void setupTempSensor(void) {
  sensors.begin();
}

// If output value is <= -127 the measurement failed.
double getTempInC(void) {
  sensors.requestTemperatures();
  return sensors.getTempCByIndex(0); 
}
