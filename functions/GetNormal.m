function [u] = GetNormal(v1,v2)
%GETNORMAL Summary of this function goes here
%   Detailed explanation goes here
    v1 = v1/norm(v1);
    v2 = v2/norm(v2);
    u = (v2+v1)/norm(v2+v1);
end

