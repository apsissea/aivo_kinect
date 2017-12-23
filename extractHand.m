function [handImage] = extractHand(in_image)

labeledImage = (bwlabel(in_image));
measurements = regionprops(labeledImage, 'BoundingBox', 'Area');

% Let's extract the second biggest blob - that will be the hand.
allAreas = [measurements.Area];
[sortedAreas, sortingIndexes] = sort(allAreas, 'descend');
handIndex = sortingIndexes(1); % The hand is the second biggest, face is biggest.
% Use ismember() to extact the hand from the labeled image.
handImage = ismember(labeledImage, handIndex);
% Now binarize
handImage = handImage > 0;

end
