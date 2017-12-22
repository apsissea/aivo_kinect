%%
if exist('maskedImage','var') == 0
    clear, clc ,close all; 
    fprintf('Loading data ...')
    load('masked_data.mat')
    fprintf(' done !')
end

%%
