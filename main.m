%% Clear workspace and close all open figures.
clear; close all; clc
% Some colors to use
Colors = struct();
Colors.red         = [  1         0         0];
Colors.green       = [  0         1         0];
Colors.blue        = [  0         0         1];
Colors.redish      = [  0.9290    0.6940    0.1250  ];
Colors.yellowish   = [  0.8500    0.3250    0.0980  ];
Colors.blueish     = [  0         0.4470    0.7410  ];

%% Setup the environment, scatterers, walls etc.
EnvironmentParams = struct();
EnvironmentParams.W             = 3;        % Width [m]
EnvironmentParams.StreetLength  = 200;      % Length [m]
EnvironmentParams.StreetWidth   = 6;        % Width [m]
EnvironmentParams.chi1          = 0.052;    % Density of 1st order scatterers [1/m^2]
EnvironmentParams.chi2          = 0.045;    % Density of 2nd order scatterers [1/m^2]
EnvironmentParams.chi3          = 0.03;     % Density of 3rd order scatterers [1/m^2]
EnvironmentParams.G0_1          = @(x) unifrnd(-65, -48, x);
EnvironmentParams.G0_2          = @(x) unifrnd(-70, -59, x);
EnvironmentParams.G0_3          = @(x) unifrnd(-75, -65, x);
EnvironmentParams.p1            = [-EnvironmentParams.StreetWidth/2 - EnvironmentParams.W, 0, 0];   % Point wall 1 (lower left corner)
EnvironmentParams.p2            = [+EnvironmentParams.StreetWidth/2,                       0, 0];   % Point wall 2 (lower left corner)
EnvironmentParams.A             = EnvironmentParams.W * EnvironmentParams.StreetLength;             % Scatterer area [m^2]

MPCs                            = GenerateScatterers(EnvironmentParams);

RxStartPos  = [ EnvironmentParams.StreetWidth/4, 0+5, 0];
TxStartPos  = [-EnvironmentParams.StreetWidth/4, EnvironmentParams.StreetLength-5, 0];
TxVel       = [0, -20, 0];
RxVel       = [0, +20, 0];

Tx = Transceiver(TxStartPos,[0,0,0], TxVel, 5.9e9);
Rx = Transceiver(RxStartPos,[0,0,0], RxVel, 5.9e9);

clear RxStartPos TxStartPos TxVel RxVel

% Time
SimulationParams = struct();
SimulationParams.fs      = 1e1;     % [Hz]
SimulationParams.Ts      = 1/SimulationParams.fs;    % [s]
SimulationParams.tend    = 10;     % [s]
SimulationParams.t       = 0:SimulationParams.Ts:SimulationParams.tend;

%% Plot the simulation start

fh = figure(); hold on;

PlotScatterers(fh, MPCs.FirstOrder,     Colors.blueish)
PlotScatterers(fh, MPCs.SecondOrder,    Colors.redish)
PlotScatterers(fh, MPCs.ThirdOrder,     Colors.yellowish)
PlotScatterers(fh, Rx,                  Colors.red)
PlotScatterers(fh, Tx,                  Colors.green)

%% Simulate
ht = GetImpulseResponse(EnvironmentParams, SimulationParams, MPCs, Tx, Rx);
