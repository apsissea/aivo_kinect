%%
clearvars -except datas , clc, close all;

%%
if exist('datas','var') == 0
    fprintf('Loading datas ...')
    load('rawDatas.mat')
    fprintf(' done !\n')
end

%%
color = suppressBackground(datas,1000);
close;
%%
figure(1);

%%
handPositions = [];
handImage = [];
hold on;

for i = 1:size(color,4)
    mask = skinColorBinarise(color(:, :, :, i));
    [handImage, nbHands, barys] = extractHand(mask, datas.depth{i});
    handPositions = kalmanHandTracking(barys, nbHands, barys);
    %rgb = insertMarker(color(:,:,:,i),[round(barys(:,1)), round(barys(:,2))]);% on change x,y en ligne colone?
    %rgb = insertMarker(uint8(handImage*255),[round(barys(:,1)), round(barys(:,2))]);
    %figure1 = imshow(rgb);
    pause(1/30);
end

