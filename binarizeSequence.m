
%%
if exist('video','var') == 0
    fprintf('Loading video ...')
    load('capture_gestes_20171208_2.mat')
    fprintf(' done !\n')
end

%% 
if exist('video.mj2') ~= 2
    videoWrite(video,'video','mj2');
end

%%
old_frame = video(:,:,:,1);
mask = zeros(size(video,1),size(video,2),size(video,4),'uint8');

background = imread('fond.png');
background = imbinarize(skinColorBinarise(background));

%% Binarization par cutting graph RGB
h = waitbar(0,'1','Name','Binarization de la sequence');

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
implay(mask*255,30);

if exist('mask.mj2') ~= 2
    videoWrite(mask,'mask','mj2');
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

if exist('skinMask.mj2') ~= 2
    videoWrite(maskedImage,'skinMask','mj2');
end
