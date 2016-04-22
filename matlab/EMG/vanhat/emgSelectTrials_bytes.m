function accepted = emgSelectTrials(trigfile,emgfile,timeRange,baselineRange)

%Accept trial by pressing mouse button and reject trial by pressing 
%any key on the keyboard.
%                                      
%function accepted = emgSelectTrials(trigfile,emgfile,timeRange,baselineRange)
%
%trigfile - text file containing trigger data
%emgfile - text file containing emg data
%timeRange - in milliseconds e.g. [-100 500]
%baselineRange - in milliseconds e.g. [-100 0]

tPos = emgGetTriggers(trigfile);             %Get the positions of triggers in trigger file
n_accepted_triggers = length(tPos)

accepted = [];

more off;
for i=1:length(tPos)
    [emgData,timeEMG] = emgGetTrial(emgfile,tPos(i),timeRange,baselineRange);
    [trigData,timeTrig] = emgGetTrial(trigfile,tPos(i),timeRange,baselineRange);
    figure
    emgPlotData(timeEMG,timeTrig,emgData,trigData);
    button = waitforbuttonpress;
    if button==0,  
        accepted = [accepted;tPos(i)];
        disp(['Trial ' int2str(i) ', Accepted']);
    else
        disp(['Trial ' int2str(i) ', Rejected']);
    end
end