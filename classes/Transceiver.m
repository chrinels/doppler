classdef Transceiver < Scatterer
    %TRANSCEIVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Velocity
        Frequency
        OFDMStruct
        MaxDoppler
    end
    
    methods
        function obj = Transceiver(position, normalVector, velVector, fc, ofdm)
            %TRANSCEIVER Construct an instance of this class
            %   Detailed explanation goes here
            obj@Scatterer(position, normalVector)
            obj.Velocity = velVector;
            obj.Frequency = fc;
            obj.OFDMStruct = ofdm;
            % ofdm.bw           [Hz]    {5, 10, 20}*E6
            % ofdm.Ncarriers    [-]     52 for 802.11p. 48 Data, 4 pilots
            % ofdm.carrierSep   [Hz]    {78.125, 156.25, 312.5}*E3 = bw/Nfft
            % ofdm.Nfft         [-]     64 for 802.11p
            obj.MaxDoppler = vecnorm(velVector, 2)/physconst('LightSpeed') * max(abs(fc));
        end
        
    end
end

