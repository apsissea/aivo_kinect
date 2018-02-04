function [handLoc,env] = findHandHist(I)

vectImage = I(:)';
range = max(vectImage);

nbBin = histcounts(vectImage,range);
nbBin = nbBin(2:end);

[~, envLow] = envelope(nbBin,80,'rms');
env = envelope(envLow,100,'rms');
[~,locs] = findpeaks(env,'MinPeakDistance',100);
handLoc = locs(locs > 500);
handLoc = handLoc(4);
end