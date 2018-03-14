function PlotHoldDurByLag_SD(input)
%% PlotHoldDurByLag_SD
%   Plot trial hold duration for behavioral data stored in the ssnData
%   format.
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
%% Extract Relevant Data
% Pull out Trial Hold Durations
holdDur = [ssnData.PokeDuration];
% Pull out Trial Position
trialPos = [ssnData.TrialPosition];
% Pull out Trial Odor
trialOdr = [ssnData.Odor];
% Pull out Transposition Distances
trialTransDist = trialPos-trialOdr;
% Identify InSeq Trials
inSeqLog = trialPos==trialOdr;
% Identify OutSeq Trials
outSeqLog = ~inSeqLog;
% Identify Skip Trials

% Target Duration +/- StDev Value
targHD = ssnData(1).Settings.StartingPokeDur;
if isfield(ssnData(1).Settings, 'PokeDurSD')
    targSD = ssnData(1).Settings.PokeDurSD;
else
    targSD = 0;
end
% Sequence Length
seqLength = ssnData(1).Settings.SequenceLength;


%% Plot Shit
hdByItemPosTrl = cell(3,seqLength);
for i = 1:seqLength
    hdByItemPosTrl{1,i} = holdDur(inSeqLog & trialOdr==i);
    hdByItemPosTrl{2,i} = holdDur(outSeqLog & trialOdr==i);
    hdByItemPosTrl{3,i} = holdDur(outSeqLog & trialPos==i);
end
% Scatter by Lag
transDistVect = (seqLength-1)*-1:seqLength-1;
xLabel = cell(size(transDistVect));
for lag = 1:length(transDistVect)
    curTransDistHD = holdDur(trialTransDist==transDistVect(lag));
    if transDistVect(lag)==0
        xLabel{lag} = 'InSeq';
    else
        xLabel{lag} = sprintf('%i', transDistVect(lag));
    end
    if ~isempty(curTransDistHD)
        [lowCI, median, highCI] = CalculateMidAndCI2(curTransDistHD, 'Median');
        scatter(normrnd(1,0.05, [1,length(curTransDistHD)])+(lag-1), curTransDistHD);
        hold on;
        line([lag-0.2 lag+0.2], [lowCI lowCI], 'linewidth', 2, 'color', 'black', 'linestyle', ':');
        line([lag-0.2 lag+0.2], [median median], 'linewidth', 2, 'color', 'black');
        line([lag-0.2 lag+0.2], [highCI highCI], 'linewidth', 2, 'color', 'black', 'linestyle', ':');
    end
end
line([0 length(transDistVect)], [targHD targHD], 'linestyle', '--', 'linewidth', 1);
line([0 length(transDistVect)], [targHD+targSD targHD+targSD], 'linestyle', ':', 'linewidth', 1);
line([0 length(transDistVect)], [targHD-targSD targHD-targSD], 'linestyle', ':', 'linewidth', 1);
set(gca, 'xlim', [0 length(transDistVect)+1], 'ylim', [0 2], 'xtick', 1:length(xLabel),'xticklabel', xLabel);
ylabel('Hold Duration (s)');
xlabel([{'Transposition Distance'}; {'(Repeats = Positive)'}]);
title 'Hold Duration X Lag';