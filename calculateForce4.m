function [force]=calculateForce4(cylMass, cylRadius, cylLength, quadRadius, ...
    tmMass, tmLength, tmRadius, tmWidth, tmPosition, rotor1Position, rotor2Position,...
    rotor3Position, rotor4Position, rotorPhaseErr, display)
    
       
    RotationSteps=100;
    NCycles=10;
    
    CylinderAxialGridPoints = 5;
    CylinderRadialGridPoints = 5;
    
    TMAxialGridPoints = 5;
    TMRadialGridPoints = 5;

    
    AlMass=2710*pi*(cylRadius)^2*cylLength;

    
    Cylinder = genPointMassAnnlSheet(cylMass, 0, cylRadius, ...
            cylLength, CylinderAxialGridPoints, CylinderRadialGridPoints);
    Cylinder = rotatePMArray(Cylinder, pi/2, [0 1 0]);	
    
    %Make a rotor hole
    Hole = genPointMassAnnlSheet(-AlMass, 0, cylRadius, ...
        cylLength, CylinderAxialGridPoints, CylinderRadialGridPoints);
    Hole = rotatePMArray(Hole, pi/2, [0 1 0]);

    R2 = translatePMArray(Cylinder, [quadRadius 0 0]);
    R2H = translatePMArray(Hole, [quadRadius 0 0]);

    Rotor = [R2;  rotatePMArray(R2, pi, [0 0 1]);
        R2H;
        rotatePMArray(R2H, 1*pi/2, [0 0 1]);
        rotatePMArray(R2H, 2*pi/2, [0 0 1]);
        rotatePMArray(R2H, 3*pi/2, [0 0 1]);];

    TM = genPointMassFlatSideCyl(tmMass, tmWidth, tmRadius, tmLength,...
        TMAxialGridPoints, TMRadialGridPoints);

    %Spin the rotor and compute the torques
    AngleForceTorque = [];

    for angle = 2*pi/RotationSteps:2*pi/RotationSteps:2*pi

        RotatedRotor1 = rotatePMArray(Rotor, angle + randn*rotorPhaseErr, [0 0 1]);
        RotatedRotor2 = rotatePMArray(Rotor, -angle + randn*rotorPhaseErr, [0 0 1]);
        RotatedRotor3 = rotatePMArray(Rotor, -angle+pi/2 + randn*rotorPhaseErr, [0 0 1]);
        RotatedRotor4 = rotatePMArray(Rotor, angle+pi/2 + randn*rotorPhaseErr, [0 0 1]);

        TranslatedRotatedRotor1 = translatePMArray(RotatedRotor1, rotor1Position);
        TranslatedRotatedRotor2 = translatePMArray(RotatedRotor2, rotor2Position);
        TranslatedRotatedRotor3 = translatePMArray(RotatedRotor3, rotor3Position);
        TranslatedRotatedRotor4 = translatePMArray(RotatedRotor4, rotor4Position);
        
        TranslatedTM  = translatePMArray(TM, tmPosition);

        Rotors = [TranslatedRotatedRotor1; TranslatedRotatedRotor2; TranslatedRotatedRotor3; ...
            TranslatedRotatedRotor4;];

        [Force Torque ] = pointMatrixGravity(TranslatedTM, Rotors);

        AngleForceTorque = [AngleForceTorque; angle Force Torque];
        
        if display
            displayPoints(TranslatedTM, Rotors, []);
        end

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
    
    force = sqrt(w(1)^2+w(2)^2);

end