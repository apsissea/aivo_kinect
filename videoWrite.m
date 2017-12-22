function [outputArg1] = writeVideo(sequence)
%%
videoFWriter = vision.VideoFileWriter('skinMask.mp4','FileFormat','MPEG4','FrameRate',30);
for i=1:size(sequence,4)
    videoFrame = sequence(:,:,:,i);
    step(videoFWriter,videoFrame);
end
