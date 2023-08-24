--                 ____CASE STUDY CYBER PHYSICAL PRODUCTION SYSTEMS USING AM____                 --
--                              ____TASK : AXIAL PISTON PUMP____                                 --
--                        ____Group Number (Name) : 12 (Pump it Up)____                          --

--===============================================================================================--
--===============================================================================================--
--|||||                                  __Introduction__                                   |||||--

-->> In this programe we will generate parametric Axial Piston Pump
-->> The required inputs are Number and Radius of pistons/cylinders and Angle of swashplate

--|||||                                     __Notes__                                       |||||--

-->> Inputs of Swashplate angle is in degree
-->> In general the range of angle use for swashplate is 18 to 20 degree for best efficiency
-->> Here we are putting the range of angle is from 15 to 30 degree but you can change as per your requirements
--===============================================================================================--
-----:::::::::::::::::::::::::::::::::::::::: Inputs :::::::::::::::::::::::::::::::::::::::::-----
--===============================================================================================--

 function Axial_Piston_Pump(n_c,r_c,beta_s)

n_c = ui_number("Number of cylinders [-]",9,3,100);   -- Desired number of pistons/cylinders

r_c = ui_number("Radius of cylinder  [mm]",14,2,50);   -- Desired radius of cylinder

beta_s = ui_scalar("Swashplate angle    [degree]",20,10,30);   -- Desired angle of Swashplate


--===============================================================================================--
-----::::::::::::::::::::::::: Calculation for required Parameters :::::::::::::::::::::::::::-----
--===============================================================================================--

--- Calculation of the piston pitch circle radius (r_ppc)
--- Piston Pitch Circle (ppc) is circle that passes through all piston centers
	if n_c>4 then 
		r_ppc = (n_c*r_c)/(2*math.pi)
	elseif n_c<=4 then
		r_ppc = (n_c*r_c)/(1.1*math.pi)
	end

--- Calculation of the "Barrel radius" based on the cylinder pitch circle radius
	r_B = r_ppc+0.6*r_c
	
--- Calculation of the "desired arc distance between two Cylinders" with reference to actual arc length to avoid collision between 2 adjucent pistons
    Cylinder_spacing_factor = 2.5   -- Factor for cylinder spacing to avoid overlaping of pistons
	desired_arc_distance = (2*math.pi*r_ppc)/(n_c*Cylinder_spacing_factor)

--- Calculation for the "actual arc length between two Cylinders"
    actual_arc_length = (2*math.pi*r_ppc)/n_c

--- Adjustment for the "r_c (cylinder radius)" based on the desired and actual arc distances
    adjusted_r_c = r_c*desired_arc_distance/actual_arc_length  -- This radius will be used to avoid collision

--- Calculation for "Barrel height" and "Piston height" from Stroke length
    Stroke_length =  (r_ppc)*math.tan(math.rad(beta_s))+2*adjusted_r_c
    h_p = Stroke_length  -- Piston height from the Stroke length
    h_B = Stroke_length+h_p/2  -- Barrel height depends on Stroke Length    

--===============================================================================================--
--:::::::::::::::::::::::Creation of Primary Parts of Axial Piston Pump::::::::::::::::::::::::::--

--1. Barrel (Teal Blue) 
--2. Cylinders 
--3. Pistons (Black)
--4. Connecting rods (Black)
--5. Slippers/Sliders (Yellow)
--6. Swash plate (Cadet Blue)
--7. Shoe-Retainer plate (Teal Blue)
--===============================================================================================--

--- 1. Barrel

	Barrel = translate(0,0,-r_ppc*math.tan(math.rad(beta_s))) * cylinder(r_B,h_B)

 -- Generation of the Cylinders and add Pistons and their position using polar cordinates
    
	for i = 1, n_c do
        angle = (i - 1)*(360/n_c)  -- Angle for each Cylinder

		x = r_ppc*math.cos(math.rad(angle))    -- x cordinates for pistons and cylinders position
        y = r_ppc * math.sin(math.rad(angle))  -- y cordinates for pistons and cylinders position
        z = -x*math.tan(math.rad(beta_s))      -- z cordinates for pistons,rods,slippers position
		   
