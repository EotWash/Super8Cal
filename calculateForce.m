function [forDist]=calculateForce(cylMass, cylRadius, cylLength, quadRadius, ...
    tmMass, tmLength, tmRadius, tmWidth, tmPosition, rotor1Position, rotor2Position,...
    rotor3Position, rotor4Position, rotor5Position, rotor6Position, rotor7Position, rotor8Position)
    
    
    forDist=[];
    
    RotationSteps=100;
    NCycles=10;
    
    CylinderAxialGridPoints = 5;
    CylinderRadialGridPoints = 5;
    
    TMAxialGridPoints = 5;
    TMRadialGridPoints = 5;

    Cylinder = genPointMassAnnlSheet(cylMass, 0, cylRadius, ...
            cylLength, CylinderAxialGridPoints, CylinderRadialGridPoints);
    Cylinder = rotatePMArray(Cylinder, pi/2, [0 1 0]);	

    R2 = translatePMArray(Cylinder, [quadRadius 0 0]);

    Rotor = [R2;  rotatePMArray(R2, pi, [0 0 1])];

    TM = genPointMassFlatSideCyl(tmMass, tmWidth, tmRadius, tmLength,...
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

        TranslatedRotatedRotor1 = translatePMArray(RotatedRotor1, rotor1Position);
        TranslatedRotatedRotor2 = translatePMArray(RotatedRotor2, rotor2Position);
        TranslatedRotatedRotor3 = translatePMArray(RotatedRotor3, rotor3Position);
        TranslatedRotatedRotor4 = translatePMArray(RotatedRotor4, rotor4Position);
        TranslatedRotatedRotor5 = translatePMArray(RotatedRotor5, rotor5Position);
        TranslatedRotatedRotor6 = translatePMArray(RotatedRotor6, rotor6Position);
        TranslatedRotatedRotor7 = translatePMArray(RotatedRotor7, rotor7Position);
        TranslatedRotatedRotor8 = translatePMArray(RotatedRotor8, rotor8Position);
        
        TranslatedTM  = translatePMArray(TM, tmPosition);

        Rotors = [TranslatedRotatedRotor1; TranslatedRotatedRotor2; TranslatedRotatedRotor3; ...
            TranslatedRotatedRotor4; TranslatedRotatedRotor5; TranslatedRotatedRotor6; TranslatedRotatedRotor7; ...
            TranslatedRotatedRotor8;];

        [Force Torque ] = pointMatrixGravity(TranslatedTM, Rotors);

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
    
    forDist = [forDist; sqrt(w(1)^2+w(2)^2)];

end