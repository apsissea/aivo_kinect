load('rawDatas.mat');

color = suppressBackground(datas);

figure;
hold on;

for i = 1:69
    mask = skinColorBinarise(color(:, :, :, i));
    [handImage, nbHands, barys] = extractHand(mask, i, datas.depth(i));
    handPositions = kalmanHandTracking(barys, nbHands, barys);
    
    
    plot3(handPositions(:,1), handPositions(:,2), handPositions(:,3));
end

