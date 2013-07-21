homeFlux
========
Created by Ben Oxley, Jordan Rogers-Smith, Marcello Seri and James Jackson
--------------------------------------------------------------------------

![smexyLightswitch](http://benoxley.co.uk/wp-content/uploads/2012/06/20120427162844_15s.jpg)

**Your home, more relaxing. Saving polar bears.**

homeFlux is unique. It balances interior lighting with natural light levels to maintain a constant room brightness and adapts the colour temperature to match the time of day. homeFlux saves energy by ensuring that only the minimum amount of light is supplied when it is required by measuring the light levels in the room in real time. The smart control allows the user to set a desired intensity level and a feedback loop between the natural light, light sensor and hue lights adjust to match that brightness. As well as brightness matching the homeFlux changes the rooms colour temperature as the sun goes down and comes up, 

![smexyLightswitch](http://f.cl.ly/items/2k1N0r1R2d1l2o260U2u/Screen%20Shot%202013-07-21%20at%2011.10.41.png)

providing a relaxing transition to a soothing evening light that can aid in sleep (the original flux is based on alot of research into this stuff http://justgetflux.com/research.html)

The smart control also makes it possible to introduce extra functionality into the lighting system, advanced features can be programmed into the system, such as automatic on/off times which can help increase home security. The product can be installed in any room with natural lighting in domestic and commercial environments. The intelligent light switch can save up to 80% of power usage, with an average of 40% (assuming that lights are left on during occupancy) [1]. The light switch also ensures that working conditions are kept stable and there is always plenty of light available in a room. 

**Technology**

Homeflux is designed as a first prototype to read light in a room and serve a touchscreen display via an Arduino as a type of digital light switch. It interfaces with any Linux distribution via an emulated serial port at 9600 Baud, 8n1 and runs a ruby script which sends HTTP Put requests to the Philips Hue bridge.
 
The Arduino maintains the light levels in the room, regardless of the outside sunlight  by measuring the room light values and implementing a PI closed loop control. In addition the ruby script geolocates itself and adapts the lighting conditions in the room to create a relaxed evening atmosphere. It changes the colour temperature of the light, whilst the intensity is controlled by the Arduino. 
   
**This all results in a energy efficient, money saving and super life improving system.**

It's always possible that some extra information may be found at: [benoxley.com](http://benoxley.com/ "benoxley.com")

[1]	Ying-Wen Bai and Yi-Te Ku, "AUTOMATIC ROOM LIGHT INTENSITY DETECTION AND CONTROL USING A MICROPROCESSOR AND LIGHT SENSORS," Department of Electronic Engineering, Fu Jen Catholic University, Taiwan,.