--- 2. Cylinders

    Cylinder = translate(x,y,-r_ppc*math.tan(math.rad(beta_s))) * cylinder(adjusted_r_c,h_B)

--- 3. Pistons

    r_p = adjusted_r_c-0.4
	Piston = translate(x,y,z+4) * cylinder(r_p, h_p)

--- 4. Connecting rods

	rod_h = 1.5*h_B  -- Connecting rod length 
	rod = translate(x,y,z+h_p) * cylinder(r_p/2.3,rod_h-h_p-6)  -- Distribution and translation of of rods according to piston positions

emit(rod,128)

 -- Creation of the sphere to avoid piston's linear movement when swashplate angle is change

	slip = translate(x,y,z+rod_h) * sphere((r_p/2)*1.3)  -- Distribution and translation of the slippers

--- 5. Splippers/Sliders
    
    r_sl = (r_p/2) * 1.2  -- Sphere radius

    slip = translate(x,y,z+rod_h+r_sl/1.5-6) * sphere(r_sl)  -- Distribution and translation of the slippers

		slip1 = cylinder(r_sl*1.3,r_sl*1.9)
		slip2 = cylinder(r_sl*1.1,r_sl*1.9)

		slip1 = translate(0,0,-1.9)*difference(slip1,slip2)
		slip3 = translate(0,0,1.3*r_sl) * cylinder(2.1*r_sl,r_sl/1.5)

 -- creation of parts of slipper that hold sphere

	s_1 = translate(x-0.9,y,z-6+rod_h+2/3*r_sl-2.5) * rotate(0,beta_s,0) * cylinder(r_sl*1.3,r_sl*0.3)  

	s_2 = translate(x-0.2,y,z-6+rod_h-2) * cylinder(r_p/1.9,h_p/3)

	s_3 = difference(s_1,s_2)

	dw = 1.3*r_sl+2*(r_sl/1.5)+0.2
  
	slider = rotate(0,beta_s,0) * union{slip1,slip3}
	slider2 = translate(x,y,z-6+rod_h+r_sl-(r_sl/3)) * slider

	Slider = union{s_3,slider2}
	s_h =  translate(x+1.8,y+0.9*r_sl,z+rod_h+r_sl-7) * cube(4.4*r_sl,1.81*r_sl,15)  -- to cut the slipper half 


emit(difference(Slider,s_h),126)  -- Output half Shoes/Sliders

emit(mirror(v(0,1,0)) * difference(Slider,s_h),126)  -- Other half of Shoes/Sliders

emit(Piston,128)  -- Output of Pistons

 -- Subtraction of the Cylinder from the Barrel

    Barrel = difference(Barrel, Cylinder)

---6. Swash plate

	r_s = r_B*1.2/math.cos(math.rad(beta_s)) -- Diameter of the swash plate
    h_s = (r_p/1.5)  -- Height of the swash plate
    
    swash_plate = translate(0, 0, rod_h+dw) * rotate(0, beta_s, 0) * cylinder(r_s, h_s)  -- For translation and rotation of swashplate

	Shaft_hole = translate(0, 0,rod_h+h_s-1) * rotate(0, beta_s, 0) * cylinder(r_B/2.7,h_s*5)  -- Hole to avoide connection between shaft and swashplate

emit(slip,128)  -- Output of Spheres

