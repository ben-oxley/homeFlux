homeFlux
========
Created by Ben Oxley, Jordan Rogers-Smith, Marcello Seri and James Jackson
--------------------------------------------------------------------------

![smexyLightswitch](http://benoxley.co.uk/wp-content/uploads/2012/06/20120427162844_15s.jpg)

Creating a lighting solution for energy efficiency and wellbeing to work with Philips Hue lighting systems.

Homeflux is designed as a first prototype to read light in a room and serve a touchscreen display via an Arduino as a type of digital light switch.
 
 It interfaces with any Linux distribution via an emulated serial port at 9600 Baud, 8n1 and runs a ruby script which sends HTTP Put requests to the Philips Hue bridge.
 
 The Arduino maintains the light levels in the room, regardless of the outside sunlight  by measuring the room light values and implementing a PI closed loop control.
  
 In addition the ruby script geolocates itself and adapts the lighting conditions in the room to create a relaxed evening atmosphere. It changes the colour temperature of the light, whilst the intensity is controlled by the Arduino. 
   
**This all results in a energy efficient, money saving and super life improving system.**

It's always possible that some extra information may be found at: [benoxley.com](http://benoxley.com/ "benoxley.com")