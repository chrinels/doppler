function AL = CalcCoefficients(SimulationParams, f, G, mpcs_delay, mpcs_doppler)
    
    lambda = f/physconst('LightSpeed');

    delay = cell2mat({mpcs_delay}'); % [m]
    t = repmat(SimulationParams.t', [1, size(delay,2)]);
    tau = delay/physconst('LightSpeed');
    doppler = cell2mat({mpcs_doppler}');

    
    delay(delay==0) = NaN;
    doppler(delay==0) = NaN;

    G0 = 10.^log10(G/20); % Log -> Linear
    AL = lambda./(4*pi*delay).*G0.*exp(2j*pi*f*tau).*exp(-2j*pi*doppler.*(t-tau));

end

