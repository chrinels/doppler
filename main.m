%% Clear workspace and close all open figures.
clear; close all; clc

addpath('./classes')
addpath('./functions')
addpath('./scripts')

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

% 
% BW = 10e6; % depends on the specification 802.11p bandwidth has 10 MHz, 802.11b has 20 MHz
% Nfft = 52;
% df = 156.25e3; % for 802.11p df=156.25e3, 802.11b df=312.5e3
% fs = 52*df;
% ts = 1/fs;
% dt = 0:ts:1000*ts;
SimulationParams = struct();
% SimulationParams.Nfft    = 52;
% SimulationParams.df      = 156.25e3; % for 802.11p df=156.25e3, 802.11b df=312.5e3
SimulationParams.fs      = 5e2;     % [Hz]
SimulationParams.Ts      = 1/SimulationParams.fs;    % [s]
SimulationParams.tend    = 9.5;     % [s]
SimulationParams.t       = 0:SimulationParams.Ts:SimulationParams.tend;

%% Plot the simulation start

fh = figure(); hold on;

PlotScatterers(fh, MPCs.FirstOrder,     Colors.blueish)
PlotScatterers(fh, MPCs.SecondOrder,    Colors.redish)
PlotScatterers(fh, MPCs.ThirdOrder,     Colors.yellowish)
PlotScatterers(fh, Rx,                  Colors.red)
PlotScatterers(fh, Tx,                  Colors.green)

%% Simulate
[A, Delay, Doppler] = GetCompexCoefficients(EnvironmentParams, SimulationParams, MPCs, Tx, Rx);

A_delay     = zeros(size(Delay), 'like', A);
A_doppler   = zeros(size(Doppler),'like', A);

for K = 1:length(SimulationParams.t)
    [~, I] = sort(Delay(K,:));
    Delay(K,:) = Delay(K,I);
    A_delay(K,:) = A(K,I);

    [~, J] = sort(Doppler(K,:));
    Doppler(K,:) = Doppler(K,J);
    A_doppler(K,:) = A(K, J);
end

    

%%

t = 200;
figure('Name', sprintf('Power delay, t = %d s', SimulationParams.t(t))); 
plot(Delay(t,:), abs(A_delay(t,:)).^2)

figure('Name', 'Doppler');
imagesc(Doppler);

figure('Name', 'Doppler Histogram');
histogram(Doppler(Doppler~=0), 50);

figure; imagesc(10*log10(abs(A_delay).^2))
figure; 
sh = surf(10*log10(abs(A_doppler).^2), 'EdgeAlpha', 0.001);
view([0, 90])