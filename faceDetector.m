function [bboxes] = faceDetector(datas)
%FACEDETECTOR Summary of this function goes here
%   Detailed explanation goes here
<<<<<<< HEAD
=======
bboxes = step(faceDetector, in_image);

delta = 50;
>>>>>>> dynamic annalyse of l'histogram

faceDetector = vision.CascadeObjectDetector('FrontalFaceCART');
%faceDetector = vision.CascadeObjectDetector('FrontalFaceLBP');
%faceDetector = vision.CascadeObjectDetector('UpperBody');

h = figure(1);
hold on;

for i = 1:numel(datas.remapImage)
    I = datas.remapImage{i};
    bboxes{i} = step(faceDetector, I);
    if isempty(bboxes{i}) && i>2
        bboxes{i} = bboxes{i-1};
    end

    %IFaces = insertObjectAnnotation(I, 'rectangle', bboxes{i}, 'Face');
    %imshow(IFaces), title('Detected faces');
    %pause(1/30);
end

<<<<<<< HEAD
hold off;
close(h) ;
end
=======
bboxes = bboxes(1,:);
old_bbox = bboxes;
>>>>>>> dynamic annalyse of l'histogram

