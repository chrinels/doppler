classdef Scatterer
    %SCATTERER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Position
        Normal
    end
    
    methods
        function obj = Scatterer(position, normalVector)
            %SCATTERER Construct an instance of this class
            %   Detailed explanation goes here
            obj.Position = position;
            obj.Normal = normalVector;
        end
        
        function dist = Distance(obj, otherScatterer)
            %Distance Summary of this method goes here
            %   Detailed explanation goes here
            dist = norm(obj.Position + otherScatterer.Position);
        end
        
    end
end

