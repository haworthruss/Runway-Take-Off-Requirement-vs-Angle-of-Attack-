% Russell Haworth Aerodynamics Project

clear

% Aircraft Properties
Mass = 250000; % kg
S = 427.8;% m^2
Thrust = 5e6; % N
AoA = 0; %Angle of attack in degrees
aFront = 15; % frontal area
CdFuse = .1; 

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


while Lift (itime) < (Mass * gravity)
    t = t+dt;
    itime = itime +1;
    
    Cl = interp1(airfoilData(:,1), airfoilData(:,2), AoA);
    Lift(itime) = 0.5 * rho * S * Cl * xd^2;
    
    Cd = interp1(airfoilData(:,1), airfoilData(:,3), AoA);
    Drag(itime) =( 0.5 * rho * S * Cd * xd^2) + (0.5 * rho * aFront *CdFuse * xd^2);
    
    %ODE Integration
    
    ForceOverMass = (Thrust - Drag(itime)) / Mass;
    xd = ForceOverMass * dt + xd;
    x = xd * dt + x;
    
    xVals(itime) = x;
    xdVals(itime) = xd;
    tVals(itime) = t;
    
    
    
    
    if (x > 300)||(t > maxTime)
        
        dt = 0.1;
        x = 0.0;
        xd = 0.0;
        t = 0.0;
        itime = 1;
        Lift (itime) = 0;
        AoA = AoA +.01
        continue
    end
        
    if (t > maxTime) break      
    end

end


figure(1) 
clf(1)

subplot (4, 1, 1)
plot (tVals(:), xVals (:))
ylabel ('Position, x (m) ')
set (gca, 'FontSize', 11)

subplot (4, 1, 2)
plot (tVals(:), xdVals (:))
ylabel ('Velocity, x (m) ')
set (gca, 'FontSize', 11)

subplot (4, 1, 3)
plot (tVals(:), Lift (:))
ylabel ('Lift, x (m) ')
set (gca, 'FontSize', 11)

subplot (4, 1, 4)
plot (tVals(:), Drag (:))
ylabel ('Drag, x (m) ')
xlabel ('Time, t')
set (gca, 'FontSize', 11)
