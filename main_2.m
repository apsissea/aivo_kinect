%%
clearvars -except datas;
%clc, close all;

%%
if exist('datas','var') == 0
    fprintf('Loading datas ...')
    load('rawDatas.mat')
    fprintf(' done !\n')
end

%%
% Creation de l'affichage
h = figure(1);
figPos = get(gcf,'position');
w = waitbar(1,'1','Name','Tracking ...');
barPos = get(w,'position');
set(w,'position',[barPos(1) (barPos(2)-(barPos(4))) barPos(3) barPos(4)]);
%hold on;

% Initialisation des variables
seqLen = size(datas.remapImage,2);
handPositions = cell([1 seqLen]);
handImage = [];
bbox = [];
old_bbox = [1 1 1 1];
faceDetectorOBJ = vision.CascadeObjectDetector('FrontalFaceCART');
frameOffset = 30;
redImage = zeros(size(datas.remapImage{1}));
redImage(:,:,1) = 255;
redImage = uint8(redImage);
handDepth = findHandHist(datas.depth{1},0);

for i = frameOffset:seqLen-frameOffset
    frame = (suppressBackground(datas.remapImage{i}, datas.depth{i}, handDepth));%.*datas.mask{i};
    [handDepth,level] = findHandHist(datas.depth{i},0);
    mask = skinColorBinarise(frame);
    bbox = faceDetector(frame,old_bbox,faceDetectorOBJ);
    bbox = addaptBbox(bbox); %Prise en compte du cou
    old_bbox = bbox;

    [handImage,nbHands,barys] = extractHand_2(mask, datas.depth{i}, bbox);
    handPositions{i} = kalmanHandTracking(transpose(barys), nbHands, barys);
     
    % Sortie
    halphablend = vision.AlphaBlender('Operation', 'Binary mask', 'MaskSource', 'Input port');
    rgb = step(halphablend,frame,redImage,handImage);
    rgb = insertObjectAnnotation(rgb,'rectangle',bbox,'Face');
    rgb = insertShape(rgb,'circle',[round(barys(1,1)),round(barys(1,2)),35],'LineWidth',5,'Color','green');
    if nbHands == 2
        rgb = insertShape(rgb,'circle',[round(barys(2,1)),round(barys(2,2)),35],'LineWidth',5,'Color','blue');
    end
    rgb = insertMarker(rgb,[round(barys(:,1)), round(barys(:,2))],'o','color','green','size',20); % on change x,y en ligne colone?
    h = imshow(rgb);
    waitbar(i/seqLen, w, sprintf('Frame %d on %d',i,seqLen));
end
delete(w);
delete(h);
close;

%%

