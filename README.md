# GehaPoolControl
GehaPoolControl is a temperature control system designed for managing the temperature of a private swimming pool. It leverages Arduino-based hardware and a dashboard built with Flutter Web.

To control the temperature of the pool, there is a heat pump at a phsically seperated location. This pump can be turned on and off but doesn't enable to choose a temperature. Before this system was implemented, it was necessary to turn the pump on and off manually. Now the system messeaures the temperature of the pool and enables and disables the pump based on that data.

The dashboard can be accessed at [geha-pool.web.app](http://geha-pool.web.app).

## Architecture
The system contains of four components: Two Arduinos, a Firebase Server and a Flutter Webapp.

```
          [ Flutter Webapp ]

                  |
                  |

         [ Firebase Server ] 

         /                \
        /                  \

[ Arduino Pool ]     [ Arduino Pump ]
```

The _Arduino Pool_ sends the temperature data to the Firebase Server. The _Arduino Pump_ reads the **requested** and the **current** temperature and controls the heat pump based on that. The _Firebase Server_ stores the data and hosts the _Flutter Webapp_. The _Flutter Webapp_ allows to read the current temperature, if the head pump is turned on and to change the requested temperature.

## Hardware
**Arduinos:** Arduino Nano 33 IoT ([amazon.de](https://www.amazon.de/gp/product/B07WPFQZQ1/)) \
**Temperature Sensor:** AZDelivery DS18B20 ([amazon.de](https://www.amazon.de/gp/product/B07CZ1G29V/))
