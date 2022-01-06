%%

RotationSteps=100;
NCycles=10;

rotFreq=10;

beamOffsetY=13.2e-3;
beamOffsetZ=-15.7e-3;

% NCal Cylinder Parameters
CylinderHeight = 5e-2;
CylinderDiameter = 4e-2;
CylinderMass = 1;
CylinderAxialGridPoints = 1;
CylinderRadialGridPoints = 1;

% Rotor Parameters
RotorRadius2 = 6e-2; % Quadrople radius
RotorPosition1 = [1 1 1];
RotorPosition2 = [1 1 -1];
RotorPosition3 = [1 -1 1];
RotorPosition4 = [1 -1 -1];
RotorPosition5 = [-1 1 1];
RotorPosition6 = [-1 1 -1];
RotorPosition7 = [-1 -1 1];
RotorPosition8 = [-1 -1 -1];

% Test Mass Parameters
TMLength = 200e-3;
TMDiameter = 340e-3;
TMWidth = 327e-3;
TMMass = 40;
TMAxialGridPoints = 1;
TMRadialGridPoints = 1;


% % Make a rotor cylinder	
Cylinder = genPointMassAnnlSheet(CylinderMass, 0, CylinderDiameter/2, ...
        CylinderHeight, CylinderAxialGridPoints, CylinderRadialGridPoints);
Cylinder = rotatePMArray(Cylinder, pi/2, [0 1 0]);	

%Make the rotor arrangement
R2 = translatePMArray(Cylinder, [RotorRadius2 0 0]);

Rotor = [
        R2;
        rotatePMArray(R2, pi, [0 0 1]);
    ];

% Make a Test Mass
TM = genPointMassFlatSideCyl(TMMass, TMWidth, TMDiameter/2, TMLength,...
    TMAxialGridPoints, TMRadialGridPoints);

%Spin the rotor and compute the torques
AngleForceTorque = [];

for angle = 2*pi/RotationSteps:2*pi/RotationSteps:2*pi

    RotatedRotor1 = rotatePMArray(Rotor, -angle, [0 0 1]);
    RotatedRotor2 = rotatePMArray(Rotor, -angle, [0 0 1]);
    RotatedRotor3 = rotatePMArray(Rotor, angle, [0 0 1]);
    RotatedRotor4 = rotatePMArray(Rotor, angle, [0 0 1]);
    RotatedRotor5 = rotatePMArray(Rotor, -angle+pi/2, [0 0 1]);
    RotatedRotor6 = rotatePMArray(Rotor, -angle+pi/2, [0 0 1]);
    RotatedRotor7 = rotatePMArray(Rotor, angle+pi/2, [0 0 1]);
    RotatedRotor8 = rotatePMArray(Rotor, angle+pi/2, [0 0 1]);
    
    TranslatedRotatedRotor1 = translatePMArray(RotatedRotor1, RotorPosition1);
    TranslatedRotatedRotor2 = translatePMArray(RotatedRotor2, RotorPosition2);
    TranslatedRotatedRotor3 = translatePMArray(RotatedRotor3, RotorPosition3);
    TranslatedRotatedRotor4 = translatePMArray(RotatedRotor4, RotorPosition4);
    TranslatedRotatedRotor5 = translatePMArray(RotatedRotor5, RotorPosition5);
    TranslatedRotatedRotor6 = translatePMArray(RotatedRotor6, RotorPosition6);
    TranslatedRotatedRotor7 = translatePMArray(RotatedRotor7, RotorPosition7);
    TranslatedRotatedRotor8 = translatePMArray(RotatedRotor8, RotorPosition8);
   
    Rotors = [TranslatedRotatedRotor1; TranslatedRotatedRotor2; TranslatedRotatedRotor3; ...
        TranslatedRotatedRotor4; TranslatedRotatedRotor5; TranslatedRotatedRotor6; TranslatedRotatedRotor7; ...
        TranslatedRotatedRotor8;];
    
    [Force Torque ] = pointMatrixGravity(TM, Rotors);

    AngleForceTorque = [AngleForceTorque; angle Force Torque];  
    
    
    displayPoints(TM, Rotors, []);
    
end


%% Force and Torque vs Rotor Angle

angle=[];
force=[];
torqx=[];
torqy=[];
torqz=[];
% Copies one rotation NCycles times
for j=0:NCycles-1
    angle=[angle; AngleForceTorque(:,1)+2*pi*j];
    force=[force; AngleForceTorque(:,2)];
    torqx=[torqx; AngleForceTorque(:,5)];
    torqy=[torqy; AngleForceTorque(:,6)];
    torqz=[torqz; AngleForceTorque(:,7)];
end

force=force-mean(force);
torqx=torqx-mean(torqx);
torqy=torqy-mean(torqy);
torqz=torqz-mean(torqz);

%% Fitting

% Linear least sqaure fitting
x = [cos(1*angle) sin(1*angle) ...
    cos(2*angle) sin(2*angle) ...
    cos(3*angle) sin(3*angle) ...
    cos(4*angle) sin(4*angle)...
    cos(6*angle) sin(6*angle)]; % Basis functions

