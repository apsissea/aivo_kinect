%%
if exist('maskedImage','var') == 0
    clear, clc ,close all; 
    fprintf('Loading data ...')
    load('masked_data.mat')
    fprintf(' done !')
end

%%
tmp = logical(mask(:,:,1,1));
labeledImage = bwlabel(tmp);

measurements = regionprops(labeledImage, 'Centroid', 'BoundingBox', 'Area');
%centroids = cat(1, measurements.Centroid);

allAreas = [measurements.Area];
allBB = [measurements.BoundingBox];

[sortedAreas, sortingIndexes] = sort(allAreas, 'descend');
handIndex = sortingIndexes(1);
handImage = ismember(labeledImage, handIndex);
handImage = handImage > 0;

%out = insertMarker(video(:,:,:,1),centroids,'x','color','red','size',10);
imagesc(handImage), axis image;
rectangle('Position',allBB(1));
