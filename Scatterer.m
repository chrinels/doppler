classdef Scatterer
    %SCATTERER Construct an instance of the Scatterer class
    %   A scatterer is a point in 3D space with a corresponding
    %   normal vector.
    
    properties
        Position
        Normal
    end
    
    methods
        function obj = Scatterer(position, normalVector)
            %SCATTERER Construct an instance of the Scatterer class
            %   A scatterer is a point in 3D space with a corresponding
            %   normal vector.
            obj.Position = position;
            obj.Normal = normalVector;
        end
        
        function dist = Distance(obj, otherScatterer)
            %Distance Euclidean distance
            %   Euclidean distance between this scatterer and another.
            dist = norm(obj.Position - otherScatterer.Position, 2);
        end
        
        function ang = Angle(obj, otherScatterer, deg)
            % Angle The angle between two scatterers, seen from origio.
            if nargin == 2
                deg = 0;
            end
            if nargin == 3
                deg = 1;
            end
            a = obj.Position;
            b = otherScatterer.Position;
            c = atan2(norm(cross(a,b)), dot(a,b));
            if deg
                ang = rad2deg(c);
            else
                ang = c;
            end 
        end
        
    end
    
    methods(Static)
        function ang = VecAngle(vec1, vec2, deg)
            %VecAngle calculates the (positive) angle between two 3x1
            %vectors.
            %   vec1: 3 element long vector
            %   vec2: 3 element long vector
            %   deg: 0 - return radians, 1 - return degree
            if nargin == 2
                deg = 0;
            end
            if nargin == 3
                deg = 1;
            end
            % IF one vec y--coor is '0' then all is zero.
            % ydir = sign(vec2(2))*sign(vec1(2));
            c = atan2(vecnorm(cross(vec1,vec2),2,2), dot(vec1,vec2,2));
            if deg
                ang = rad2deg(c);
            else
                ang = c;
            end 
        end
    end
end

