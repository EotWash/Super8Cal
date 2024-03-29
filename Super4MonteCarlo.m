%%

cylLength = 5e-2;
cylRadius = 4e-2/2;
cylMass = 1;
quadRadius = 6e-2;

tmLength = 200e-3;
tmRadius = 340e-3/2;
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
tmPositionErr = [1e-3 1e-3 1e-3];

rotorPhaseErr = 1/180*pi;

%% Offset Calculation

forDist = [];

accDist = [];

N=2e3;

for index=0:N    
    
    inCylMass = cylMass+randn*cylMassErr;
    inCylRadius = cylRadius+randn*cylRadiusErr;
    inCylLength = cylLength+randn*cylLengthErr;
    inQuadRadius = quadRadius+randn*quadRadiusErr;
    
    
    inTMMass = tmMass+randn*tmMassErr;
    inTMRadius = tmRadius+randn*tmRadiusErr;
    inTMLength = tmLength+randn*tmLengthErr;
    inTMWidth = tmWidth+randn*tmWidthErr;
    
    
    inR1Position = rotor1Position+randn(1,3).*rotorPositionErr;
    inR2Position = rotor2Position+randn(1,3).*rotorPositionErr;
    inR3Position = rotor3Position+randn(1,3).*rotorPositionErr;
    inR4Position = rotor4Position+randn(1,3).*rotorPositionErr;
        
    inTMPosition = randn(1,3).*tmPositionErr;
    
    forDist = [forDist; calculateForce4(inCylMass, inCylRadius, inCylLength,inQuadRadius, inTMMass,...
        inTMLength, inTMRadius, inTMWidth, inTMPosition, inR1Position, ...
        inR2Position, inR3Position, inR4Position, rotorPhaseErr, false)]; 
    
    accDist = [accDist; forDist(end)/inTMMass];
    
end

%% Figures
mu = prctile(accDist,50);
up = prctile(accDist,84.1);
low = prctile(accDist,15.9);

err = max([up-mu,mu-low]);

disp(['Acceleration: ' num2str(mu*1e15) ' fm/s^2 +- ' num2str(err*1e15) ' fm/s^2 (' ...
    num2str(err/mu*100) ' % )']);
% 
% mu=mean(accDis)*1e15;
% sig=std(accDis)*1e15;
% x=linspace(mu-3*sig,mu+3*sig,1000);

fig1=figure(1);
histogram(accDist*1e15);
% hold on
% l=plot([mu mu]*1e12,[0 120],'--',[up up]*1e12,[0 120],'--',[low low]*1e12,[0 120],'--');
% hold off
% hold on
% l=plot(x,180*exp(-((x-mu).^2/sig^2)));
% hold off
xlabel('Acceleration (fm/s$^2$)','Interpreter', 'latex')
ylabel('Number','Interpreter', 'latex')
set(gca,'FontSize',16);
% set(l,'LineWidth',3);
% legend('Data','Gaussian Fit','Interpreter', 'latex')
grid on


set(fig1,'Units','Inches');
pos = get(fig1,'Position');
set(fig1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(fig1,'Super4_Dist.pdf','-dpdf','-r1200')



%     output=[angle,AngleForceTorque(:,2)];
%     
%     save('NCal_ForceVsAngel.mat','output')