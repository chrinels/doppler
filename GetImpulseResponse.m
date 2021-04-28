function [ImpulseResponse] = GetImpulseResponse(EnvironmentParams, SimulationParams, MPCs, Tx, Rx)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [Delay, Doppler] = SimulateDelayAndDoppler(SimulationParams, MPCs, Tx, Rx);
    
    
end

