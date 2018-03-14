function PlotReactionTimeHistogram_SD(input)
%% PlotReactionTimeHistogram_SD
%
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
%% Pull out Variables
% Pull out Trial Hold Durations
holdDur = [ssnData.PokeDuration];
% Pull out Trial Target Durations
targDur = [ssnData.TargetPokeDur];
% Pull out Trial Reaction Times
reactionTime = holdDur-targDur;

%% Plot Stuff
histogram(reactionTime, -0.95:0.05:0.95);
set(gca, 'xlim', [-1 1]);
title('Decision Latency');
xlabel([{'Withdraw Latency'}; {'From Decision Threshold (s)'}]);
ylabel('Number of Trials');