---7. Shoe-Retainer plate (!!! Please! Note that here the Shoe-Retainer plate is in ring shape as per modelling of printed PLA material !!!)

		-- 1. Inner rings that will be connected to swashplate or inbuilt part of the swashplate

		S_H = translate(2, 0, -1.66*h_s+rod_h+dw) * rotate(0, beta_s, 0) * cylinder(r_ppc-2*r_sl, 1.66*h_s)
		emit(difference(S_H,Shaft_hole),110)

		S_H1 = translate(1, 0,-5/3*h_s+rod_h+dw) * rotate(0, beta_s, 0) * cylinder(r_ppc-1.4*r_sl, h_s/1.5)
		emit(difference(S_H1,Shaft_hole),110)

		-- 2. Outer rings to hold slippers

		S_H2 = translate(0.5, 0, -1.64*h_s+ rod_h+dw) * rotate(0, beta_s, 0) * cylinder(r_ppc+3*r_sl, 1.64*h_s)
		S_H3 = translate(0.5, 0, -1.64*h_s+rod_h+dw) * rotate(0, beta_s, 0) * cylinder(r_ppc+2.3*r_sl, 1.64*h_s)
		s_h3 = difference(S_H2,S_H3)

		S_H4 = translate(0.5, 0, -5/3*h_s+rod_h+dw) * rotate(0, beta_s, 0) * cylinder(r_ppc+3*r_sl, h_s/1.5)
		S_H5 = translate(0.5, 0, -5/3*h_s+rod_h+dw) * rotate(0, beta_s, 0) * cylinder(r_ppc+1.9*r_sl, h_s/1.5)
		s_h5 = difference(S_H4,S_H5)
		S_HH = union{s_h3,s_h5}

 -- creation of cube to cut slipper holder in half for easyness in modelling

	S_H6 = translate(0.5, -r_s/2, -1.68*h_s+rod_h+dw) * rotate(0, beta_s, 0) * cube(2*r_s,r_s, 1.68*h_s)
	S_H7 = S_H6
	Half_S_H =  difference(S_HH,S_H7)

emit(Half_S_H,1)

	Half_S_H1 = mirror(v(0,1,0)) * Half_S_H

emit(Half_S_H1,1)



----- shoe-retainer plate

OO = translate(0,0,rod_h-2.5) *rotate(0,beta_s,0)* cylinder(r_s,h_s-1)


slip33 =translate(x+0.4,y,z-6+rod_h+r_sl) * rotate(0,beta_s,0)* cylinder(r_sl*1.8,r_sl/1.5)


SRP = difference(OO,slip33)
emit(SRP)

    end
  
emit(Barrel)

