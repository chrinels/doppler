function [imageOfPoint] = ImagePoint(normalVector, point)
%IMAGEPOINT Calculates the coordinates of the image of a point P
% over the surface with the normal n. In 3D space.
%   Details:


    % Make sure the vectors are vertical.
    normalVector = normalVector(:)/norm(normalVector);
    point = point(:);

    imageOfPoint = (eye(3) - 2*(normalVector*normalVector'))*point;

end