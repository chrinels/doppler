function Scatterers = GenerateScatterers(EnvironmentVars)

% leftWall_1 - Left wall 1st order scatterers
% leftWall_2 - Left wall 2nd order scatterers
% leftWall_3 - Left wall 3rd order scatterers
% rightWall_1 - Right wall 1st order scatterers
% rightWall_2 - Right wall 2nd order scatterers
% rightWall_3 - Right wall 3rd order scatterers

chi1 = EnvironmentVars.chi1;
chi2 = EnvironmentVars.chi2;
chi3 = EnvironmentVars.chi3;

A = EnvironmentVars.A;
W = EnvironmentVars.W;
H = EnvironmentVars.StreetLength;

p1 = EnvironmentVars.p1;
p2 = EnvironmentVars.p2;

rng(1); leftWall_1 = [  unifrnd(p1(1), p1(1)+W, [round(A*chi1), 1]), ...    % x-coordinates
                        unifrnd(p1(2), p1(2)+H, [round(A*chi1), 1]), ...    % y-coordinates
                        zeros(round(A*chi1), 1)];                           % z-coordinates
                    
rng(2); leftWall_2 = [  unifrnd(p1(1), p1(1)+W, [round(A*chi2), 1]), ...    % x-coordinates
                        unifrnd(p1(2), p1(2)+H, [round(A*chi2), 1]), ...    % y-coordinates
                        zeros(round(A*chi2), 1)];                           % z-coordinates
                        
rng(3); leftWall_3 = [  unifrnd(p1(1), p1(1)+W, [round(A*chi3), 1]), ...    % x-coordinates
                        unifrnd(p1(2), p1(2)+H, [round(A*chi3), 1]), ...    % y-coordinates
                        zeros(round(A*chi3), 1)];                           % z-coordinates
                        
rng(4); rightWall_1 = [ unifrnd(p2(1), p2(1)+W, [round(A*chi1), 1]), ...    % x-coordinates
                        unifrnd(p2(2), p2(2)+H, [round(A*chi1), 1]), ...    % y-coordinates
                        zeros(round(A*chi1), 1)];                           % z-coordinates
                        
rng(5); rightWall_2 = [ unifrnd(p2(1), p2(1)+W, [round(A*chi2), 1]), ...    % x-coordinates
                        unifrnd(p2(2), p2(2)+H, [round(A*chi2), 1]), ...    % y-coordinates
                        zeros(round(A*chi2), 1)];                           % z-coordinates
                        
rng(6); rightWall_3 = [ unifrnd(p2(1), p2(1)+W, [round(A*chi3), 1]), ...    % x-coordinates
                        unifrnd(p2(2), p2(2)+H, [round(A*chi3), 1]), ...    % y-coordinates
                        zeros(round(A*chi3), 1)];                           % z-coordinates


for i = 1:length(leftWall_1)
    FirstOrderScatterers((i-1)*2 + 1) = Scatterer(leftWall_1(i,:), [1, 0, 0]);
    FirstOrderScatterers((i-1)*2 + 2) = Scatterer(rightWall_1(i,:), [-1, 0, 0]);
end

for i = 1:length(leftWall_2)
    SecondOrderScatterers((i-1)*2 + 1) = Scatterer(leftWall_2(i,:), [1, 0, 0]);
    SecondOrderScatterers((i-1)*2 + 2) = Scatterer(rightWall_2(i,:), [-1, 0, 0]);
end

for i = 1:length(leftWall_3)
    ThirdOrderScatterers((i-1)*2 + 1) = Scatterer(leftWall_3(i,:), [1, 0, 0]);
    ThirdOrderScatterers((i-1)*2 + 2) = Scatterer(rightWall_3(i,:), [-1, 0, 0]);
end

Scatterers = struct();
Scatterers.FirstOrder = FirstOrderScatterers;
Scatterers.SecondOrder = SecondOrderScatterers;
Scatterers.ThirdOrder = ThirdOrderScatterers;

