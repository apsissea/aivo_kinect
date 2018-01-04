function [handImage] = extractHand(in_image)

in_image(1:400, :) = 0; % The upper part of the image is the head. We do not nead it.
in_image = imopen(in_image, strel('octagon', 6));
in_image = imopen(in_image, strel('line', 10, 90)); 

[labeledImage, n] = bwlabel(in_image, 8);

if n < 1
   disp('Not enough regions were found');
   return;
end

counts = sum(bsxfun(@eq, labeledImage(:), 1:n));    % Number of pixels for each region
cond = counts > 3000 & counts < 15000;

if ~cond
   handImage = zeros(size(in_image));
   return;
end

areas = bsxfun(@eq, labeledImage, permute(find(cond), [1 3 2]));    % areas(:,:,1) the first hand, areas(:,:,2) the second one
handImage = sum(areas, 3) > 0;   % We only keep regions corresponding to the hands

if size(areas, 3) >= 1
        % Debug
        rgbHands = zeros(size(in_image, 1), size(in_image, 2), 3);
        rgbHands(:, :, 1) = areas(:, :, 1);
        
        if size(areas, 3) > 1
            rgbHands(:, :, 3) = areas(:, :, 2);
        end
        
        rgbHands(rgbHands > 0) = 255;
        figure('Name', 'Both hands'); imshow(rgbHands);
end