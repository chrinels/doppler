%% Clear workspace and close all open figures.
clear; close all; clc
% Some colors to use
red         = [1 0 0];
green       = [0 1 0];
blue        = [0 0 1];
redish      = [0.9290 0.6940 0.1250];
yellowish   = [0.8500 0.3250 0.0980];
blueish     = [0 0.4470 0.7410];

%% Setup the environment, scatterers, walls etc.
% 11 new variables in Workspace
% A, chi1, chi2, chi3, H, p1, p2, streetWidth, W, n_leftWall, n_rightWall
SetupEnvironment

% This will put 6 new variables in the Workspace, relating to the walls
GenerateScatterers

allScatterers = [leftWall; rightWall];

RxPos       = [-3, 5, 0]';
TxStartPos  = [3, H-5, 0]';
TxVel       = [0, -10, 0]'; 

%% Plot the simulation start

fh = figure(); hold on;
rectangle('Position', [p1(1), p1(2), W, H])
rectangle('Position', [p2(1), p2(2), W, H])
PlotScatterers(fh, allScatterers, blueish)
scatter(RxPos(1), RxPos(2), 'filled', 'MarkerFaceColor',[1 0 0])
scatter(TxStartPos(1), TxStartPos(2), 'filled', 'MarkerFaceColor',[0 1 0])


%% Time

fs      = 10;     % [Hz]
Ts      = 1/fs;      % [s]
tend    = 8;         % [s]

t       = 0:Ts:tend;

TxPos   = (TxStartPos + TxVel.*t)';     % Each row is a position

%% Do some mirroring and then the projections on to Rx.

% Length should be same for Right Wall
numberOfScatterers = length(leftWall);

first_order  = zeros(2*numberOfScatterers, 3, 1);


for i = 1:numberOfScatterers
    first_order((i-1)*2+1, :, :) = ImagePoint(n_leftWall,  [leftWall(i,:),  0]);     % The 0 at the end is the z-coordinate
    first_order((i-1)*2+2, :, :) = ImagePoint(n_rightWall, [rightWall(i,:), 0]);     % The 0 at the end is the z-coordinate
end

PlotScatterers(fh, first_order, yellowish)

for i = 1:length(t)
    PlotScatterers(fh, TxPos(i,:), green)
    pause(0.1)
end
