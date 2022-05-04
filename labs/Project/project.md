
# Digital clock

### Team members

* Petr Vaněk (responsible for alarm setter,clock setter)
* https://github.com/petrvaneek/de1
* František Štefkovič (responsible for design of schematic and button debouncer, divider,top)
* https://github.com/FrantisekStefkovic2/digital-electronics-1
* Šimon Špánik (responsible for Alarm, segment driver, clock run)
* https://github.com/xspani02/digital-electronics-1

### Table of contents

* [Project objectives](#objectives)
* [Hardware description](#hardware)
* [VHDL modules description and simulations](#modules)
* [TOP module description and simulations](#top)
* [Video](#video)
* [References](#references)

<a name="objectives"></a>

## Project objectives

The task of this project was to create digital clock with controls to set the time and alarm and when the clock will match the time with the time, which we set on alarm, it will trigger the alarm through Led signalisation. For time setting were used buttons on the board. User can toggle the alarm, if alarm is switched on, the led upon the switch 2 is going to be on. The alarm is stopped, when user switches off the switch 2. The clock runs on 100 MHz and are brought down to 1 Hz.

<a name="hardware"></a>

## Hardware description

For software implementation was used VHDL code and program Vivado, which generated the VHDL code on hardware. The hardware, that has been used is called Nexys A7 50 T from Xilinx and code to the desk was implemented thorugh USB port, which lead from computer.

<a name="modules"></a>

## VHDL modules description and simulations
### Clock Divider
The input is 100 MHz clock signal and the output is 1Hz signal for clock (clock signal).   We implemented it using a counter – counter uses integer signal „count“ and temporary signal „temp“. At rising edge of the 100MHz input clock signal „count“ increments by one until it reaches 50 000 000. During this time the input clock signal is in half to 100 MHz and variable „temp“ will be flipped to „not temp“ – then „temp“ will have high level for half time and low level for remainder. This will cause that output clock signal will have a positive or negative event every half second, resulting in a full period of one second. „Temp“ value will be assigned to the output CLKout. CLKout is connected to the components  using the clk_divided signal in the top module.
![image](https://user-images.githubusercontent.com/99393183/166238424-9515f4da-9895-42c4-a129-f5fac7980496.png)

### Clock Counter
The principle of the clock counter is very simple. Time runs when the switch is in the low position, which means that SW [0] is closed at the bottom. 6 variables are created, where individual units of time are added. The algorithm is created using if conditions, where when the value of the less significant bit reaches 9, the value of the more significant bit starts to be added, and when both values reach the condition, they are reset. Minutes and hours are done on the same principle.

clock_sec_lsb -> 00:00:0X

clock_sec_msb -> 00:00:X0

clock_mins_lsb -> 00:0X:00

clock_mins_msb -> 00:X0:00

clock_hours_lsb -> 0X:00:00

clock_hours_msb -> X0:00:00

where, lsb means less significant bit and msb means most significant bit and the changing variable is X.
![image](https://user-images.githubusercontent.com/99393183/166229733-1bba0833-32cf-4c88-92b8-265defed8ac9.png)

![image](https://user-images.githubusercontent.com/99393183/165782881-e94ad8ed-d805-4d98-8501-4512398fbb71.png)

### 7- segment display
The seven segment diodes on the Nexys A7-50T board are of the common anode type. This means that the individual segments light up when the state is "0". To display individual digits in the BCD on the display, we have created a decoder that assigns a vector for display on a 7-segment display to each numeric value (0000 to 1001).
To display the individual time variables, it is necessary to run the displays at high speed,
to make it seem to our human eye that they are all going at the same time, but only one is always active. For this purpose, we created a clock signal divider. The display works in such a way that the algorithm cycles through the individual displays and assigns them individual values on the devided frequency.

![image](https://user-images.githubusercontent.com/99393183/166230203-547187ce-f3b9-45b4-8ed6-d1e2b2a23fae.png)
![image](https://user-images.githubusercontent.com/99393183/166230247-3af8acd5-95e2-464c-a35a-0b61ea3db2d7.png)

### Alarm Signalization
If the conditions for starting the alarm are met, ie if the time coincides with the set one and SW [2] is in the upper position, the alarm will start. The signaling consists of 8 LEDs and two RGB LEDs that flash at the rising edge of frequency of the second clock signal. The alarm goes off when we set SW [2] to the lower position.

![image](https://user-images.githubusercontent.com/99393183/166230392-da33a64f-8b82-48a7-a87e-a4992d9bc71a.png)

### Setting the time and button state memory
Clock and alarm are set up the same way. The only way, that we can set seconds in clock setter and alarm setter is through middle button C, that will set hours, minutes and seconds all to zero.  Button U sets hours up, button L sets minutes down, button R sets minutes up and button D sets hours down. Both alarm and time can only be set, if their switch is on, which means, that if we switch on Switch 0, then we can set time on the clock and after we switch it off, then clock will run from that set time and for alarm setting is used Switch 1, but we can’t use him, if Switch 0 is on, because then are both switches on and we can only set time on the clock, so if we want to set time on the alarm, we must assure, that switch 0 is off. By switch 2 we will turn on the alarm. We want to prevent driver conflicts and to do that we have to split the time into three sections. First section is for changing the hours up and down, second one for minutes and the last one will return all the values to zero. If the particular button to increment the hours or minutes is is detected as being high, then the values for each section will will increase accordingly with each button press. If the particular button to increment the values is not detected as high, then the else statement allows for that button to decrement the value for it’s time section. When the values is zero, the next button press will underflow to the max allowed value and the same way it will happen if the curent value is at it’s maximal value, then it will overflow back to zero with the next button press. For both the clock setter and clock runner, while they are not enabled, the value of the current time is assigned to the module’s respective internal time signal. This ensures that when the component is enabled, it picks up from the current time as determined by the most recently outputted time of the opposite component. If set clock is not enabled, the clock runner process is always running. As a result, even when the set alarm module is pushing its time values to the display, the current time runs in the background so that when the mode is toggled back, the time is still current. After being debounced, buttons are then linked to an internal signal within it’s own process. Button input is accepted at the rising edge of it’s debounced signal so that the clock value increments / decrements only once perbutton press. At every rising edge of the clock if a button input is detected, the signal goes high, and another signal is used to remember the state of the button at the previous clock pulse. If the process detects a high button press signal, and the memory is not high the memory signal will go high and will remain so until the button is released. The signal which the other process uses to determine button input is then assigned the value of the button press logically ended with the inverted value stored in its memory. This allows the process to detect the rising edge of the button press at the rising edge of every clock pulse. As a result, each button press increments or decrements the value of minutes or hours at the rate the user presses the buttons.
Alarm setter
![image](https://user-images.githubusercontent.com/99393183/166233694-08d814a2-22eb-43e3-b7d3-2b0a95a8e8f7.png)
Button state memory
![image](https://user-images.githubusercontent.com/99393183/166233856-bcebe712-e73c-4749-b8ec-b81939e675e2.png)

## Top modules description and simulations
Assigns output variables to the hardware  components of Nexys board 

![image](https://user-images.githubusercontent.com/99393183/166269814-edd1f6ba-52fd-4533-8724-91fc828c1679.png)

![image](https://user-images.githubusercontent.com/99393183/166269991-6255086b-cd3e-4f81-bd14-29827589a90a.png)

![image](https://user-images.githubusercontent.com/99393183/166270018-f3cc2b48-8782-4a56-b6f8-5c79db9d10f1.png)

![image](https://user-images.githubusercontent.com/99393183/166270050-649a9bec-b8e8-4927-90cd-fdac51a36d65.png)

![image](https://user-images.githubusercontent.com/99393183/166270077-170a45d1-9f69-472b-9e93-b87fe0f8dc95.png)


![image](https://user-images.githubusercontent.com/99393183/166233215-7386dcb7-3b47-4a44-8a09-5cdfabb83a8d.png)

[schematic.pdf](https://github.com/petrvaneek/de1/files/8602648/schematic.pdf)
## Video
https://www.youtube.com/watch?v=LTTe8xP9w9E

## References
https://www.digikey.com/eewiki/pages/viewpage.action?pageId=4980758 - button debouncing
https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual?redirect=1 - board
https://github.com/tomas-fryza/Digital-electronics-1/blob/master/docs/nexys-a7-sch.pdf - schematics
