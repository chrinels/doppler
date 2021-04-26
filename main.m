%% Clear workspace and close all open figures.
clear; close all; clc
% Some colors to use
Colors = struct();
Colors.red         = [1 0 0];
Colors.green       = [0 1 0];
Colors.blue        = [0 0 1];
Colors.redish      = [0.9290 0.6940 0.1250];
Colors.yellowish   = [0.8500 0.3250 0.0980];
Colors.blueish     = [0 0.4470 0.7410];

%% Setup the environment, scatterers, walls etc.
EnvironmentParams = struct();
EnvironmentParams.W             = 3;        % Width [m]
EnvironmentParams.StreetLength  = 200;      % Length [m]
EnvironmentParams.StreetWidth   = 6;        % Width [m]
EnvironmentParams.chi1          = 0.052;    % Density of 1st order scatterers [1/m^2]
EnvironmentParams.chi2          = 0.045;    % Density of 2nd order scatterers [1/m^2]
EnvironmentParams.chi3          = 0.03;     % Density of 3rd order scatterers [1/m^2]
EnvironmentParams.p1            = [-EnvironmentParams.StreetWidth/2 - EnvironmentParams.W, 0, 0];   % Point wall 1 (lower left corner)
EnvironmentParams.p2            = [+EnvironmentParams.StreetWidth/2,                       0, 0];   % Point wall 2 (lower left corner)
EnvironmentParams.A             = EnvironmentParams.W * EnvironmentParams.StreetLength;             % Scatterer area [m^2]

Scatterers                      = GenerateScatterers(EnvironmentParams);

RxPos       = [ EnvironmentParams.StreetWidth/4, EnvironmentParams.StreetLength/2, 0];
TxStartPos  = [-EnvironmentParams.StreetWidth/4, EnvironmentParams.StreetLength-5, 0];
TxVel       = [0, -20, 0]; 

% Time
SimulationParams = struct();
SimulationParams.fs      = 1e3;     % [Hz]
SimulationParams.Ts      = 1/SimulationParams.fs;    % [s]
SimulationParams.tend    = 9.5;     % [s]
SimulationParams.t       = 0:SimulationParams.Ts:SimulationParams.tend;

TxPos   = TxStartPos + TxVel.*SimulationParams.t';     % Each row is a position

%% Plot the simulation start

fh = figure(); hold on;

PlotScatterers(fh, Scatterers.FirstOrder,    Colors.blueish)
PlotScatterers(fh, Scatterers.SecondOrder,   Colors.redish)
PlotScatterers(fh, Scatterers.ThirdOrder,    Colors.yellowish)

scatter(RxPos(1),       RxPos(2),       'filled', 'MarkerFaceColor', Colors.red)
scatter(TxStartPos(1),  TxStartPos(2),  'filled', 'MarkerFaceColor', Colors.green)

%% Do some mirroring and then the projections on to Rx.

cell2mat({Scatterers.FirstOrder.Position}') - RxPos;

