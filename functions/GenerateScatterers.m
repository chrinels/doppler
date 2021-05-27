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

%% Need to implement rejection sampling

X = [-1000, 1000];
Y = [-1000, 1000];

A2 = (X(2) - X(1)) * (Y(2) - Y(1));

rng(1); leftWall_1 = [  unifrnd(X(1), X(2), [ceil(A2*chi1), 1]), ...    % x-coordinates
                        unifrnd(Y(1), Y(2), [ceil(A2*chi1), 1]), ...    % y-coordinates
                        zeros(ceil(A2*chi1), 1)];                           % z-coordinates
                    
rng(2); leftWall_2 = [  unifrnd(X(1), X(2), [ceil(A2*chi2), 1]), ...    % x-coordinates
                        unifrnd(Y(1), Y(2), [ceil(A2*chi2), 1]), ...    % y-coordinates
                        zeros(ceil(A2*chi2), 1)];                           % z-coordinates
                        
rng(3); leftWall_3 = [  unifrnd(X(1), X(2), [ceil(A2*chi3), 1]), ...    % x-coordinates
                        unifrnd(Y(1), Y(2), [ceil(A2*chi3), 1]), ...    % y-coordinates
                        zeros(ceil(A2*chi3), 1)];                           % z-coordinates
                        
rng(4); rightWall_1 = [ unifrnd(X(1), X(2), [ceil(A2*chi1), 1]), ...    % x-coordinates
                        unifrnd(Y(1), Y(2), [ceil(A2*chi1), 1]), ...    % y-coordinates
                        zeros(ceil(A2*chi1), 1)];                           % z-coordinates
                        
rng(5); rightWall_2 = [ unifrnd(X(1), X(2), [ceil(A2*chi2), 1]), ...    % x-coordinates
                        unifrnd(Y(1), Y(2), [ceil(A2*chi2), 1]), ...    % y-coordinates
                        zeros(ceil(A2*chi2), 1)];                           % z-coordinates
                        
rng(6); rightWall_3 = [ unifrnd(X(1), X(2), [ceil(A2*chi3), 1]), ...    % x-coordinates
                        unifrnd(Y(1), Y(2), [ceil(A2*chi3), 1]), ...    % y-coordinates
                        zeros(ceil(A2*chi3), 1)];                           % z-coordinates

leftWall_1 = RejectPoints(leftWall_1, [p1(1), p1(1)+W], [p1(2), p1(2)+H]);
leftWall_2 = RejectPoints(leftWall_2, [p1(1), p1(1)+W], [p1(2), p1(2)+H]);
leftWall_3 = RejectPoints(leftWall_3, [p1(1), p1(1)+W], [p1(2), p1(2)+H]);

rightWall_1 = RejectPoints(rightWall_1, [p2(1), p2(1)+W], [p2(2), p2(2)+H]);
rightWall_2 = RejectPoints(rightWall_2, [p2(1), p2(1)+W], [p2(2), p2(2)+H]);
rightWall_3 = RejectPoints(rightWall_3, [p2(1), p2(1)+W], [p2(2), p2(2)+H]);
                    

for i = 1:length(leftWall_1)
    FirstOrderScatterersL(i) = Scatterer(leftWall_1(i,:), [1, 0, 0]);
end
for i = 1:length(rightWall_1)
    FirstOrderScatterersR(i) = Scatterer(rightWall_1(i,:), [-1, 0, 0]);
end
for i = 1:length(leftWall_2)
    SecondOrderScatterersL(i) = Scatterer(leftWall_2(i,:), [1, 0, 0]);
end
for i = 1:length(rightWall_2)
    SecondOrderScatterersR(i) = Scatterer(rightWall_2(i,:), [-1, 0, 0]);
end
for i = 1:length(leftWall_3)
    ThirdOrderScatterersL(i) = Scatterer(leftWall_3(i,:), [1, 0, 0]);
end
for i = 1:length(rightWall_3)
    ThirdOrderScatterersR(i) = Scatterer(rightWall_3(i,:), [-1, 0, 0]);
end

Scatterers = struct();
Scatterers.FirstOrder = [FirstOrderScatterersL, FirstOrderScatterersR];
Scatterers.SecondOrder = [SecondOrderScatterersL, SecondOrderScatterersR];
Scatterers.ThirdOrder = [ThirdOrderScatterersL, ThirdOrderScatterersR];

