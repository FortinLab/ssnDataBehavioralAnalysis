function SequenceBehaviorSessionSummary(input)
%% SequenceBehaviorSessionSummary
%   Behavioral summary figure for sequence training using ssnData Structure

%%
load('Rosetta.mat');
%% Check Input
if nargin == 0
    % If isempty(Input) use uiopen to load the ssnData .mat file
    uiopen('.mat');
elseif ischar(input) && ~isempty(strfind(input,'.mat'))
    % If Input=string with .mat on the end load that file
    load(input);
elseif isstruct(input)
    % If Input=struct just use that structure
else
    disp('Unknown input, either pass nothing, the ssnData file location or the data structure itself');
    return;
end

if ~isfield(ssnData, 'Odor')
    disp([input ' is a PnH session, skipping']);
    return;
end

if length(ssnData)<20
    disp([input ' Has <20 trials, skipping']);
    return;
end

if isnan(ssnData(end).TranspositionDistance)
    ssnData = ssnData(1:end-1);
end

%% Create Figure
scrsz = get(0,'ScreenSize');
sumFig = figure('Position', [scrsz(3)/2 30 scrsz(3)/2 scrsz(4)/2.33], 'Name', ssnData(1).Settings.RatName, 'NumberTitle', 'off'); % <--- To Scale

%% Plot session information in text box
subplot(2,3,1)
PlotSessionSummaryText_SD(ssnData);

%% Transposition Matrix
subplot(2,3,2);
PlotTranspositionMatrix_SD(ssnData);

%% ROC Curves 
subplot(2,3,3);
PlotSequenceROC_SD(ssnData);
    
%% Hold Duration Plots
subplot(2,3,4)
PlotHoldDurByLag_SD(ssnData);

%% Reaction Time Histograms
subplot(2,3,5)
PlotReactionTimeHistogram_SD(ssnData)

%% Reaction Time vs Hold Duration Correlation
subplot(2,3,6)
PlotHoldDurReactTimeCorr_SD(ssnData);

%% Save Figure
set(sumFig, 'PaperOrientation', 'landscape');
print('-fillpage', sumFig, '-dpdf', [ssnData(1).Settings.RatName '_' ssnData(1).Settings.SessionDate '.pdf']);