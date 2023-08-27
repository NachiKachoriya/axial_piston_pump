# axial_piston_pump
For the recreation of the Axial Piston Pump Model, you require the basic input parameter from which we will get another parameter to generate a 3D Model. It helps to generate smooth and parametric geometry. In IceSL, there will be one tweak box that allows the user to change input parameters as shown below.
![image](https://github.com/NachiKachoriya/axial_piston_pump/assets/136236455/2af1a6c3-4924-41f6-9a79-cb97ae2fdcd2)
1. The first parameter is the number of cylinders or pistons.
2. The user can change the radius of cylinders/pistons with the help of a second parameter which later decides the barrel diameter and other parameter.
3. The third parameter helps you to change the angle of swash plate which will change the stroke length as well.
This can be generated with the help of code which is shown here:
![image](https://github.com/NachiKachoriya/axial_piston_pump/assets/136236455/af52a9bd-1a06-487f-acf8-b6072d08880f)

Step_1: Create a function name with Axial Piston Pump with parameters: number of cylinder/piston(n_c), radius of cylinder/piston(r_c), swash plate angle(beta_s).
Step_2: Define the input parameters and design them as UI scaler variable, to give tweak box on display so user can directly change the input parameters without looking into the code.

Calculation for required Parameters
Step_3: Defining the pitch circle radius from number of pistons and piston radius and giving condition to increase the piston pitch circle radius to avoid collision of pistons when number of pistons is less than 5.
Step_4: Getting value of Barrel radius from piston pitch circle and piston radius and to be noted that 0.6 is here in code is clearance.

![image](https://github.com/NachiKachoriya/axial_piston_pump/assets/136236455/be49fc0f-10a4-4f30-a760-55dc89480d26)

Step_5: Using cylinder piston factor, calculating the new piston radius from desired arc length to actual arc length to avoid overlapping of pistons.
Step_6: Calculation of stroke length for getting piston height and barrel height too

![image](https://github.com/NachiKachoriya/axial_piston_pump/assets/136236455/c575b915-50a7-4456-ba39-a83181c6df28)

Formation of Barrel, Cylinders, Pistons, Rods and Slippers
Step_7: Creation of barrel cylinder (without hollow part) using.
Step_8: Making for loop to generate pistons with swash angle and making pathway with some clearance for pistons.
Step_9: Define x, y and z coordinates which represent the center point of pistons and cylinders in 3-dimensions, for proper positioning of pistons, cylinders, rods and sliders.
Step_10: To create hollow parts in barrel for movement of piston within it, we use x and y coordinates and give some clearance to give pathway for piston.
Step_11: Generation of pistons.

![image](https://github.com/NachiKachoriya/axial_piston_pump/assets/136236455/205bcf5f-c3c4-4524-bea9-c25741f41358)

Step_12: Calculate the connecting rod height and build the rod

![image](https://github.com/NachiKachoriya/axial_piston_pump/assets/136236455/3957505a-5fca-4806-96c4-e3feed1d1aa9)

Step_13: Then calculate sphere dimension and create slider as well with reference to rod height for translation

![image](https://github.com/NachiKachoriya/axial_piston_pump/assets/136236455/96dbfef9-d6fb-412a-ab56-9e3699ace575)

Step_14: emit the slider.

Step_15: Then take difference of cylinders to create hollow part in Barrel and emit it.

Formation of Swash plate and Shaft
Step_16: Calculate Swash plate radius with the help of barrel radius and swashplate angle.
Step_17: Because the swash plate is fixed one need to give shaft way through, so create hollow disk by difference again.

![image](https://github.com/NachiKachoriya/axial_piston_pump/assets/136236455/ff8fb413-cd58-4e14-a140-c3fea64be682)

The swash plate will look something like this

Step_18: Create shaft which radius is 5th of barrel radius and height 3 times height

![image](https://github.com/NachiKachoriya/axial_piston_pump/assets/136236455/f4c78d03-5bfa-4543-9f85-20c3eb593bb3)

For further assembly formation you can simply refer the instructional tutorial file given.
