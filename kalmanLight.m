%%
clc, close all;

%%
NumTrainingFrames = 10;

utilities.videoReader = vision.VideoFileReader('video.mj2');
utilities.videoPlayer = vision.VideoPlayer('Position', [890,600,800,600]);
utilities.foregroundDetector = vision.ForegroundDetector('NumTrainingFrames', 10, 'InitialVariance','Auto');

%%
foreground = VideoReader('mask.mj2');

%%
for i = 1:NumTrainingFrames
    objectFrame = step(utilities.videoReader);
    objectMask  = readFrame(foreground);
end

%%
tracker = vision.PointTracker('NumPyramidLevels',1);

% figure;
% imshow(pointImage);
% title('Detected interest points');

%%
results = [];
k = 1;
 % load the images
 images    = cell(500,1);
while ~isDone(utilities.videoReader)
    frame = step(utilities.videoReader);
    objectMask  = readFrame(foreground);
    [handImage, nbHands, barys] = extractHand(objectMask(:,:,1));
    results(k,:,:) = kalmanHandTracking(barys,nbHands);
    RGB = insertShape(uint8(handImage),'circle',[results(:,1,1),results(:,1,2),results(:,1,3)],'LineWidth',5);
    RGB = insertShape(RGB,'circle',[results(:,2,1),results(:,2,2),results(:,2,3)],'LineWidth',3);
    images{k} = RGB;
    k = k + 1;
end
results(results<0)=0;
results(results>840)=0;

figure;
plot3(results(:,1,1),results(:,1,2),results(:,1,3))
hold on
plot3(results(:,2,1),results(:,2,2),results(:,2,3))