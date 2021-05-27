function [newArray,idx] = RejectPoints(array, x, y)
%REJECTPOINTS Summary of this function goes here
%   Detailed explanation goes here

idx = all([(array(:,1) > x(1)) & (array(:,1) < x(2)), (array(:,2) > y(1)) & (array(:,2) < y(2))],2);
newArray = array(idx,:);
end

