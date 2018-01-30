function [Color] = suppressBackground(datas, maxDepth)

sis = size(datas.remapImage{1});
Color = zeros(sis(1),sis(2),sis(3),length(datas.remapImage),'uint8');

for i = 1:numel(datas.depth)
    tmp = datas.remapImage{i};
    logi = datas.depth{i} > maxDepth | datas.depth{i} < 500;
    tmp(repmat(logi,[1,1,3])) = 0;
    Color(:,:,:,i) = tmp;
    imagesc(Color(:,:,:,i));
    pause(1/30);
end

end
