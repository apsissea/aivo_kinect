function [bbox] = addaptBbox(bbox)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
ratio = 1.2;
old_bbox = bbox(3);
bbox(3) = bbox(3)*ratio;
bbox(1) = bbox(1) - ((bbox(3)-old_bbox)/2);
bbox(4) = bbox(4)*1.5 ;
end

