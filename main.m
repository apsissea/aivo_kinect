%%
clear, clc, close all;
load('rawDatas.mat');

%%
color = suppressBackground(datas,1000);
close;
%%
figure(1);

%%
handPositions = [];
handImage = [];
hold on;

for i = 1:69
    mask = skinColorBinarise(color(:, :, :, i));
    [handImage, nbHands, barys] = extractHand(mask, datas.depth{i});
    handPositions = kalmanHandTracking(barys, nbHands, barys);
    rgb = insertMarker(handImage,[barys(1,2), barys(1,1)]);
    figure1 = imshow(rgb);
    pause(1/30);
end

