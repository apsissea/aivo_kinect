function [bboxes,old_bbox] = faceDetector(in_image,old_bbox,faceDetector)
%FACEDETECTOR Summary of this function goes here
%   Detailed explanation goes here
bboxes = step(faceDetector, in_image);

delta = 50;

if isempty(bboxes)
    bboxes = old_bbox;
end

if old_bbox ~= [1 1 1 1]
    if bboxes(1) < old_bbox(1)-delta || bboxes(1) > old_bbox(1)+delta
        bboxes = old_bbox;
    end
end

bboxes = bboxes(1,:);
old_bbox = bboxes;

end