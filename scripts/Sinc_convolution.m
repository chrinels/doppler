

c = physconst('LightSpeed');
% maximum NLoS distance for simulation purposes
MaxDist = 20000; 
% number of paths
N_path = 10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% protocol data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BW = 10e6; % depends on the specification 802.11p bandwidth has 10 MHz, 802.11b has 20 MHz
Nfft = 52;
df = 156.25e3; % for 802.11p df=156.25e3, 802.11b df=312.5e3
fs = 52*df;
ts = 1/fs;
dt = 0:ts:1000*ts;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% protocol data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Christian and Galya, make sure to have the same grid
time_domain = SimulationParams.t; % here you should put your time grid
h_t_tau = zeros(length(time_domain),length(dt));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here you should put your data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% paths distances
d_matrix = Delay;% sort(randi(MaxDist, length(time_domain), N_path),2); % here you need to put your distances
% attenuation coefficients
a_l = A; %sort(randn(length(time_domain),N_path) + 1j*randn(length(time_domain),N_path),2,'descend'); % here you need to put your path coefficients

% delays matrix
d_tau = Delay/c;

a_l(isnan(a_l)) = 0;
d_tau(isnan(d_tau)) = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here you should put your data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
for tt = 1:length(time_domain)
    % preparation for sinc function
    sinc_mat = zeros(N_path,length(dt));
    argument = zeros(N_path,length(dt));
    
    for path = 1:N_path
        
        for i = 1:length(dt)
            argument(path,i) = dt(i)-d_tau(tt, path);
            
            if argument(path,i) == 0
                sinc_mat(path, i) = a_l(tt, path);
            else
                sinc_mat(path, i) = a_l(tt, path)*sin(pi*BW*argument(path,i))/(pi*BW*argument(path,i));
            end
        end
        
    end
    h_t_tau(tt,:) = sum(sinc_mat);
end

figure
surf(abs(h_t_tau), 'linestyle','none')

figure
plot(dt, abs(h_t_tau(1,:)))