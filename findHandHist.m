function [handLoc,env] = findHandHist(I,debug)

vectImage = I(:)';
%vectImage = 
range = max(vectImage);

nbBin = histcounts(vectImage,range);
nbBin = nbBin(2:end);

val = 30;

[~, envLow] = envelope(nbBin,val,'rms');
env = envelope(envLow,val,'rms');
[~,locs] = findpeaks(env,'MinPeakProminence',10);
handLoc = locs(locs > 500);
%handLoc = handLoc(1)+((handLoc(2)-handLoc(1))/2);
handLoc = 2000;

if debug == 1
    plot(nbBin);
    hold on;
    plot(env);
    hold off
    findpeaks(env,'MinPeakProminence',val);
    pause(1/30);
end

end