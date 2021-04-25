%% Clear workspace and close all open figures.
clear; close all; clc

%% Setup the environment, scatterers, walls etc.
% 11 new variables in Workspace
% A, chi1, chi2, chi3, H, p1, p2, streetWidth, W, n_leftWall, n_rightWall
SetupEnvironment

% This will put 6 new variables in the Workspace, relating to the walls
GenerateScatterers

fprintf('Desired 1st order scatterer intensity: \t%d\n', chi1)
fprintf('Actual 1st order scatterer intensity: \t%d\n\n', length(leftWall_1) / A)
fprintf('Desired 2nd order scatterer intensity: \t%d\n', chi2)
fprintf('Actual 2nd order scatterer intensity: \t%d\n\n', length(leftWall_2) / A)
fprintf('Desired 3rd order scatterer intensity: \t%d\n', chi3)
fprintf('Actual 3rd order scatterer intensity: \t%d\n\n', length(leftWall_3) / A)

RxPos       = [0, 5, 0]';
TxStartPos  = [0, H-5, 0]';
TxVel       = [0, -10, 0]'; 

%% Plot the simulation start
fh = figure(); hold on;
rectangle('Position', [p1(1), p1(2), W, H])
rectangle('Position', [p2(1), p2(2), W, H])
PlotScatterers(fh, leftWall_1,  leftWall_2,  leftWall_3, ...
                   rightWall_1, rightWall_2, rightWall_3)
scatter(RxPos(1), RxPos(2), 'filled', 'MarkerFaceColor',[1 0 0])
scatter(TxStartPos(1), TxStartPos(2), 'filled', 'MarkerFaceColor',[0 1 0])

%% Do some mirroring and then the projections on to Rx.
length_1st = length(leftWall_1);
length_2nd = length(leftWall_2);
length_3rd = length(leftWall_3);

first_order  = zeros(2*length_1st, 3, 1);
second_order = zeros(2*length_2nd, 3, 1);
third_order  = zeros(2*length_3rd, 3, 1);

for i1 = 1:length_1st
    first_order((i1-1)*2+1, :, :) = ImagePoint(n_leftWall,  [leftWall_1(i1,:),  0]);     % The 0 at the end is the z-coordinate
    first_order((i1-1)*2+2, :, :) = ImagePoint(n_rightWall, [rightWall_1(i1,:), 0]);     % The 0 at the end is the z-coordinate
end

for i2 = 1:length_2nd
    second_order((i2-1)*2+1, :, :) = ImagePoint(n_leftWall,  [leftWall_2(i2,:),  0]);     % The 0 at the end is the z-coordinate
    second_order((i2-1)*2+2, :, :) = ImagePoint(n_rightWall, [rightWall_2(i2,:), 0]);     % The 0 at the end is the z-coordinate
end

for i3 = 1:length_3rd
    third_order((i3-1)*2+1, :, :) = ImagePoint(n_leftWall,  [leftWall_3(i3,:),  0]);     % The 0 at the end is the z-coordinate
    third_order((i3-1)*2+2, :, :) = ImagePoint(n_rightWall, [rightWall_3(i3,:), 0]);     % The 0 at the end is the z-coordinate
end

