function PlotHoldDurReactTimeCorr_SD(input)
%% PlotHoldDurReactTimeCorr_SD
%
%
%   03/13/2018  Created by GE
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

%% Pull out Variables
% Pull out Trial Hold Durations
holdDur = [ssnData.PokeDuration];
% Pull out Trial Target Durations
targDur = [ssnData.TargetPokeDur];
% Pull out Trial Reaction Times
reactionTime = holdDur-targDur;
% Pull out Performance
perfLog = [ssnData.Performance]==1;
% Pull out InSeq Trials Only
inSeqLog = [ssnData.TranspositionDistance]==0;

corrScatPlot(targDur(perfLog & inSeqLog), reactionTime(perfLog & inSeqLog), 'Hold Duration', 'Reaction Time', []);
title([{'Target Duration vs. Reaction Time'}; {'InSeq Correct Trials'}]);
