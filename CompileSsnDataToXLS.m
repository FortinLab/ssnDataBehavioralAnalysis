
curBehavDir = uigetdir;
cd(curBehavDir);
if curBehavDir==0
    disp('Analysis Cancelled')
    return
else  
    cd(curBehavDir)
end
dirContents = dir(curBehavDir);
fileNames = {dirContents.name};
fileLog = cellfun(@(a)~isempty(a), regexp(fileNames, '.mat'));

matFiles = fileNames(fileLog)';
dataColIDs = [{'SessionDateNumber'}, {'RatName'}, {'SessionID'}, {'NumberOfTrials'}, {'SequenceLength'},...
    {'SMI'}, {'SMI_NoFirstPosition'},...
    {'InSeq_Accuracy'}, {'InSeq_Correct_PokeDur'}, {'InSeq_Incorrect_PokeDur'},...
    {'OutSeq_Accuracy'}, {'OutSeq_Correct_PokeDur'}, {'OutSeq_Incorrect_PokeDur'},...
    {'Skip_Accuracy'}, {'Skip_Correct_PokeDur'}, {'Skip_Incorrect_PokeDur'},...
    {'Repeat_Accuracy'}, {'Repeat_Correct_PokeDur'}, {'Repeat_Incorrect_PokeDur'},...
    {'Lag-4_Accuracy'}, {'Lag-3_Accuracy'}, {'Lag-2_Accuracy'}, {'Lag-1_Accuracy'},...
        {'Lag0_Accuracy'}, {'Lag1_Accuracy'}, {'Lag2_Accuracy'}, {'Lag3_Accuracy'}, {'Lag4_Accuracy'},...
    {'Lag-4_PokeDur'}, {'Lag-3_PokeDur'}, {'Lag-2_PokeDur'}, {'Lag-1_PokeDur'},...
        {'Lag0_PokeDur'}, {'Lag1_PokeDur'}, {'Lag2_PokeDur'}, {'Lag3_PokeDur'}, {'Lag4_PokeDur'},...
    {'Lag-4_PokeDur_CorrOnly'}, {'Lag-3_PokeDur_CorrOnly'}, {'Lag-2_PokeDur_CorrOnly'}, {'Lag-1_PokeDur_CorrOnly'},...
        {'Lag0_PokeDur_CorrOnly'}, {'Lag1_PokeDur_CorrOnly'}, {'Lag2_PokeDur_CorrOnly'}, {'Lag3_PokeDur_CorrOnly'}, {'Lag4_PokeDur_CorrOnly'}];
flData = cell(length(matFiles), length(dataColIDs));

