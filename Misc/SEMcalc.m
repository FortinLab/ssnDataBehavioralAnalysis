function [semVal] = SEMcalc(data, nVal, dim)
%% SEMcalc Calculates SEM
% data = data set where SEM is being calculated
% nVal = determination if denominator is n or n-1

%%
if isempty(data)
    semVal = nan;
    return
end
if nargin==1
    nVal = 0;
    dim = 1;
elseif nargin==2
    dim = 1;
end

denom = sum(~isnan(data),dim);
denom(denom==0) = 1;
semVal = nanstd(data,nVal,dim)./sqrt(denom-1);