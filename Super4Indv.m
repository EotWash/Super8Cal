%%


cylLength = 5e-2;
cylRadius = 2e-2;
cylMass = 1;
quadRadius = 6e-2;

tmLength = 200e-3;
tmRadius = 170e-3;
tmWidth = 327e-3;
tmMass = 40;

x = 4.50;
y = 2.25;
rotor1Position = [x/2 y/2 0];
rotor2Position = [x/2 -y/2 0];
rotor3Position = [-x/2 y/2 0];
rotor4Position = [-x/2 -y/2 0];

cylLengthErr = 5e-6;
cylRadiusErr = 2.5e-6;
cylMassErr = 0.3e-3;
quadRadiusErr = 5e-6;

tmLengthErr = 0.1e-3;
tmRadiusErr = 0.05e-3;
tmWidthErr = 0.05e-3;
tmMassErr = 10e-3;

rotorPositionErr = [1e-3 1e-3 1e-3];
tmPositionErr = [1e-2 1e-2 1e-2];

N=1e2;

%% Cyl Mass Calculation

forDist = [];

for index=0:N    
    
    inCylMass = cylMass+randn*cylMassErr;
    inCylRadius = cylRadius;
    inCylLength = cylLength;
    inQuadRadius = quadRadius;
    
    
    inTMMass = tmMass;
    inTMRadius = tmRadius;
    inTMLength = tmLength;
    inTMWidth = tmWidth;
    
    
    inR1Position = rotor1Position;
    inR2Position = rotor2Position;
    inR3Position = rotor3Position;
    inR4Position = rotor4Position;    
        
    inTMPosition = [0 0 0];
    
    forDist = [forDist; calculateForce4(inCylMass, inCylRadius, inCylLength,inQuadRadius, inTMMass,...
        inTMLength, inTMRadius, inTMWidth, inTMPosition, inR1Position, ...
        inR2Position, inR3Position, inR4Position, false)]; 
    
end

accDis = forDist/tmMass;

mu = prctile(accDis,50);
up = prctile(accDis,84.1);
low = prctile(accDis,15.9);

err = max([up-mu,mu-low]);

disp(['Cyl Mass: ' num2str(mu*1e15) ' fm/s^2 +- ' num2str(err*1e15) ' fm/s^2 (' ...
    num2str(err/mu*100) ' % )']);

%% Cyl Radius Calculation

forDist = [];

for index=0:N    
    
    inCylMass = cylMass;
    inCylRadius = cylRadius+randn*cylRadiusErr;
    inCylLength = cylLength;
    inQuadRadius = quadRadius;
    
    
    inTMMass = tmMass;
    inTMRadius = tmRadius;
    inTMLength = tmLength;
    inTMWidth = tmWidth;
    
    
    inR1Position = rotor1Position;
    inR2Position = rotor2Position;
    inR3Position = rotor3Position;
    inR4Position = rotor4Position;    
        
    inTMPosition = [0 0 0];
    
    forDist = [forDist; calculateForce4(inCylMass, inCylRadius, inCylLength,inQuadRadius, inTMMass,...
        inTMLength, inTMRadius, inTMWidth, inTMPosition, inR1Position, ...
        inR2Position, inR3Position, inR4Position, false)]; 
end

accDis = forDist/tmMass;

mu = prctile(accDis,50);
up = prctile(accDis,84.1);
low = prctile(accDis,15.9);

err = max([up-mu,mu-low]);

disp(['Cyl Radius: ' num2str(mu*1e15) ' fm/s^2 +- ' num2str(err*1e15) ' fm/s^2 (' ...
    num2str(err/mu*100) ' % )']);

%% Cyl Length Calculation

forDist = [];

for index=0:N    
    
    inCylMass = cylMass;
    inCylRadius = cylRadius;
    inCylLength = cylLength+randn*cylLengthErr;
    inQuadRadius = quadRadius;
    
    
    inTMMass = tmMass;
    inTMRadius = tmRadius;
    inTMLength = tmLength;
    inTMWidth = tmWidth;
    
    
    inR1Position = rotor1Position;
    inR2Position = rotor2Position;
    inR3Position = rotor3Position;
    inR4Position = rotor4Position;
    
    inTMPosition = [0 0 0];
    
    forDist = [forDist; calculateForce4(inCylMass, inCylRadius, inCylLength,inQuadRadius, inTMMass,...
        inTMLength, inTMRadius, inTMWidth, inTMPosition, inR1Position, ...
        inR2Position, inR3Position, inR4Position, false)]; 
    
end

accDis = forDist/tmMass;

mu = prctile(accDis,50);
up = prctile(accDis,84.1);
low = prctile(accDis,15.9);

err = max([up-mu,mu-low]);

