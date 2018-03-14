function PlotTranspositionMatrix_SD(input)
%% PlotTranspositionMatrix_SD
%
%   Plots the transposition matrix figure using the ssnData structure.
%
%   03/07/2018  Created by GE
%% Check Inputs
if nargin == 0
    % If isempty(Input) use uiopen to load the ssnData .mat file
    uiopen('.mat');
elseif ischar(input)
    % If Input=string with .mat on the end load that file
elseif isstruct(input)
    ssnData = input;
    % If Input=struct just use that structure
else
    disp('Unknown input, either pass nothing, the ssnData file location or the data structure itself');
    return;
end

load('Rosetta.mat');

%% Extract relevant data
% Sequence Length
seqLength = ssnData(1).Settings.SequenceLength;
%%
transMat = zeros(seqLength, seqLength, 2);
for trl = 1:length(ssnData)
    curTrlOdor = ssnData(trl).Odor;
    curTrlPos = ssnData(trl).TrialPosition;
    curTrlPerf = ssnData(trl).Performance;
    if curTrlPerf == 1
        transMat(curTrlOdor, curTrlPos, 1) = transMat(curTrlOdor, curTrlPos, 1) + curTrlPerf;
    end
    transMat(curTrlOdor, curTrlPos, 2) = transMat(curTrlOdor, curTrlPos, 2) + 1;
end
transMatPerf = transMat(:,:,1)./transMat(:,:,2);
[r,c] = ind2sub(size(transMatPerf), find(isnan(transMatPerf)));
imagesc(transMatPerf, [0 1]);
hold on;
for p = 1:length(r)
    patch([c(p)-0.5 c(p)-0.5 c(p)+0.5 c(p)+0.5], [r(p)-0.5 r(p)+0.5 r(p)+0.5 r(p)-0.5], 'white', 'edgecolor', 'white');
end
set(gca, 'XTick', 1:seqLength,...
    'XTickLabel', 1:seqLength,...
    'YTick', 1:seqLength, 'YTickLabel', flipud(Rosetta(1:seqLength)),...
    'DataAspectRatio',[1 1 1],'Layer','top');
colormap jet;
xlabel('Position');
ylabel('Odor');
colorbar('location', 'eastoutside');
title('Session Transposition Matrix')

for iA = 1:seqLength
    for iB = 1:seqLength
        if ~isnan(transMatPerf(iA,iB))
            if transMatPerf(iA,iB)==1 || transMatPerf(iA,iB)<=0.1
                text(iB,iA, [{sprintf('%.0f%%', transMatPerf(iA,iB)*100)}; {sprintf('(%i/%i)', transMat(iA,iB,1), transMat(iA,iB,2))}],...
                    'HorizontalAlignment', 'Center', 'color', 'white');
            else
                text(iB,iA, [{sprintf('%.0f%%', transMatPerf(iA,iB)*100)}; {sprintf('(%i/%i)', transMat(iA,iB,1), transMat(iA,iB,2))}],...
                    'HorizontalAlignment', 'Center');
            end
        end
    end
end