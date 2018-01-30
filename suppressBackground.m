function [Color] = suppressBackground(datas, maxDepth)

sis = size(datas.remapImage{1});
Color = zeros(sis(1),sis(2),sis(3),length(datas.remapImage),'uint8');

figure(1);
w = waitbar(1,'1','Name','Suppress Background');
for i = 1:numel(datas.remapImage)
    tmp = datas.remapImage{i};
    logi = datas.depth{i} > maxDepth | datas.depth{i} < 500;
    tmp(repmat(logi,[1,1,3])) = 0;
    Color(:,:,:,i) = tmp;
    imagesc(Color(:,:,:,i));
    waitbar(i/numel(datas.remapImage), w, sprintf('pencent done: %-5.1f%%',(i/numel(datas.remapImage))*100 ));
    pause(1/30);
end
delete(w);
close(figure(1));
end