w = inv(x'*x)*x'*force;
wTX = inv(x'*x)*x'*torqx;
wTY = inv(x'*x)*x'*torqy;
wTZ = inv(x'*x)*x'*torqz;

xFor=sqrt(w(3)^2+w(4)^2)

%% Offset Calculation

offForceX = [];
offForceY = [];
offForceZ = [];

offset = linspace(-100e-2,100e-2,100);

for off=offset
    
    offVec = [off 0 0];
    
    AngleForceTorque = [];

    for angle = 2*pi/RotationSteps:2*pi/RotationSteps:2*pi

        RotatedRotor1 = rotatePMArray(Rotor, -angle, [0 0 1]);
        RotatedRotor2 = rotatePMArray(Rotor, -angle, [0 0 1]);
        RotatedRotor3 = rotatePMArray(Rotor, angle, [0 0 1]);
        RotatedRotor4 = rotatePMArray(Rotor, angle, [0 0 1]);
        RotatedRotor5 = rotatePMArray(Rotor, -angle+pi/2, [0 0 1]);
        RotatedRotor6 = rotatePMArray(Rotor, -angle+pi/2, [0 0 1]);
        RotatedRotor7 = rotatePMArray(Rotor, angle+pi/2, [0 0 1]);
        RotatedRotor8 = rotatePMArray(Rotor, angle+pi/2, [0 0 1]);

        TranslatedRotatedRotor1 = translatePMArray(RotatedRotor1, RotorPosition1+offVec);
        TranslatedRotatedRotor2 = translatePMArray(RotatedRotor2, RotorPosition2+offVec);
        TranslatedRotatedRotor3 = translatePMArray(RotatedRotor3, RotorPosition3+offVec);
        TranslatedRotatedRotor4 = translatePMArray(RotatedRotor4, RotorPosition4+offVec);
        TranslatedRotatedRotor5 = translatePMArray(RotatedRotor5, RotorPosition5+offVec);
        TranslatedRotatedRotor6 = translatePMArray(RotatedRotor6, RotorPosition6+offVec);
        TranslatedRotatedRotor7 = translatePMArray(RotatedRotor7, RotorPosition7+offVec);
        TranslatedRotatedRotor8 = translatePMArray(RotatedRotor8, RotorPosition8+offVec);

        Rotors = [TranslatedRotatedRotor1; TranslatedRotatedRotor2; TranslatedRotatedRotor3; ...
            TranslatedRotatedRotor4; TranslatedRotatedRotor5; TranslatedRotatedRotor6; TranslatedRotatedRotor7; ...
            TranslatedRotatedRotor8;];

        [Force Torque ] = pointMatrixGravity(TM, Rotors);

        AngleForceTorque = [AngleForceTorque; angle Force Torque];  

    end

    angle=[];
    force=[];
    % Copies one rotation NCycles times
    for j=0:NCycles-1
        angle=[angle; AngleForceTorque(:,1)+2*pi*j];
        force=[force; AngleForceTorque(:,2)];
    end

    force=force-mean(force);

    % Linear least sqaure fitting
    x = [cos(2*angle) sin(2*angle)]; % Basis functions

    w = inv(x'*x)*x'*force;
    
    offForceX = [offForceX; sqrt(w(1)^2+w(2)^2)];
end

for off=offset
    
    offVec = [0 off 0];
    
    AngleForceTorque = [];

    for angle = 2*pi/RotationSteps:2*pi/RotationSteps:2*pi

        RotatedRotor1 = rotatePMArray(Rotor, -angle, [0 0 1]);
        RotatedRotor2 = rotatePMArray(Rotor, -angle, [0 0 1]);
        RotatedRotor3 = rotatePMArray(Rotor, angle, [0 0 1]);
        RotatedRotor4 = rotatePMArray(Rotor, angle, [0 0 1]);
        RotatedRotor5 = rotatePMArray(Rotor, -angle+pi/2, [0 0 1]);
        RotatedRotor6 = rotatePMArray(Rotor, -angle+pi/2, [0 0 1]);
        RotatedRotor7 = rotatePMArray(Rotor, angle+pi/2, [0 0 1]);
        RotatedRotor8 = rotatePMArray(Rotor, angle+pi/2, [0 0 1]);

        TranslatedRotatedRotor1 = translatePMArray(RotatedRotor1, RotorPosition1+offVec);
        TranslatedRotatedRotor2 = translatePMArray(RotatedRotor2, RotorPosition2+offVec);
        TranslatedRotatedRotor3 = translatePMArray(RotatedRotor3, RotorPosition3+offVec);
        TranslatedRotatedRotor4 = translatePMArray(RotatedRotor4, RotorPosition4+offVec);
        TranslatedRotatedRotor5 = translatePMArray(RotatedRotor5, RotorPosition5+offVec);
        TranslatedRotatedRotor6 = translatePMArray(RotatedRotor6, RotorPosition6+offVec);
        TranslatedRotatedRotor7 = translatePMArray(RotatedRotor7, RotorPosition7+offVec);
        TranslatedRotatedRotor8 = translatePMArray(RotatedRotor8, RotorPosition8+offVec);

        Rotors = [TranslatedRotatedRotor1; TranslatedRotatedRotor2; TranslatedRotatedRotor3; ...
            TranslatedRotatedRotor4; TranslatedRotatedRotor5; TranslatedRotatedRotor6; TranslatedRotatedRotor7; ...
            TranslatedRotatedRotor8;];

        [Force Torque ] = pointMatrixGravity(TM, Rotors);

        AngleForceTorque = [AngleForceTorque; angle Force Torque];  

    end

    angle=[];
    force=[];
    % Copies one rotation NCycles times
    for j=0:NCycles-1
        angle=[angle; AngleForceTorque(:,1)+2*pi*j];
        force=[force; AngleForceTorque(:,2)];
    end

    force=force-mean(force);

    % Linear least sqaure fitting
    x = [cos(2*angle) sin(2*angle)]; % Basis functions

    w = inv(x'*x)*x'*force;
    
    offForceY = [offForceY; sqrt(w(1)^2+w(2)^2)];
end

for off=offset
    
    offVec = [0 0 off];
    
    AngleForceTorque = [];

    for angle = 2*pi/RotationSteps:2*pi/RotationSteps:2*pi

        RotatedRotor1 = rotatePMArray(Rotor, -angle, [0 0 1]);
        RotatedRotor2 = rotatePMArray(Rotor, -angle, [0 0 1]);
        RotatedRotor3 = rotatePMArray(Rotor, angle, [0 0 1]);
        RotatedRotor4 = rotatePMArray(Rotor, angle, [0 0 1]);
        RotatedRotor5 = rotatePMArray(Rotor, -angle+pi/2, [0 0 1]);
        RotatedRotor6 = rotatePMArray(Rotor, -angle+pi/2, [0 0 1]);
        RotatedRotor7 = rotatePMArray(Rotor, angle+pi/2, [0 0 1]);
        RotatedRotor8 = rotatePMArray(Rotor, angle+pi/2, [0 0 1]);

        TranslatedRotatedRotor1 = translatePMArray(RotatedRotor1, RotorPosition1+offVec);
        TranslatedRotatedRotor2 = translatePMArray(RotatedRotor2, RotorPosition2+offVec);
        TranslatedRotatedRotor3 = translatePMArray(RotatedRotor3, RotorPosition3+offVec);
        TranslatedRotatedRotor4 = translatePMArray(RotatedRotor4, RotorPosition4+offVec);
        TranslatedRotatedRotor5 = translatePMArray(RotatedRotor5, RotorPosition5+offVec);
        TranslatedRotatedRotor6 = translatePMArray(RotatedRotor6, RotorPosition6+offVec);
        TranslatedRotatedRotor7 = translatePMArray(RotatedRotor7, RotorPosition7+offVec);
        TranslatedRotatedRotor8 = translatePMArray(RotatedRotor8, RotorPosition8+offVec);

        Rotors = [TranslatedRotatedRotor1; TranslatedRotatedRotor2; TranslatedRotatedRotor3; ...
            TranslatedRotatedRotor4; TranslatedRotatedRotor5; TranslatedRotatedRotor6; TranslatedRotatedRotor7; ...
            TranslatedRotatedRotor8;];

        [Force Torque ] = pointMatrixGravity(TM, Rotors);

        AngleForceTorque = [AngleForceTorque; angle Force Torque];  

    end

    angle=[];
    force=[];
    % Copies one rotation NCycles times
    for j=0:NCycles-1
        angle=[angle; AngleForceTorque(:,1)+2*pi*j];
        force=[force; AngleForceTorque(:,2)];
    end

    force=force-mean(force);

    % Linear least sqaure fitting
    x = [cos(2*angle) sin(2*angle)]; % Basis functions

    w = inv(x'*x)*x'*force;
    
    offForceZ = [offForceZ; sqrt(w(1)^2+w(2)^2)];
end


%% Figures

fig1=figure(1);
l=plot(angle, force);
xlabel('Turntable Angle (rad)','Interpreter', 'latex')
ylabel('Force in x-direction (N)','Interpreter', 'latex')
set(l,'LineWidth',1.5);
set(gca,'FontSize',16);
set(l,'MarkerSize',16);
%     xlim([0 6*pi])
grid on

fig2=figure(2);
l=plot(offset*1e2, (offForceX-xFor)/xFor*100, offset*1e2, (offForceY-xFor)/xFor*100, offset*1e2, (offForceZ-xFor)/xFor*100);
xlabel('Offset (cm)','Interpreter', 'latex')
ylabel('Percent Change','Interpreter', 'latex')
legend('x-Offset','y-Offset','z-Offset','Interpreter', 'latex')
set(l,'LineWidth',1.5);
set(gca,'FontSize',16);
set(l,'MarkerSize',16);
%     xlim([0 6*pi])
grid on


set(fig2,'Units','Inches');
pos = get(fig2,'Position');
set(fig2,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(fig2,'Super8_PerVsZ.pdf','-dpdf','-r1200')



%     output=[angle,AngleForceTorque(:,2)];
%     
%     save('NCal_ForceVsAngel.mat','output')