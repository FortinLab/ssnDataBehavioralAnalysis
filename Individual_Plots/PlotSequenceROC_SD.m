function PlotSequenceROC_SD(input)
%% PlotSequenceROC_SD
%
%   Create a plot of the ROC curves for Item and Position for sequence
%   behavior data stored in the ssnData format.
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
% Pull out Trial Performance
performance = [ssnData.Performance];
% Pull out Trial Position
trialPos = [ssnData.TrialPosition];
% Pull out Trial Odor
trialOdr = [ssnData.Odor];
% Identify InSeq Trials
inSeqLog = trialPos==trialOdr;
% Identify OutSeq Trials
outSeqLog = ~inSeqLog;
% Identify Sequence Length
seqLength = ssnData(1).Settings.SequenceLength;

%% Calculate Hit Rate and False Alarm Rates for Item and Position
hitRate = nan(1,seqLength);
itemFArate = nan(1,seqLength);
posFArate = nan(1,seqLength);
for i = 1:seqLength
    % InSeq Trials 
    curInSeqTrls = trialOdr==i & inSeqLog;
    hitRate(i) = mean(performance(curInSeqTrls));
    % OutSeq Trials by Item
    % FA rate is calculated using ~performance because it's meant to be the
    % % of trials they treat like InSeq
    curOutSeqItmTrls = trialOdr==i & outSeqLog;
    itemFArate(i) = mean(~performance(curOutSeqItmTrls));
    % OutSeq Trials by Position
    curOutSeqPosTrls = trialPos==i & outSeqLog;
    posFArate(i) = mean(~performance(curOutSeqPosTrls));
end

itmPlt = plot(itemFArate, hitRate, 'black-');
hold on;
posPlt = plot(posFArate, hitRate, 'b-.');
line([0 1], [0 1], 'color', 'black', 'linestyle', '--');
set(gca, 'xlim', [0 1], 'ylim', [0 1],...
    'xtick', 0:0.2:1, 'ytick', 0:0.2:1,...
    'DataAspectRatio',[1 1 1],'Layer','top');
legend([itmPlt posPlt], 'Item ROC', 'Position ROC', 'location', 'southeast');

for i = 1:seqLength
    text(itemFArate(i), hitRate(i), Rosetta{i}, 'color', 'black', 'fontsize', 12);
    text(posFArate(i), hitRate(i), num2str(i), 'color', 'blue', 'fontsize', 12);
end
title('Session ROC Space');
xlabel('False Alarm Rate');
ylabel('Hit Rate');

