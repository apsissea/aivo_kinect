%%
if exist('video','var') == 0
    fprintf('Loading video ...')
    load('capture_gestes_20171208_2.mat')
    fprintf(' done !\n')
end

%%
old_frame = video(:,:,:,1);
mask = zeros(size(video,1),size(video,2),size(video,4),'uint8');

background = imread('fond.png');
background = imbinarize(skinColorBinarise(background));

%% Binarization par cutting graph RGB
h = waitbar(0,'1','Name','Binarization de la séquence');

se = strel('square',5);
for im = 2:size(video,4)
    frame = video(:,:,:,im);
    tmp = imbinarize(skinColorBinarise(frame));
    tmp = imerode(tmp-background,se);
    tmp(tmp<0) = 0;
    mask(:,:,im-1) = tmp;
    waitbar(im/size(video,4), h, sprintf('pencent done: %d',round((im/size(video,4))*100)));
end
close(h);
implay(mask*256,30);

if isfile('skinMask.mp4')==0
    videoWrite(mask,'mask');
end

%%
maskedImage = zeros(size(video),'uint8');
h = waitbar(0,'1','Name','Masquage de la sequence');
for im = 2:size(video,4)
    maskedImage(:,:,:,im-1) = video(:,:,:,im) .* repmat(mask(:,:,im-1),[1,1,3]);
    waitbar(im/size(video,4), h, sprintf('pencent done: %d',round((im/size(video,4))*100)));
end
close(h);

implay(maskedImage,30);

if isfile('skinMask.mp4')==0
    videoWrite(maskedImage,'skinMask');
end
