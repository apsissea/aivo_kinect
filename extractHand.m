function [handImage, nbHands, barys] = extractHand(in_image)

height = size(in_image, 1);
width = size(in_image, 2);
head_part = 0.4 * height;
hand_size_ratio = 4000 / (1920*1080);       % Min hand size
joinded_hand_ratio = 15000 / (1920*1080);   % Max joined hands size
min_region_size = hand_size_ratio * width * height;
max_region_size = joinded_hand_ratio * width * height;

% For smaller images we can't use such big kernels - Could be improved
octagon_kernel_radius = 6;
line_kernel_length = 10;
if (height < 540 | width < 960)
    octagon_kernel_radius = 3;
    line_kernel_length = 5;
end

in_image(1:head_part, :) = 0; % The upper part of the image is the head. We do not nead it.
in_image = imopen(in_image, strel('octagon', octagon_kernel_radius));
in_image = imopen(in_image, strel('line', line_kernel_length, 90)); 

% Label the input image
[labeledImage, n] = bwlabel(in_image, 8);

if n < 1
   %disp('Not enough regions were found');
   %return;
   handImage = zeros(size(in_image));
   nbHands = 0;
   barys = [0 0 0;0 0 0];
   return
end

counts = sum(bsxfun(@eq, labeledImage(:), 1:n));    % Number of pixels for each region
cond = counts > min_region_size & counts < max_region_size; % We only keep regions above these sizes

if ~cond
   handImage = zeros(size(in_image));
   nbHands = 0;
   barys = [0 0 0;0 0 0];
   return
end

areas = bsxfun(@eq, labeledImage, permute(find(cond), [1 3 2]));    % areas(:,:,1) the first hand, areas(:,:,2) the second one
handImage = sum(areas, 3) > 0;   % We only keep regions corresponding to the hands
nbHands = size(areas, 3);

barys = zeros(3, 2);

if nbHands >= 1
    b1 = regionprops(areas(:, :, 1), 'centroid');
    if nbHands == 2
        b2 = regionprops(areas(:, :, 2), 'centroid');
        barys = [b1.Centroid, 0; b2.Centroid, 0];
    else
        barys = [b1.Centroid, 0; 0, 0, 0];
    end
end

% if nbHands >= 1
%         % Debug
%         rgbHands = zeros(size(in_image, 1), size(in_image, 2), 3);
%         rgbHands(:, :, 1) = areas(:, :, 1);
%         
%         if n > 1
%             rgbHands(:, :, 3) = areas(:, :, 2);
%         end
%         
%         rgbHands(rgbHands > 0) = 255;
%         figure('Name', 'Both hands'); imshow(rgbHands);
% end