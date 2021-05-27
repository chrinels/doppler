function [A, Delay, Doppler] = GetCompexCoefficients(EnvironmentParams, SimulationParams, MPCs, Tx, Rx)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    for fi = 1:Tx.OFDMStruct.Ncarriers
        fprintf('fi = %d/%d\n', fi, Tx.OFDMStruct.Ncarriers)
        f = Tx.Frequency + (fi-1)*Tx.OFDMStruct.df;
        
        [DelayStruct, DopplerStruct] = SimulateDelayAndDoppler(SimulationParams, MPCs, Tx, Rx, f);

        G = 10*ones(size(DelayStruct.LoS));
        A_LOS = CalcCoefficients(SimulationParams, f, G, DelayStruct.LoS, DopplerStruct.LoS);

        N = size(DelayStruct.FirstOrder,2);
        G = EnvironmentParams.G0_1([1, N]);
        G = repmat(G, length(SimulationParams.t), 1);
        A1 = CalcCoefficients(SimulationParams, f, G, DelayStruct.FirstOrder, DopplerStruct.FirstOrder);

        N = size(DelayStruct.SecondOrder,2);
        G = EnvironmentParams.G0_2([1, N]);
        G = repmat(G, length(SimulationParams.t), 1);
        A2 = CalcCoefficients(SimulationParams, f, G, DelayStruct.SecondOrder, DopplerStruct.SecondOrder);

        N = size(DelayStruct.ThirdOrder,2);
        G = EnvironmentParams.G0_3([1, N]);
        G = repmat(G, length(SimulationParams.t), 1);
        A3 = CalcCoefficients(SimulationParams, f, G, DelayStruct.ThirdOrder, DopplerStruct.ThirdOrder);

        A(fi,:,:) = [A_LOS, A1, A2, A3];
        Delay(fi,:,:) = [ cell2mat({DelayStruct.LoS}'), ...
                          cell2mat({DelayStruct.FirstOrder}'), ...
                          cell2mat({DelayStruct.SecondOrder}'), ...
                          cell2mat({DelayStruct.ThirdOrder}')  ];
        Doppler(fi,:,:) = [ cell2mat({DopplerStruct.LoS}'), ...
                            cell2mat({DopplerStruct.FirstOrder}'), ...
                            cell2mat({DopplerStruct.SecondOrder}'), ...
                            cell2mat({DopplerStruct.ThirdOrder}') ];
    end
end

