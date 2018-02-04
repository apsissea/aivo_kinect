function [Color] = suppressBackground(in_image, depth, maxDepth)

tmp = in_image;
logi = depth > maxDepth | depth < 500;
tmp(repmat(logi,[1,1,3])) = 0;
Color(:,:,:) = tmp;

end