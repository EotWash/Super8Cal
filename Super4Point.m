%%

RotationSteps=100;
NCycles=10;

rotFreq=10;

beamOffsetY=13.2e-3;
beamOffsetZ=-15.7e-3;

% NCal Cylinder Parameters
CylLength = 5e-2;
CylRadius = 2e-2;
CylMass = 1;

% Rotor Parameters
QuadRadius = 6e-2; % Quadrople radius
R1Position = [1 1 0];
R2Position = [1 -1 0];
R3Position = [-1 1 0];
R4Position = [-1 -1 0];

% Test Mass Parameters
TMLength = 200e-3;
TMRadius = 340e-3/2;
TMWidth = 327e-3;
TMMass = 40;

TMPosition = [0 0 0];

xFor=calculateForce4(CylMass, CylRadius, CylLength,QuadRadius, TMMass,...
        TMLength, TMRadius, TMWidth, TMPosition, R1Position, ...
        R2Position, R3Position, R4Position, true)

%% Offset Calculation

offForceX = [];
offForceY = [];
offForceZ = [];

offset = linspace(-100e-2,100e-2,100);

for off=offset
    
    offVec = [off 0 0]; 
    
    forceX = calculateForce4(CylMass, CylRadius, CylLength,QuadRadius, TMMass,...
        TMLength, TMRadius, TMWidth, TMPosition+offVec, R1Position, ...
        R2Position, R3Position, R4Position, false);
    
    offForceX = [offForceX; forceX];
end

for off=offset
    
    offVec = [0 off 0];
    
    forceY = calculateForce4(CylMass, CylRadius, CylLength,QuadRadius, TMMass,...
        TMLength, TMRadius, TMWidth, TMPosition+offVec, R1Position, ...
        R2Position, R3Position, R4Position, false);
    
    offForceY = [offForceY; forceY];
end

for off=offset
    
    offVec = [0 0 off];
    
    forceZ = calculateForce4(CylMass, CylRadius, CylLength,QuadRadius, TMMass,...
        TMLength, TMRadius, TMWidth, TMPosition+offVec, R1Position, ...
        R2Position, R3Position, R4Position, false);
    
    offForceZ = [offForceZ; forceZ];
end


%% Figures

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
print(fig2,'Super4_PerVsZ.pdf','-dpdf','-r1200')



%     output=[angle,AngleForceTorque(:,2)];
%     
%     save('NCal_ForceVsAngel.mat','output')