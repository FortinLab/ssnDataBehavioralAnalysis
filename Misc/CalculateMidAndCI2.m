function [lowCI, midVal, highCI] = CalculateMidAndCI2(dataVector, midCalc)
%% CalculateMidAndCI

if nargin == 2 || strcmp(midCalc, 'Mean')
    midVal = mean(dataVector);
elseif strcmp(midCalc, 'Median')
    midVal = median(dataVector);
end
ci95 = std(dataVector)*1.96; 
lowCI = midVal - ci95;
highCI = midVal + ci95;
