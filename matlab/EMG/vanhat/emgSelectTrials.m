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

tPos = emgGetTriggers(trigfile)             %Get the positions of triggers in trigger file
save('E:\Cortical excitability\Data\CE01_pp\EMG_kasitelty\tPos_pp3.mat','tPos')
%load('E:\Cortical excitability\Data\CE01_pp\EMG_kasitelty\tPos_pp3.mat')
n_accepted_triggers = length(tPos)

accepted = [];

scrsz = get(0,'ScreenSize');
figure('Position',[1 2*scrsz(4)/3 2*scrsz(3)/3 2*scrsz(4)/3]);
hold off
for i=1:length(tPos)
    [emgData,timeEMG] = emgGetTrial(emgfile,tPos(i),timeRange,baselineRange);
    [trigData,timeTrig] = emgGetTrial(trigfile,tPos(i),timeRange,baselineRange);
    emgPlotData(timeEMG,timeTrig,emgData,trigData,i);
    
    button = waitforbuttonpress;
    if button==0,  
        accepted = [accepted;tPos(i)];
        disp(['Trial ' int2str(i) ', Accepted']);
    else
        disp(['Trial ' int2str(i) ', Rejected']);
    end
end