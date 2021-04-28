function [ImpulseResponse] = GetImpulseResponse(EnvironmentParams, SimulationParams, MPCs, Tx, Rx)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [Delay, Doppler] = SimulateDelayAndDoppler(SimulationParams, MPCs, Tx, Rx);
    
    f = Tx.Frequency;
    lambda = Tx.Frequency/physconst('LightSpeed');
    
    delay = cell2mat({Delay.FirstOrder}'); % [m]
    delay(delay==0)=NaN;
    tau = delay/physconst('LightSpeed');
    
    
    doppler = cell2mat({Doppler.FirstOrder}');
    doppler(delay==0) = NaN;
    
    exp(-2j*pi*doppler);
    first = lambda./(4*pi*delay).*EnvironmentParams.G0_1(size(delay)).*exp(2j*pi*f*tau);
    
    ImpulseResponse = 0;
    
end

