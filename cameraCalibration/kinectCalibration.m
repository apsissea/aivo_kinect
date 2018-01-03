clear, clc, close all;
%% Chargement de la base de données images

imagesCol = imageSet('images/Color');
imagesIr  = imageSet('images/Infrared');
imageFileNamesCol = imagesCol.ImageLocation;
imageFileNamesIr  = imagesIr.ImageLocation;

%% Calibration des deux caméras
% Données constructeur
InitialIntrinsicMatrix  = [366 0 0;0 366 0;258.6 206.5 1];
InitialRadialDistortion = [0.09357 -0.27394 0.09288];

% Calibration
paramCol = detectCameraParams(imagesCol,imageFileNamesCol,InitialIntrinsicMatrix,InitialRadialDistortion);
paramIr  = detectCameraParams(imagesIr ,imageFileNamesIr ,InitialIntrinsicMatrix,InitialRadialDistortion);

%% Calcul de la matrice de passage Color >> Ir
% definition des images de reference
imNumber = 24;
imColor = imagesCol.read(34);
imInfrd = imagesIr.read(24);
% Correction des distortions
[imColorUW, imColorCenter] = undistortImage(imColor,paramCol,'cubic');
[imInfrdUW, imInfrdCenter] = undistortImage(imInfrd,paramIr ,'cubic');

% Recherche de points d'interets
matchedPoints1 = detectCheckerboardPoints(imColorUW);
matchedPoints2 = detectCheckerboardPoints(imInfrdUW);

% Definition des matrices camera
[E,inliers] = estimateEssentialMatrix(matchedPoints1,matchedPoints2,paramCol);
F = estimateFundamentalMatrix(matchedPoints1,matchedPoints2);

% Definition des points de correspondance
inlierPoints1 = matchedPoints1(inliers,:);
inlierPoints2 = matchedPoints2(inliers,:);

figure(1);
quadSubPlot(imColor,imColorUW,imInfrd,imInfrdUW);
figure(2);
showMatchedFeatures(imColorUW,imInfrdUW,matchedPoints1,matchedPoints2,'montage','PlotOptions',{'ro','go','y--'});

%% 
tform = fitgeotrans(inlierPoints1,inlierPoints2,'projective');
test = imwarp(imColorUW,tform);
imshowpair(test,imInfrdUW), axis image;




