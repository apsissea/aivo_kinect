function [] = quadSubPlot(varargin)
    figure;
    for i = 1:nargin
        inName = inputname(i);
        subplot(2,2,i), imagesc(varargin{i}), title(inName), axis image;
    end
end
