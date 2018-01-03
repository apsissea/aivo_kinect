%%
clc, close all;
%%
param.motionModel           = 'ConstantAcceleration';
param.initialLocation       = 'Same as first detection';
param.initialEstimateError  = 1E5 * ones(1, 3);
param.motionNoise           = [25, 10, 1];
param.measurementNoise      = 25;
param.segmentationThreshold = 0.05;

%%
NumTrainingFrames = 10;

utilities.videoReader = vision.VideoFileReader('video.mj2');
utilities.videoPlayer = vision.VideoPlayer('Position', [890,600,800,600]);
utilities.foregroundDetector = vision.ForegroundDetector('NumTrainingFrames', 10, 'InitialVariance','Auto');
utilities.blobAnalyzer = vision.BlobAnalysis('AreaOutputPort', false, 'MinimumBlobArea', 70, 'CentroidOutputPort', true);
utilities.accumulatedImage      = 0;
utilities.accumulatedDetections = zeros(0, 2);
utilities.accumulatedTrackings  = zeros(0, 2);

%%
foreground = vision.VideoFileReader('mask.mj2');

%%
for i = 1:NumTrainingFrames
    objectFrame = step(utilities.videoReader);
    objectMask  = step(foreground);
end

%%
objectMask2 = extractHand(objectMask(:,:,1));
points = detectFASTFeatures(rgb2gray(objectFrame).*objectMask2);
pointImage = insertMarker(objectFrame,points.Location,'+','Color','white');
imagesc(pointImage), axis image;

%%
tracker = vision.PointTracker('NumPyramidLevels',1);
initialize(tracker,points.Location,objectFrame);

% figure;
% imshow(pointImage);
% title('Detected interest points');

%%
while ~isDone(utilities.videoReader)
    frame = step(utilities.videoReader);
    objectMask  = step(foreground);
    [points, validity] = step(tracker,frame);
    out = insertMarker(frame,points(validity, :),'+');
    step(utilities.videoPlayer,out);
end

%%

utilities.videoReader.release;
foreground.release;

utilities.videoPlayer.delete;
foreground.delete;