--===============================================================================================--
-----:::::::::::::: Creation of Valve plate (Represents Teal Blue Plate in Model) :::::::::::::::-----
--===============================================================================================-- 

 -- Calculation for "Valve plate"

    h_F_3 = (h_B-h_p)/4 + 0.2  -- Valve Plate thickness/height

    Valve_P = translate(0, 0, -h_F_3-r_ppc*math.tan(math.rad(beta_s))) * cylinder(r_B*1.1, h_F_3)

 -- Calculation for "Inlet and Outlet ports" in valve plate

    r_inlet = r_p * 0.8  -- Radius of cylinder in inlet port
     
	Port = {} 
	phi = 70  -- Angle between two ports
	angle = 90-phi/2
 
      for i = -angle,angle do      
    
          x =  (r_ppc-r_inlet) * math.cos(2 * math.pi * i / 360)
          y =  (r_ppc-r_inlet) * math.sin(2 * math.pi * i / 360)
          Port[#Port + 1]= v(x,y)

      end
 
      for i = angle,-angle,-1 do        
    
          x =  (r_ppc+r_inlet) * math.cos(2 * math.pi * i / 360)
          y =  (r_ppc+r_inlet) * math.sin(2 * math.pi * i / 360)
          Port[#Port + 1]= v(x,y)

      end


    Partial_Inlet = linear_extrude(v(0,0,-3.7*h_F_3-r_ppc*math.tan(math.rad(beta_s))),Port)  -- Linier extusion of port
 
    c1 = rotate(0,0,angle) * translate(r_ppc,0,-3.7*h_F_3-r_ppc*math.tan(math.rad(beta_s))) * cylinder(r_inlet,3.7*h_F_3)  -- Cylinder to give roundshape to port
    C2 = rotate(0,0,-angle) * translate(r_ppc,0,-3.7*h_F_3-r_ppc*math.tan(math.rad(beta_s))) * cylinder(r_inlet,3.7*h_F_3)  -- Cylinder to give roundshape to port

    Inlet_Port = union{c1,C2,Partial_Inlet}  -- Inlet port
    Outlet_Port = (rotate(0,0,180) * Inlet_Port)  -- Outlet port

    Ports = union{Inlet_Port,Outlet_Port}  -- Union of both ports
	
 -- Careation of "Valve plate"

    Valve_Plate = (difference(Valve_P,Ports))  -- Valve plate with ports
	
	V_P = rotate(0,0,90) * Valve_Plate  -- Output of Valve Plate

	F_hole1 = translate(0,0,-5*h_F_3-r_ppc*math.tan(math.rad(beta_s))) * cylinder(r_B/4.65,5*h_F_3)  -- Hole to give way for middle shaft and bearing
	
	V_P3 = difference(V_P,F_hole1)
	
emit(V_P3,1)	-- Output of Valve Plate with center hole

--===============================================================================================--
---::: Creation of Flange (Represents Black part under the Barrel in Model) and middle Shaft :::---
--===============================================================================================-- 

	F_1 = translate(0,0,-4*h_F_3-r_ppc*math.tan(math.rad(beta_s))) * cylinder(r_B*1.2,4*h_F_3)  -- Simple cylinder for Flange


Valve_PD = translate(0, 0, -h_F_3-r_ppc*math.tan(math.rad(beta_s))) * cylinder(r_B*1.1+0.2, h_F_3)
--emit(Valve_PD)

	F_2 = (difference(F_1,Valve_PD))  -- To create space for Valve plate in flange

	F_3 = difference(F_2,Ports)  -- To create inlet outlet port in flange

	F_31 = (rotate(0,0,90)*F_3)

--- Creation of inlet and outlet Pipes

	c1 = cylinder(r_B/5,2.5*h_F_3)  -- Outer cylinder to generate pipe 
	c2 = cylinder(r_B/6,2.5*h_F_3)  -- Inner cylinder to generate pipe
	
	Inlet_P = (translate(0,r_ppc,-6.5*h_F_3-r_ppc*math.tan(math.rad(beta_s))) * difference(c1,c2))  -- Inlet pipe
	Outlet_P = rotate(0,0,180) * Inlet_P  -- Outlet pipe

	I_O_Pipes = union{Inlet_P,Outlet_P}  -- Union of both pipes	

emit(I_O_Pipes,128)  -- Output of inlet and outlet Pipes

--- Generation of holes so fluid can flow through pipes in flange

	c3 = translate(0,r_ppc,-6*h_F_3-r_ppc*math.tan(math.rad(beta_s))) * cylinder(r_B/6,5*h_F_3)  -- To generate hole at inlet port in flange
	c4 = rotate(0,0,180 ) * c3  -- To generate hole at outlet port in flange

	cyl = union{c3,c4}  -- Union of both holes
	
	Flange = difference(F_31,cyl) 

	Flange_1 = difference(Flange,F_hole1)

emit(Flange_1,128)  -- Output of flange

--===============================================================================================--
----::: Creation of Shaft and Handle (Represents Teal Blue parts in Model) and middle Shaft :::----
--===============================================================================================-- 

--- Creation of the Shaft

	shaft = translate(0,0,-4*h_F_3-r_ppc*math.tan(math.rad(beta_s))) * cylinder(r_B/5,h_p+1.7*rod_h-((r_s*1.1)*math.sin(math.rad(beta_s)))+h_s*2.25+2*h_F_3)  -- For generation of a middle shaft

--- Creation of Handle to rotate physical 3D-printed model

	shaft1 = translate(0,0,-r_ppc*math.tan(math.rad(beta_s))+h_p/2+1.7*rod_h-((r_s*1.1)*math.sin(math.rad(beta_s)))+h_s*2.25-2*h_F_3) * cylinder(r_B/12,h_p)


	shaft2 = translate(0,0,-r_ppc*math.tan(math.rad(beta_s))+1.5*h_p+1.7*rod_h-((r_s*1.1)*math.sin(math.rad(beta_s)))+h_s*2.25-r_B/12-2*h_F_3) * rotate(0,90,0) * cylinder(r_B/12,h_p)


	shaft3 = translate(h_p,0,-r_ppc*math.tan(math.rad(beta_s))+1.5*h_p+1.7*rod_h-((r_s*1.1)*math.sin(math.rad(beta_s)))+h_s*2.25-r_B/6-2*h_F_3) * cylinder(r_B/12,h_p/2)

	S1 = translate(h_p,0,-r_ppc*math.tan(math.rad(beta_s))+1.9*h_p+1.7*rod_h-((r_s*1.1)*math.sin(math.rad(beta_s)))+h_s*2.25-r_B/12-2*h_F_3) * sphere(r_B/9)

	Handle = union{shaft1,shaft2,shaft3,S1}

emit(Handle,1)  -- Output of Handle

 -- Hole in shaft for handle
S2 = translate(0,0,-r_ppc*math.tan(math.rad(beta_s))+h_p/2+1.7*rod_h-((r_s*1.1)*math.sin(math.rad(beta_s)))+h_s*2.25-2*h_F_3) * cylinder(r_B/11.6,h_p)

    shaft_1 = difference(shaft,S2)

emit(shaft_1,1)  -- Output of middle Shaft

--===============================================================================================--
-----::::::::::::::::::::::::::::::::: Creation of Supports  (Represents Orange parts in Model)::::::::::::::::::::::::::::::::::-----

--1. Base Plate
--2. Side plate to give support shaft on swashplate side
--3. Screw holes for physicaly display Model
--4. Pivot-Hinge assembly to change swashplate angle of 3D model
--5. Swashplate handle to change angle of swashplate of physical 3D model (Teal blue in colour)
--6. Flange support
--===============================================================================================-- 

---1. Base Plate

	support_A = translate(r_B*1.2+h_s,0,-r_ppc*math.tan(math.rad(beta_s))-4*h_F_3) * cube(h_s/1.2,2.15*r_s,h_p+4*h_F_3+1.7*rod_h-((r_s*1.1)*math.sin(math.rad(beta_s)))+h_s*3)

---2. Side plate to give support shaft on swashplate side

	support_A1 = translate(r_B*0.6,0,-r_ppc*math.tan(math.rad(beta_s))+h_p+1.7*rod_h-((r_s*1.1)*math.sin(math.rad(beta_s)))+h_s*1.5-2*h_F_3) * cube(r_B+(h_s*3),r_B-0.3,h_s*1.5)

	CC = translate(0,0,-r_ppc*math.tan(math.rad(beta_s))+h_p+1.7*rod_h-((r_s*1.1)*math.sin(math.rad(beta_s)))+h_s*1.5-2*h_F_3) * cylinder(r_B/2,h_s*1.5)  -- round part of swashplate side shaft support

	S_A1=union{support_A1,CC}

 -- Creation of hole to in support_A1 for shaft way and bearing

	F_hole2 = translate(0,0,-r_ppc*math.tan(math.rad(beta_s))+h_p+1.7*rod_h-((r_s*1.1)*math.sin(math.rad(beta_s)))+h_s*.75-2*h_F_3) * cylinder(r_B/4.6,h_s*1.5)

    F_hole3 = translate(0,0,-r_ppc*math.tan(math.rad(beta_s))+h_p+1.7*rod_h-((r_s*1.1)*math.sin(math.rad(beta_s)))+h_s*2.25-2*h_F_3) * cylinder(r_B/11.6,h_p)

S_A2 = emit(difference{S_A1,F_hole2,F_hole3},5)  -- Output of swashplate support

 -- Creation of support for swashplate to hold it when it changes angle

	sa = translate(r_B*0.7+h_s*4,0,rod_h-((r_s*1.1)*math.sin(math.rad(beta_s)))) * cube(h_s*2,2*r_B,h_s*7) 

	swash_plate1 = translate(0, 0, rod_h+dw-h_s/2) * rotate(0, beta_s, 0) * cylinder(r_s,2*h_s)  -- define new bigger swashplate just to generate holding groove 

	---- emit(difference{sa,swash_plate1,support_A},6)  -- Output of Swashplate holder

---3. Screw holes for physicaly display Model

	A1 = translate(r_B*1.2+h_s/2,1.27*r_B,-2.7*h_F_3-r_ppc*math.tan(math.rad(beta_s))) * rotate(0,90,0) * cylinder(1,h_s)

	A2 = mirror(v(0,1,0))*A1

	A3 = translate(r_B*1.2+h_s/2,1.27*r_B,-r_ppc*math.tan(math.rad(beta_s))+2*rod_h-((r_s*1.1)*math.sin(math.rad(beta_s)))+h_s*4.5-1.3*h_F_3) * rotate(0,90,0) * cylinder(1,h_s)

	A4= mirror(v(0,1,0))*A3

---4. Pivot-Hinge assembly to change swashplate angle of 3D model

	P1 = translate(0,-r_s,rod_h+dw+h_s/2) * rotate(90,0,0)*cylinder(h_s/3,r_s/15)  -- Pivot on swashplate

	P2 = rotate(0,0,180)*P1  -- Pivot on swashplate

	P = union{P1,P2}  -- Union of both pivots

emit(P,110)  -- output of pivots

	circle_p = translate(0,-r_s,rod_h+dw+h_s/2) * rotate(90,0,0) * cylinder(r_B/5,r_s/15)  -- Hinge round part
	circle_p_hole = translate(0,-r_s,rod_h+dw+h_s/2) * rotate(90,0,0) * cylinder(h_s/2.8,r_s/15)  -- Hole for Pivot in Hinge
	CP = (difference(circle_p,circle_p_hole))  -- create hole for pivot in hinge

	Plate_P = translate(0,-r_s-r_s/30,rod_h+dw+h_s/2) * rotate(0,90,0) * cube(r_B/2.5,r_s/15,r_B*1.2+h_s*0.75)  -- Hinge
    Plate_P1 = difference(Plate_P,circle_p_hole)

	PS = union{Plate_P1,CP}  -- Total part of Hinge
	PS1= mirror(v(0,1,0))*PS  -- Other side of Hinge
	Pivot_support = union{PS,PS1}  -- Union of both Hinges

---5. Swashplate handle to change angle of swashplate of physical 3D model

	H1 = translate(-r_B*1.2-(r_p*1.3)/2+r_s/7,0,rod_h+dw+r_s*math.sin(math.rad(beta_s))) * cylinder(r_s/7,h_s/2)

	SP = translate(0, 0, rod_h+dw+h_s) * rotate(0, beta_s, 0) * cylinder(r_s, h_s)  -- Imaginary swashplate to cut H1 from top side

	H_circle = difference(H1,SP)  -- cutting of H1(Handle)
	
emit(H_circle,110)  -- Output of little handle on swashplate to vary it's angle

---6. Flange support

	H_S = translate(r_B*0.6+h_s-h_s/2.4,0,-4*h_F_3-r_ppc*math.tan(math.rad(beta_s))) * cube(1.2*r_B,2.4*r_B,4*h_F_3)  -- Simple cube for support Flange

    F_2 = translate(0,0,-4*h_F_3-r_ppc*math.tan(math.rad(beta_s))) * cylinder(r_B*1.2+0.2,4*h_F_3)

emit(difference(H_S,F_2),5)  -- Difference of Flange from cube so it will generate round shape support for flange

---7. Pin to hold swashplate at some angle or position during working

	-- pin holes to hold swashplate at angle 15°,18°,20° and 22° 
	PP_15 = translate(-h_s*1.3,-r_s+r_s*1/15,rod_h+dw+h_s/2+(1.3*h_s*math.tan(math.rad(beta_s))))*rotate(90,0,0) * cylinder(h_s/4,r_s/5) 
	PP_18 = translate(-h_s*0.6,-r_s+r_s*1/15,rod_h+dw+h_s/2+(0.6*h_s*math.tan(math.rad(beta_s))))*rotate(90,0,0) * cylinder(h_s/4,r_s/5)
	PP_20 = translate(h_s*0.6,-r_s+r_s*1/15,rod_h+dw+h_s/2-(0.6*h_s*math.tan(math.rad(beta_s))))*rotate(90,0,0) * cylinder(h_s/4,r_s/5)
	PP_22 = translate(h_s*1.3,-r_s+r_s*1/15,rod_h+dw+h_s/2-(1.3*h_s*math.tan(math.rad(beta_s))))*rotate(90,0,0) * cylinder(h_s/4,r_s/5)

	PP = union{PP_15,PP_18,PP_20,PP_22}
	PP1 = mirror(v(0,1,0)) * PP

	PH_15 = translate(-h_s*1.3,-r_s+r_s*1/15,rod_h+dw+h_s/2+(1.3*h_s*math.tan(math.rad(15))))*rotate(90,0,0) * cylinder(h_s/4,r_s/5)
	PH_18 = translate(-h_s*0.6,-r_s+r_s*1/15,rod_h+dw+h_s/2+(0.6*h_s*math.tan(math.rad(18))))*rotate(90,0,0) * cylinder(h_s/4,r_s/5)
	PH_20 = translate(h_s*0.6,-r_s+r_s*1/15,rod_h+dw+h_s/2-(0.6*h_s*math.tan(math.rad(20))))*rotate(90,0,0) * cylinder(h_s/4,r_s/5)
	PH_22 = translate(h_s*1.3,-r_s+r_s*1/15,rod_h+dw+h_s/2-(h_s*1.3*math.tan(math.rad(22))))*rotate(90,0,0) * cylinder(h_s/4,r_s/5)

	PH = union{PH_15,PH_18,PH_20,PH_22}
    PH1 = mirror(v(0,1,0)) * PH
	
	-- Pin

	Pin1 = translate(h_s*0.6,-r_s+r_s*1/15,rod_h+dw+h_s/2-(0.6*h_s*math.tan(math.rad(beta_s))))*rotate(90,0,0) * cylinder(h_s/3.8,r_s/5)
	Pin2 = translate(h_s*0.6,-r_s+r_s*1/15-r_s/5,rod_h+dw+h_s/2-(0.6*h_s*math.tan(math.rad(beta_s))))*rotate(0,90,0) * cylinder(h_s/3.8,r_s/12)
	Pin3 = translate(h_s*0.6,-r_s+r_s*1/15-r_s/5,rod_h+dw+h_s/2-(0.6*h_s*math.tan(math.rad(beta_s))))*rotate(90,0,0) * sphere(h_s/3.8)

	Pin = union{Pin1,Pin2,Pin3}

	set_brush_color(128,0,0,0)
emit(Pin,128)

	Pivot_support1 = (difference{Pivot_support,PH,PH1}) 

	SP = difference(swash_plate,Shaft_hole) -- Output of Swash plate
	SP_PH = difference{SP,PP,PP1}
	SP_PH_mirr = mirror(v(0,1,0)) * PS

emit(SP_PH,110)  -- Output of Swash plate


emit(Pivot_support1,5)  -- Output of Hinges

emit(difference{support_A,Pivot_support1,A1,A2,A3,A4},5)  -- Output of Base plate

 end

Axial_Piston_Pump(9,14,20)

--===============================================================================================--
-->> We express our special thanks to Prof. Dr. Ing. Stefan Scherbarth for his guidance and help
--===============================================================================================--