disp(['Cyl Length: ' num2str(mu*1e15) ' fm/s^2 +- ' num2str(err*1e15) ' fm/s^2 (' ...
    num2str(err/mu*100) ' % )']);

%% Quad Radius Calculation

forDist = [];

for index=0:N    
    
    inCylMass = cylMass;
    inCylRadius = cylRadius;
    inCylLength = cylLength;
    inQuadRadius = quadRadius+randn*quadRadiusErr;
    
    
    inTMMass = tmMass;
    inTMRadius = tmRadius;
    inTMLength = tmLength;
    inTMWidth = tmWidth;
    
    
    inR1Position = rotor1Position;
    inR2Position = rotor2Position;
    inR3Position = rotor3Position;
    inR4Position = rotor4Position;
    
        
    inTMPosition = [0 0 0];
    
    forDist = [forDist; calculateForce4(inCylMass, inCylRadius, inCylLength,inQuadRadius, inTMMass,...
        inTMLength, inTMRadius, inTMWidth, inTMPosition, inR1Position, ...
        inR2Position, inR3Position, inR4Position,false)]; 
    
end

accDis = forDist/tmMass;

mu = prctile(accDis,50);
up = prctile(accDis,84.1);
low = prctile(accDis,15.9);

err = max([up-mu,mu-low]);

disp(['Quad Radius: ' num2str(mu*1e15) ' fm/s^2 +- ' num2str(err*1e15) ' fm/s^2 (' ...
    num2str(err/mu*100) ' % )']);
%% TM Mass Calculation

forDist = [];

for index=0:N    
    
    inCylMass = cylMass;
    inCylRadius = cylRadius;
    inCylLength = cylLength;
    inQuadRadius = quadRadius;
    
    
    inTMMass = tmMass+randn*tmMassErr;
    inTMRadius = tmRadius;
    inTMLength = tmLength;
    inTMWidth = tmWidth;
    
    
    inR1Position = rotor1Position;
    inR2Position = rotor2Position;
    inR3Position = rotor3Position;
    inR4Position = rotor4Position;
    
        
    inTMPosition = [0 0 0];
    
    forDist = [forDist; calculateForce4(inCylMass, inCylRadius, inCylLength,inQuadRadius, inTMMass,...
        inTMLength, inTMRadius, inTMWidth, inTMPosition, inR1Position, ...
        inR2Position, inR3Position, inR4Position, false)]; 
    
end

accDis = forDist/tmMass;

mu = prctile(accDis,50);
up = prctile(accDis,84.1);
low = prctile(accDis,15.9);

err = max([up-mu,mu-low]);

disp(['TM Mass: ' num2str(mu*1e15) ' fm/s^2 +- ' num2str(err*1e15) ' fm/s^2 (' ...
    num2str(err/mu*100) ' % )']);

%% TM Radius Calculation

forDist = [];

for index=0:N    
    
    inCylMass = cylMass;
    inCylRadius = cylRadius;
    inCylLength = cylLength;
    inQuadRadius = quadRadius;
    
    
    inTMMass = tmMass;
    inTMRadius = tmRadius+randn*tmRadiusErr;
    inTMLength = tmLength;
    inTMWidth = tmWidth;
    
    
    inR1Position = rotor1Position;
    inR2Position = rotor2Position;
    inR3Position = rotor3Position;
    inR4Position = rotor4Position;
    
        
    inTMPosition = [0 0 0];
    
    forDist = [forDist; calculateForce4(inCylMass, inCylRadius, inCylLength,inQuadRadius, inTMMass,...
        inTMLength, inTMRadius, inTMWidth, inTMPosition, inR1Position, ...
        inR2Position, inR3Position, inR4Position, false)]; 
    
end

accDis = forDist/tmMass;

mu = prctile(accDis,50);
up = prctile(accDis,84.1);
low = prctile(accDis,15.9);

err = max([up-mu,mu-low]);

disp(['TM Radius: ' num2str(mu*1e15) ' fm/s^2 +- ' num2str(err*1e15) ' fm/s^2 (' ...
    num2str(err/mu*100) ' % )']);
%% TM Length Calculation

forDist = [];

for index=0:N    
    
    inCylMass = cylMass;
    inCylRadius = cylRadius;
    inCylLength = cylLength;
    inQuadRadius = quadRadius;
    
    
    inTMMass = tmMass;
    inTMRadius = tmRadius;
    inTMLength = tmLength+randn*tmLengthErr;
    inTMWidth = tmWidth;
    
    
    inR1Position = rotor1Position;
    inR2Position = rotor2Position;
    inR3Position = rotor3Position;
    inR4Position = rotor4Position;
    
        
    inTMPosition = [0 0 0];
    
    forDist = [forDist; calculateForce4(inCylMass, inCylRadius, inCylLength,inQuadRadius, inTMMass,...
        inTMLength, inTMRadius, inTMWidth, inTMPosition, inR1Position, ...
        inR2Position, inR3Position, inR4Position, false)]; 
    
