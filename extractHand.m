function [handImage] = extractHand(in_image)

in_image(1:400, :) = 0; % The upper part of the image is the head. We do not nead it.
in_image = imopen(in_image, strel('square', 10));

[labeledImage, n] = bwlabel(in_image, 8);

if n < 1
   disp('Not enough regions were found');
   return;
end

counts = sum(bsxfun(@eq, labeledImage(:), 1:n));    % Number of pixels for each region
cond = counts > 5000 & counts < 9000;

areas = bsxfun(@eq, labeledImage, permute(find(cond), [1 3 2]));    % areas(:,:,1) the first hand, areas(:,:,2) the second one
labeledImage = sum(areas, 3) > 0;   % We only keep regions corresponding to the hands


% Debug
rgbHands = zeros(size(in_image, 1), size(in_image, 2), 3);
rgbHands(:, :, 1) = areas(:, :, 1);
rgbHands(:, :, 3) = areas(:, :, 2);

rgbHands(rgbHands > 0) = 255;

subplot(1, 3, 1); imshow(areas(:, :, 1)); title('First hand');
subplot(1, 3, 2); imshow(areas(:, :, 2)); title('Second hand');
subplot(1, 3, 3); imshow(rgbHands); title('Both hands');

end