%%
clear, clc, close all;
%%
param.motionModel           = 'ConstantAcceleration';
param.initialLocation       = 'Same as first detection';
param.initialEstimateError  = 1E5 * ones(1, 3);
param.motionNoise           = [25, 10, 1];
param.measurementNoise      = 25;
param.segmentationThreshold = 0.05;

%%
NumTrainingFrames = 10;

utilities.videoReader = vision.VideoFileReader('skinMask.mp4');
utilities.videoPlayer = vision.VideoPlayer('Position', [890,600,800,600]);
utilities.foregroundDetector = vision.ForegroundDetector('NumTrainingFrames', 10, 'InitialVariance','Auto');
utilities.blobAnalyzer = vision.BlobAnalysis('AreaOutputPort', false, 'MinimumBlobArea', 70, 'CentroidOutputPort', true);
utilities.accumulatedImage      = 0;
utilities.accumulatedDetections = zeros(0, 2);
utilities.accumulatedTrackings  = zeros(0, 2);

%%
for i = 1:NumTrainingFrames
    objectFrame = step(utilities.videoReader);
    step(utilities.videoPlayer,objectFrame);
end
    
objectFrame = step(utilities.videoReader);
objectMask  = step(utilities.foregroundDetector, objectFrame);
points = detectMinEigenFeatures(rgb2gray(objectFrame).*objectMask);
pointImage = insertMarker(objectFrame,points.Location,'+','Color','white');

%%
tracker = vision.PointTracker('MaxBidirectionalError',1);
initialize(tracker,points.Location,objectFrame);

% figure;
% imshow(pointImage);
% title('Detected interest points');

%%
while ~isDone(utilities.videoReader)
      frame = step(utilities.videoReader);
      mask  = step(utilities.foregroundDetector,frame);
      [points, validity] = step(tracker,frame);
      out = insertMarker(frame,points(validity, :),'+');
      if any(mask(:))
          step(utilities.videoPlayer,out.*mask);
      else
          step(utilities.videoPlayer,out);
      end
%       imagesc(mask);
end

utilities.videoReader.release;