end

accDis = forDist/tmMass;

mu = prctile(accDis,50);
up = prctile(accDis,84.1);
low = prctile(accDis,15.9);

err = max([up-mu,mu-low]);

disp(['TM Length: ' num2str(mu*1e15) ' fm/s^2 +- ' num2str(err*1e15) ' fm/s^2 (' ...
    num2str(err/mu*100) ' % )']);

%% TM Width Calculation

forDist = [];

for index=0:N    
    
    inCylMass = cylMass;
    inCylRadius = cylRadius;
    inCylLength = cylLength;
    inQuadRadius = quadRadius;
    
    
    inTMMass = tmMass;
    inTMRadius = tmRadius;
    inTMLength = tmLength;
    inTMWidth = tmWidth+randn*tmWidthErr;
    
    
    inR1Position = rotor1Position;
    inR2Position = rotor2Position;
    inR3Position = rotor3Position;
    inR4Position = rotor4Position;    
        
    inTMPosition = [0 0 0];
    
    forDist = [forDist; calculateForce4(inCylMass, inCylRadius, inCylLength,inQuadRadius, inTMMass,...
        inTMLength, inTMRadius, inTMWidth, inTMPosition, inR1Position, ...
        inR2Position, inR3Position, inR4Position, false)]; 
    
end

accDis = forDist/tmMass;

mu = prctile(accDis,50);
up = prctile(accDis,84.1);
low = prctile(accDis,15.9);

err = max([up-mu,mu-low]);

disp(['TM Width: ' num2str(mu*1e15) ' fm/s^2 +- ' num2str(err*1e15) ' fm/s^2 (' ...
    num2str(err/mu*100) ' % )']);

%% Rotor Position Calculation

forDist = [];

for index=0:N    
    
    inCylMass = cylMass;
    inCylRadius = cylRadius;
    inCylLength = cylLength;
    inQuadRadius = quadRadius;
    
    
    inTMMass = tmMass;
    inTMRadius = tmRadius;
    inTMLength = tmLength;
    inTMWidth = tmWidth;
    
    
    inR1Position = rotor1Position+randn(1,3).*rotorPositionErr;
    inR2Position = rotor2Position+randn(1,3).*rotorPositionErr;
    inR3Position = rotor3Position+randn(1,3).*rotorPositionErr;
    inR4Position = rotor4Position+randn(1,3).*rotorPositionErr;    
        
    inTMPosition = [0 0 0];
    
    forDist = [forDist; calculateForce4(inCylMass, inCylRadius, inCylLength,inQuadRadius, inTMMass,...
        inTMLength, inTMRadius, inTMWidth, inTMPosition, inR1Position, ...
        inR2Position, inR3Position, inR4Position, false)]; 
    
end

accDis = forDist/tmMass;

mu = prctile(accDis,50);
up = prctile(accDis,84.1);
low = prctile(accDis,15.9);

err = max([up-mu,mu-low]);

disp(['Rotor Position: ' num2str(mu*1e15) ' fm/s^2 +- ' num2str(err*1e15) ' fm/s^2 (' ...
    num2str(err/mu*100) ' % )']);

%% TM Position Calculation

forDist = [];

for index=0:N    
    
    inCylMass = cylMass;
    inCylRadius = cylRadius;
    inCylLength = cylLength;
    inQuadRadius = quadRadius;
    
    
    inTMMass = tmMass;
    inTMRadius = tmRadius;
    inTMLength = tmLength;
    inTMWidth = tmWidth;
    
    
    inR1Position = rotor1Position;
    inR2Position = rotor2Position;
    inR3Position = rotor3Position;
    inR4Position = rotor4Position;        
        

    inTMPosition = randn(1,3).*tmPositionErr;
    
    forDist = [forDist; calculateForce4(inCylMass, inCylRadius, inCylLength,inQuadRadius, inTMMass,...
        inTMLength, inTMRadius, inTMWidth, inTMPosition, inR1Position, ...
        inR2Position, inR3Position, inR4Position, false)]; 
    
end

accDis = forDist/tmMass;

mu = prctile(accDis,50);
up = prctile(accDis,84.1);
low = prctile(accDis,15.9);

err = max([up-mu,mu-low]);

disp(['TM Position: ' num2str(mu*1e15) ' fm/s^2 +- ' num2str(err*1e15) ' fm/s^2 (' ...
    num2str(err/mu*100) ' % )']);
