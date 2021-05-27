function [imageOfv] = ImagePoint(normalVector, v)
%IMAGEPOINT Calculates the coordinates of the image of a vector v
% over the surface with the normal n. In 3D space.
%   Details:


    % Make sure the vectors are vertical.
    normalVector = normalVector(:)/norm(normalVector);
    v = v(:);

    imageOfv = (eye(3) - 2*(normalVector*normalVector'))*v;

end