function [] = videoWrite(sequence,name,format)
%% Permet d'écrire une vidéo à partir d'une variable 3 ou 4-D
if numel(size(sequence))<4
    disp('zut')
    tmp = zeros(size(sequence,1),size(sequence,2),3,size(sequence,3));
    for im = 1:size(sequence,3)
        dump = repmat(sequence(:,:,im),[1,1,3]);
        tmp(:,:,:,im) = dump;
    end
    sequence = tmp;
end

if format == 'mj2'
    ext = '.mj2';
    encoding = 'MJ2000';
elseif format == 'avi'
    ext = '.avi';
    encoding = 'AVI';
else
    ext = '.mp4';
    encoding = 'MPEG4';
end
    
videoFWriter = vision.VideoFileWriter([name,ext],'FileFormat',encoding,'FrameRate',30);
for i=1:size(sequence,4)
    videoFrame = sequence(:,:,:,i);
    step(videoFWriter,videoFrame);
end
