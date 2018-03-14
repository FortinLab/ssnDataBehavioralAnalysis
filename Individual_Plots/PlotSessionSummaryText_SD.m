function PlotSessionSummaryText_SD(input)
%% PlotSessionSummaryText_SD
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

%% Extract Data
% Pull out Sequence Number
% seqNum = [ssnData.SequenceNumber];
% Pull out Trial Hold Durations
holdDur = [ssnData.PokeDuration];
% Pull out Trial Target Durations
targDur = [ssnData.TargetPokeDur];
% Pull out Trial Reaction Times
reactionTime = targDur-holdDur;
% Pull out Trial Performance
performance = [ssnData.Performance];
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
skipLog = [ssnData.TranspositionDistance]<0;
% Identify Repeat Trials
repLog = [ssnData.TranspositionDistance]>0;
% Identify TransIn Trials
% Identify TransIn-Rep Trials
% Identify TransIn-Skp Trials
% Identify Skip Dupe Trials

% Rat Name
ratNameStrParts = strsplit(ssnData(1).Settings.RatName, '_');
ratName = ratNameStrParts{1};
% Session #
session = ratNameStrParts{2};
% List Used
if isfield(ssnData(1).Settings, 'SequenceList')
    listName = ssnData(1).Settings.SequenceList;
else
    listName = 'Check .txt';
end
% Target Duration +/- StDev Value
targHD = ssnData(1).Settings.StartingPokeDur;
if isfield(ssnData(1).Settings, 'PokeDurSD')
    targSD = ssnData(1).Settings.PokeDurSD;
else
    targSD = 0;
end
% Short Poke Buffer Dur
buffDur = ssnData(1).Settings.ShortPokeBuffer;
% # Repeats
if isfield(ssnData(1).Settings, 'TransTrlErrorRep')
    numReps = ssnData(1).Settings.TransTrlErrorRep;
else
    numReps = nan;
end
% Sequence Length
seqLength = ssnData(1).Settings.SequenceLength;

ssnDate = ssnData(1).Settings.SessionDate;

%% Calculate Session Variables
% SMI
responseMatrixAll = [sum(performance(inSeqLog)), sum(~performance(inSeqLog));...
    sum(~performance(outSeqLog)), sum(performance(outSeqLog))];
smiAll = CalculateSMI(responseMatrixAll);

responseMatrixSFP = [sum(performance(inSeqLog & ~(trialPos==1))), sum(~performance(inSeqLog & ~(trialPos==1)));...
    sum(~performance(outSeqLog & ~(trialPos==1))), sum(performance(outSeqLog & ~(trialPos==1)))];
smiSFP = CalculateSMI(responseMatrixSFP);

smiByItem = nan(1,seqLength);
smiByPos = nan(1,seqLength);
for i = 1:seqLength
    tempResponseMatrixItm = [sum(performance(inSeqLog & trialOdr==i)), sum(~performance(inSeqLog & trialOdr==i));...
        sum(~performance(outSeqLog & trialOdr==i)), sum(performance(outSeqLog & trialOdr==i))];
    smiByItem(i) = CalculateSMI(tempResponseMatrixItm);

    tempResponseMatrixPos = [sum(performance(inSeqLog & trialPos==i)), sum(~performance(inSeqLog & trialPos==i));...
        sum(~performance(outSeqLog & trialPos==i)), sum(performance(outSeqLog & trialPos==i))];
    smiByPos(i) = CalculateSMI(tempResponseMatrixPos);
end

% Accurary
overallAcc = mean(performance)*100;
inSeqAcc = mean(performance(inSeqLog))*100;
outSeqAcc = mean(performance(outSeqLog))*100;
skipAcc = mean(performance(skipLog))*100;
repAcc = mean(performance(repLog))*100;


%% Plot text stuff
set(gca, 'xlim', [0 5], 'ylim', [0 13.5]);
axis(gca, 'off');
text(2.5,15, sprintf('Animal: %s', ratName), 'horizontalalignment', 'center');
text(2.5,14.2, sprintf('Session: %s', session), 'horizontalalignment', 'center');
text(2.5,13.4, sprintf('Date: %s', ssnDate), 'horizontalalignment', 'center');
text(0,12, sprintf('Overall Accuracy: %.2f%%', overallAcc));
text(0.25, 11.2, sprintf('InSeq: %.2f%%', inSeqAcc));
text(0.25, 10.4, sprintf('OutSeq: %.2f%%', outSeqAcc));
text(0.5,9.6, sprintf('Skip Accuracy: %.2f%%', skipAcc));
text(0.5,8.8, sprintf('Repeat Accuracy: %.2f%%', repAcc));
% text(0,10, sprintf('Percentage of Completed Sequence Blocks = %.2f%%', seqCompRateAll));
% text(0.5, 9.5, sprintf('InSeq Sequences Complete = %.2f%%', seqCompRateInSeq));
% text(0.5, 9, sprintf('OutSeq Sequences Complete = %.2f%%', seqCompRateOutSeq));
% text(1, 8.5, sprintf('Sequences with Skips Complete = %.2f%%', seqCompRateSkip));
% text(1, 8, sprintf('Sequences with Repeats Complete = %.2f%%', seqCompRateRepeat));
text(0,7, 'Performance Matrix:');
text(1,6.2, sprintf('%i  %i', responseMatrixAll(1,1), responseMatrixAll(1,2)), 'horizontalalignment', 'center');
text(1,5.4, sprintf('%i  %i', responseMatrixAll(2,1), responseMatrixAll(2,2)), 'horizontalalignment', 'center');
text(0,4, 'Sequence Memory Index (SMI):');
text(0.5,3.2, sprintf('All Trials: %.2f', smiAll));
text(0.5,2.4, sprintf('First Position Skipped: %.2f', smiSFP));
text(0,1, sprintf('List = %s', listName));

    