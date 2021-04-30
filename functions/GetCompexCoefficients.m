function [A, Delay, Doppler] = GetCompexCoefficients(EnvironmentParams, SimulationParams, MPCs, Tx, Rx)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [Delay, Doppler] = SimulateDelayAndDoppler(SimulationParams, MPCs, Tx, Rx);
    
    G = 10*ones(size(Delay.LoS));
    A_LOS = CalcCoefficients(SimulationParams, Tx.Frequency, G, Delay.LoS, Doppler.LoS);
    
    N = size(Delay.FirstOrder,2);
    G = EnvironmentParams.G0_1([1, N]);
    G = repmat(G, length(SimulationParams.t), 1);    A1 = CalcCoefficients(SimulationParams, Tx.Frequency, G, Delay.FirstOrder, Doppler.FirstOrder);
    
    N = size(Delay.SecondOrder,2);
    G = EnvironmentParams.G0_2([1, N]);
    G = repmat(G, length(SimulationParams.t), 1);
    A2 = CalcCoefficients(SimulationParams, Tx.Frequency, G, Delay.SecondOrder, Doppler.SecondOrder);
    
    N = size(Delay.ThirdOrder,2);
    G = EnvironmentParams.G0_3([1, N]);
    G = repmat(G, length(SimulationParams.t), 1);
    A3 = CalcCoefficients(SimulationParams, Tx.Frequency, G, Delay.ThirdOrder, Doppler.ThirdOrder);
    
    A = [A_LOS, A1, A2, A3];
    Delay = [   cell2mat({Delay.LoS}'), ...
                cell2mat({Delay.FirstOrder}'), ...
                cell2mat({Delay.SecondOrder}'), ...
                cell2mat({Delay.ThirdOrder}')
            ];
    Doppler = [ cell2mat({Doppler.LoS}'), ...
                cell2mat({Doppler.FirstOrder}'), ...
                cell2mat({Doppler.SecondOrder}'), ...
                cell2mat({Doppler.ThirdOrder}')
              ];
end

