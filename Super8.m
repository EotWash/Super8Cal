wx = 1.0e-11 *[0.0926  -0.0042  0.1638  -0.0821  0.0224  -0.0086  -0.1797  0.2313  -0.1023  0.0156];
wy = 1.0e-10 *[0.0093   0.0003 -0.0246  0.0385  -0.1042   0.1364  -0.0569 -0.0112   0.0136 -0.0026];
wz = 1.0e-11 *[0.0925   0.0065  0.0106  0.3833  -0.8077   0.7310  -0.3776  0.1057  -0.0099 -0.0009];
wt = 1.0e-13 *[0.0001  -0.0523  0.0740 -0.2694   0.6535  -0.6325   0.2872 -0.0656   0.0087 -0.0009];

x = linspace(1,0.1,100)';
X = [ones(length(x),1) x x.^2 x.^3 x.^4 x.^5 x.^6 x.^7 x.^8 x.^9]';


sigx = 1e-2;
sigy = 1e-2;
sigz = 1e-2;

t2a = 1.486/39.66;
sigt2a = 0.095/39.66;

sigt = abs(wt(2)*sigz);

sig = sqrt(wx(2)^2*sigx^2 + wx(3)^2*sigx^4 +...
      wy(2)^2*sigy^2 + wy(3)^2*sigy^4 +...
      wz(2)^2*sigz^2 + wz(3)^2*sigz^4 +...
      wt(1)^2*sigt2a^2 + t2a^2*sigt^2);

per = sig/ wx(1)*100;

display(['Force: ' num2str(wx(1)*1e12) ' pm/s^2 +- ' num2str(sig*1e12,2) ' pm/s^2 ' num2str(per,2) '%'])
display(['X-Contribution: 1st: ' num2str(abs(wx(2)*sigx/ wx(1)*100),3) '% 2nd: ' num2str(abs(wx(3)*sigx^2/ wx(1)*100),3) '%'])
display(['Y-Contribution: 1st: ' num2str(abs(wy(2)*sigy/ wx(1)*100),3) '% 2nd: ' num2str(abs(wy(3)*sigy^2/ wx(1)*100),3) '%'])
display(['Z-Contribution: 1st: ' num2str(abs(wz(2)*sigz/ wx(1)*100),3) '% 2nd: ' num2str(abs(wz(3)*sigz^2/ wx(1)*100),3) '%'])
display(['Torq-Contribution: Coupling: ' num2str(abs(wt(1)*sigt2a/ wx(1)*100),3) '% Direct: ' num2str(abs(t2a*sigt/ wx(1)*100),3) '%'])