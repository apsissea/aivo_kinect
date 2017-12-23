function [mask] = skinColorBinarise(frame)
%SKINCOLORBINARISE Summary of this function goes here
%   Detailed explanation goes here
%%
R = frame(:,:,1);
G = frame(:,:,2);
B = frame(:,:,3);

I1 = R;
I1(I1 <= 95) = 0;
I2 = G;
I2(I2 <= 40) = 0;
I3 = B;
I3(I3 <= 20) = 0;

I4 = (max(R,max(G,B))- min(R,min(G,B)));
I4(I4<=15) = 0;
I5 = abs(R-G);
I5(I5<=15) = 0;

I6 = uint8(R>G);
I7 = uint8(R>B);

mask = I1.*I2.*I3.*I4.*I5.*I6.*I7;
end

