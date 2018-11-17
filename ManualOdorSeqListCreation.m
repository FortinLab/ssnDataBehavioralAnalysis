function ManualOdorSeqListCreation

listCreationFig = figure;
global curSeqList seqsListBox seqs

seqs = struct('InSeqFam', [1 2 3 4],...
    'A2Fam', [1 1 3 4], 'A3Fam', [1 2 1 4], 'A4Fam', [1 2 3 1], 'B3Fam', [1 2 2 4], 'B4Fam', [1 2 3 2],'C4Fam', [1 2 3 3],...
    'D3Fam', [1 2 4 4], 'D2Fam', [1 4 3 4], 'C2Fam', [1 3 3 4],...
    'InSeqNov', [11 12 13 14],...
    'A2Nov', [11 11 13 14], 'A3Nov', [11 12 11 14], 'A4Nov', [11 12 13 11],'B3Nov', [11 12 12 14], 'B4Nov', [11 12 13 12], 'C4Nov', [11 12 13 13],...
    'D3Nov', [11 12 14 14], 'D2Nov', [11 14 13 14], 'C2Nov', [11 13 13 14]);

%% 

seqsListBox = uicontrol(listCreationFig, 'Units', 'Normalized', 'Style', 'listbox', 'String', fieldnames(seqs),...
    'Position', [0.0465, 0.21, 0.4, 0.71]);

curSeqList = uicontrol(listCreationFig, 'Units', 'Normalized', 'Style', 'listbox', 'String', [],...
    'Position', [0.51, 0.21, 0.4, 0.71]);

addSeqBtn = uicontrol(listCreationFig, 'Units', 'Normalized', 'Style', 'pushbutton', 'String', 'Add Sequence',...
    'Position', [0.0465, 0.12, 0.4, 0.07], 'Callback', @addSeq);

rmvSeqBtn = uicontrol(listCreationFig, 'Units', 'Normalized', 'Style', 'pushbutton', 'String', 'Add Sequence',...
    'Position', [0.51, 0.12, 0.4, 0.07], 'Callback', @rmvSeq);

saveList = uicontrol(listCreationFig, 'Units', 'Normalized', 'Style', 'pushbutton', 'String', 'Add Sequence',...
    'Position', [0.0465, 0.02, 0.8635, 0.07], 'Callback', @svList);

end
%%
function addSeq(source,event) 
    global curSeqList seqsListBox seqs
    seqListVal = seqsListBox.Value;
    seqList = seqsListBox.String{seqListVal};

    curSeqList.String = [curSeqList.String; {seqList}];
    curSeqList.UserData = [curSeqList.UserData; {seqs.(seqList)}];
end

function rmvSeq(source,event) 
    global curSeqList
    curSeqListVal = curSeqList.Value;
    if curSeqListVal == length(curSeqList.String)
        if length(curSeqList.String)>=2
            curSeqList.Value = curSeqList.Value-1;
            curSeqList.String(curSeqListVal) = [];
            curSeqList.UserData(curSeqListVal) = [];
        else
            curSeqList.String = [];
            curSeqList.UserData = [];
            curSeqList.Value = 1;
        end
    else       
        curSeqList.String(curSeqListVal) = [];
        curSeqList.UserData(curSeqListVal) = [];
    end    
end

function svList(source,event)
    global curSeqList
    odorSeqList = curSeqList.UserData; %#ok<NASGU>
    outputFileName = inputdlg('Determine File Name', 'Filename', 1, 'Odorlist');
    save([outputFileName{1} '.mat'], 'odorSeqList');
end
