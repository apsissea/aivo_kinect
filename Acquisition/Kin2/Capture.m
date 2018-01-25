%%
clear, clc, close all;

%% Create device
k2 = Kin2('color','depth','infrared','body','body_index');

% images sizes
parameters.d_width = 512;
parameters.d_height = 424;
parameters.outOfRange = 2000; %Capture max distance ;
parameters.c_width = 1920;
parameters.c_height = 1080;

%% Create matrix container
datas      = [];
datas.color      = []; %zeros(c_height,c_width,3,'uint8');
datas.depth      = []; %zeros(d_height,d_width,'uint16');
datas.infrared   = []; %zeros(d_height,d_width,'uint16');
datas.remapImage = []; %zeros(d_height,d_width,'uint8');
datas.mask       = [];

%%
h = figure;

k=1;
while true
    if ishandle(h)
        validData = k2.updateData;
        if validData
            datas.depth{k} = k2.getDepth;
            datas.color{k} = k2.getColor;
            datas.infrared{k} = k2.getInfrared;
            datas.remapImage{k} = k2.getAlignColor2Depth;

            % Display
            isTracked = k2.getBodies('Quat');
            numBodies = size(isTracked,2);
            if numBodies > 0
                bodies{k} = isTracked;
                bodyIndex = k2.getBodyIndex;
                datas.mask{k} = bodyIdMask(bodyIndex);
                pos2D = k2.mapCameraPoints2Depth(isTracked(1).Position');
                imshow(insertMarker(datas.remapImage{k}.*datas.mask{k},pos2D));
                %imagesc(mask);
            else
                imshow(datas.remapImage{k}), axis image;
            end

            pause(1/30); % Because kinect framerate is 30ips 
            k = k+1;
        end
    else
        break;
    end
end
disp('User exit');
    
%% Close kinect object
pause(2);
k2.delete;

%% View again
for i = 1:size(datas.color,2)
    if any(datas.mask{i}(:))
        imshow(datas.remapImage{i}.*datas.mask{i});
        pause(1/30);
    else
        imshow(datas.remapImage{i});
        pause(1/30);
    end
end
close all;

%% Fonctions
function mask=bodyIdMask(bodyIndex)
    mask = 1-imbinarize(bodyIndex);
    mask = uint8(mask);
    mask = repmat(mask,[1,1,3]);
end