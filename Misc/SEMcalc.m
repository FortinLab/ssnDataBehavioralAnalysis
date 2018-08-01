function [semVal] = SEMcalc(data, nVal)
%% SEMcalc Calculates SEM
% data = data set where SEM is being calculated
% nVal = determination if denominator is n or n-1

%%
if isempty(data)
    semVal = nan;
    return
end
if nargin==1
    nVal = 'n-1';
end

if strcmp(nVal, 'n')
    semVal = nanstd(data,0,1)/sqrt(size(data,1));
elseif strcmp(nVal, 'n-1')
    semVal = nanstd(data,0,1)/sqrt(size(data,1)-1);
end