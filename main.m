%%
clearvars -except datas;
clc, close all;

%%
if exist('datas','var') == 0
    fprintf('Loading datas ...')
    load('rawDatas.mat')
    fprintf(' done !\n')
end

%%
color = suppressBackground(datas,1000);
%%
figure(1);
figPos = get(gcf,'position');

%%
handPositions = [];
handImage = [];
w = waitbar(1,'1','Name','Tracking ...');
barPos = get(w,'position');
set(w,'position',[barPos(1) (barPos(2)-(barPos(4))) barPos(3) barPos(4)]);
hold on;

%%
bbox = faceDetector(datas);

for i = 2:size(color,4)
    mask = skinColorBinarise(color(:, :, :, i));

    [handImage, nbHands, barys] = extractHand(mask, datas.depth{i}, bbox{i});
    handPositions = kalmanHandTracking(transpose(barys), nbHands, barys);
    rgb = insertMarker(color(:,:,:,i)+uint8(handImage*128),[round(barys(:,1)), round(barys(:,2))],...
       'x','color','green','size',20); % on change x,y en ligne colone?
    figure1 = imshow(rgb);
    waitbar(i/size(color,4), w, sprintf('pencent done: %-5.1f%%',((i/size(color,4))*100)));
    pause(1/30);
end
delete(w);
