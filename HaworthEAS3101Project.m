% Russell Haworth Aerodynamics Project

clear

% Aircraft Properties
Mass = 250000; % kg
S = 427.8;% m^2
Thrust = 5e6; % N
AoA = 10; %Angle of attack in degrees
aFront = 10; % frontal area
CdFuse = 0.15; 

% Environment Properties

gravity = 9.81; % m/s^2 
rho = 1.2; %kg/m^3

% Integration parameters

dt = 0.1;
maxTime = 20;
x = 0.0;
xd = 0.0;
t = 0.0;
itime = 1;
Lift (itime) = 0;

% Load Data

airfoilData = csvread ('HW2_data.csv');

while Lift (itime) < Mass * gravity
    t = t+dt
    itime = itime +1;
    
    Cl = interp1(airfoilData(:,1), airfoilData(:,2), AoA);
    Lift(itime) = 0.5 * rho * S * Cl * xd^2;
    
    Cd = interp1(airfoilData(:,1), airfoilData(:,3), AoA)
    Drag(itime) =( 0.5 * rho * S * Cd * xd^2) + (0.5 * rho * aFront *CdFuse * xd^2);
    
    %ODE Integration
    
    ForceOverMass = (Thrust - Drag(itime)) / Mass;
    xd = ForceOverMass * dt * xd;
    x = xd * dt + x;
    
    xVals(itime) = x;
    xdVals(itime) = xd;
    tVals(itime) = t;
    
    if (t > maxTime) break      
    end

end


figure(1) 
clf(1)

subplot (4, 1, 1)
plot (tVals(:), xVals (:))
ylabel ('Position, x (m) ')
set (gca, 'FontSize', 24)
