function [labeledImage,nbHands,barys] = extractHand(in_image, depth_image, bbox)

in_image( bbox(2):bbox(2)+bbox(4) , bbox(1):bbox(1)+bbox(3)) = 0; % The upper part of the image is the head. We do not nead it. 
in_image = imerode(in_image, strel('disk', 10));
in_image = imdilate(in_image, strel('disk', 20));
in_image = in_image(1:424,1:512);
in_image = imbinarize(in_image);

% Label the input image
biggest2 = bwareafilt(in_image, 2, 'largest');
CC = bwconncomp(biggest2);
S = regionprops(CC,'Centroid');
labeledImage = labelmatrix(CC);
% labeledImage = label2rgb(L);
nbHands = CC.NumObjects;
if nbHands == 0
    disp('pas de bol');
    barys = [0 0 0 ; 0 0 0]
elseif nbHands == 1
    barys = S(1).Centroid;
    barys(1, 3) = depth_image(ceil(barys(1, 2)), ceil(barys(1, 1)));
else
    barys = [S(1).Centroid;S(2).Centroid];
    barys(1, 3) = depth_image(ceil(barys(1, 2)), ceil(barys(1, 1)));
    barys(2, 3) = depth_image(ceil(barys(2, 2)), ceil(barys(2, 1)));
end
end