classdef Transceiver < Scatterer
    %TRANSCEIVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Velocity
        Frequency
        MaxDoppler
    end
    
    methods
        function obj = Transceiver(position, normalVector, velVector, fc)
            %TRANSCEIVER Construct an instance of this class
            %   Detailed explanation goes here
            obj@Scatterer(position, normalVector)
            obj.Velocity = velVector;
            obj.Frequency = fc;
            obj.MaxDoppler = vecnorm(velVector, 2)/physconst('LightSpeed') * fc;
        end
        
    end
end

