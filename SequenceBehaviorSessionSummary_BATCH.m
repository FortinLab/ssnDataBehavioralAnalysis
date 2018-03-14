function SequenceBehaviorSessionSummary_BATCH(input)
%% SequenceBehaviorSessionSummary_BATCH
%
% Batch processing for SequenceBehaviorSessionSummary
%
%% Check Inputs
origDir = cd;    
if nargin == 0
    % If isempty(Input) use uigetdir to load the ssnData .mat file
    [fileDir] = uigetdir(origDir);
elseif ischar(input)
    % If Input=string with .mat on the end load that file
elseif isstruct(input)
    error('Pass directory, not ssnData file directly');
    % If Input=struct just use that structure
else
    disp('Unknown input, either pass nothing, the ssnData file location or the data structure itself');
    return;
end

if fileDir==0
    disp('Analysis Cancelled')
    return
else  
    cd(fileDir)
end
dirContents = dir(fileDir);
fileNames = {dirContents.name};
behFileLog = cellfun(@(a)~isempty(a), regexp(fileNames, '.mat'));
behFiles = fileNames(behFileLog)';

%% Run it all

for fl = 1:length(behFiles)
    SequenceBehaviorSessionSummary(behFiles{fl});
    close all;
end