%
for fl = 1:length(matFiles)
    load(matFiles{fl});
    if isfield(ssnData(1).Settings, 'SequenceLength')
        seqLength = ssnData(1).Settings.SequenceLength;                         flData{fl,5} = seqLength;
        %% Load File & Extract Relevant Data
        flData{fl,4} = length(ssnData);
        
        trialPerf = [ssnData.Performance];
        trialPos = [ssnData.TrialPosition];
        trialOdr = [ssnData.Odor];
        trialTransDist = trialPos-trialOdr;
        trialPokeDuration = [ssnData.PokeDuration];
        
        % Extract Rat Name & Session ID
        ssnDateNum = datenum(ssnData(1).Settings.SessionDate, 'dd-mmm-yyyy');   flData{fl,1} = ssnDateNum;
        ratNameInput = ssnData(1).Settings.RatName;
        [ratNameStart, ratNameEnd] = regexp(ratNameInput, 'Age1');
        ratName = ratNameInput(ratNameStart:ratNameEnd+3);
        ratName(5) = '-';                                                       flData{fl,2} = ratName;
        [ssnNumStart, ssnNumEnd] = regexp(ratNameInput, 'Session([0-9]*)');
        ssnNum = ratNameInput(ssnNumStart:ssnNumEnd);                           flData{fl,3} = ssnNum;
        
        %% Create Logicals
        perfLog = trialPerf==1;
        inSeqLog = trialTransDist==0;
        outSeqLog = ~inSeqLog;
        skipLog = trialTransDist<0;
        repLog = trialTransDist>0;
        
        %% Fill in General Session Variables
        % SMI
        responseMatrixAll = [sum(perfLog(inSeqLog)), sum(~perfLog(inSeqLog));...
            sum(~perfLog(outSeqLog)), sum(perfLog(outSeqLog))];
        smiAll = CalculateSMI(responseMatrixAll);                               flData{fl,6} = smiAll;
        
        responseMatrixSFP = [sum(perfLog(inSeqLog & ~(trialPos==1))), sum(~perfLog(inSeqLog & ~(trialPos==1)));...
            sum(~perfLog(outSeqLog & ~(trialPos==1))), sum(perfLog(outSeqLog & ~(trialPos==1)))];
        smiSFP = CalculateSMI(responseMatrixSFP);                               flData{fl,7} = smiSFP;
        
        
        % InSeq
        inSeqAcc = nanmean(perfLog(inSeqLog));                                  flData{fl,8} = inSeqAcc;
        inSeqCorrectHoldDur = median(trialPokeDuration(inSeqLog & perfLog));    flData{fl,9} = inSeqCorrectHoldDur;
        inSeqIncorrectHoldDur = median(trialPokeDuration(inSeqLog & ~perfLog)); flData{fl,10} = inSeqIncorrectHoldDur;
        
        % OutSeq
        outSeqAcc = nanmean(perfLog(outSeqLog));                                flData{fl,11} = outSeqAcc;
        outSeqCorrectHoldDur = median(trialPokeDuration(~inSeqLog & perfLog));  flData{fl,12} = outSeqCorrectHoldDur;
        outSeqIncorrectHoldDur = median(trialPokeDuration(~inSeqLog & ~perfLog)); flData{fl,13} = outSeqIncorrectHoldDur;
        
        % Skips
        skipAcc = nanmean(perfLog(skipLog));                                    flData{fl,14} = skipAcc;
        skipCorrectHoldDur = median(trialPokeDuration(skipLog & perfLog));      flData{fl,15} = skipCorrectHoldDur;
        skipIncorrectHoldDur = median(trialPokeDuration(skipLog & ~perfLog));   flData{fl,16} = skipIncorrectHoldDur;
        
        % Repeats
        repeatAcc = nanmean(perfLog(repLog));                                   flData{fl,17} = repeatAcc;
        repeatCorrectHoldDur = median(trialPokeDuration(repLog & perfLog));     flData{fl,18} = repeatCorrectHoldDur;
        repeatIncorrectHoldDur = median(trialPokeDuration(repLog & ~perfLog));  flData{fl,19} = repeatIncorrectHoldDur;
        
        %% Calculate Performance & Hold Duration by Lag
        transDistVect = (5-1)*-1:5-1;
        for lag = 1:length(transDistVect)
            % Find relevant Columns
            accColLog = cellfun(@(a)~isempty(a), strfind(dataColIDs, sprintf('Lag%i_Accuracy', transDistVect(lag))));
            flData{fl,accColLog} = mean(perfLog(trialTransDist==transDistVect(lag)));
            holdDurCorOnlyLog = cellfun(@(a)~isempty(a), strfind(dataColIDs, sprintf('Lag%i_PokeDur_CorrOnly', transDistVect(lag))));
            holdDurAllLog = cellfun(@(a)~isempty(a), strfind(dataColIDs, sprintf('Lag%i_PokeDur', transDistVect(lag))));
            holdDurAllLog = holdDurAllLog & ~holdDurCorOnlyLog;
            flData{fl,holdDurAllLog} = median(trialPokeDuration(trialTransDist==transDistVect(lag)));
            flData{fl,holdDurCorOnlyLog} = median(trialPokeDuration(trialTransDist==transDistVect(lag) & perfLog));
        end
    else
        ssnDateNum = datenum(ssnData(1).Settings.SessionDate, 'dd-mmm-yyyy');   flData{fl,1} = ssnDateNum;
        flData{fl,5} = 'PokeAndHoldSession';
    end
    clear ssnData
end
flData = sortrows(flData,1);
flData = [dataColIDs; flData];
%
xlswrite([fileparts(cd) '\Age1_Past_Summary.xls'], flData, ratName)