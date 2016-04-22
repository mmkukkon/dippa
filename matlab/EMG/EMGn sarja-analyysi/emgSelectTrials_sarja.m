function [emgTrials,timeAxis] = emgSelectTrials_sarja(trigfile,emgfile,output_dir,output_name,timeRange,baselineRange)

tPos = emgGetTriggers(trigfile)             %Get the positions of triggers in trigger file
save([output_dir,'tPos_',output_name,'.mat'],'tPos');
% load([output_dir,'tPos_',output_name,'.mat']);
n_triggers = length(tPos)

%Gets rid of duplicate triggers (emgGetTriggers sometimes registers the
%same trigger twice):
acceptedTPos = tPos(1);
diffBetweenTriggers = diff(tPos);
for i = 1:n_triggers-1
    if diffBetweenTriggers(i)>1
        acceptedTPos = [acceptedTPos tPos(i+1)];
    end
end
n_accepted_triggers = length(acceptedTPos)
tPos = acceptedTPos;
clear 'acceptedTPos';

emgAllTrials = [];
trigAllTrials = [];

%Reads the trials from the file at the accepted trigger positions:
scrsz = get(0,'ScreenSize');
figure('Position',[1 2*scrsz(4)/3 2*scrsz(3)/3 2*scrsz(4)/3]);
hold off
for i=1:length(tPos)
    [emgData,timeEMG] = emgGetTrial(emgfile,tPos(i),timeRange,baselineRange);
    emgAllTrials = [emgAllTrials; emgData'];
    [trigData,timeTrig] = emgGetTrial(trigfile,tPos(i),timeRange,baselineRange);
    trigAllTrials = [trigAllTrials; trigData'];
end
save([output_dir,'allTrials_',output_name,'.mat'],'emgAllTrials');
save([output_dir,'trigData_',output_name,'.mat'],'trigAllTrials');
save([output_dir,'timeEMG_',output_name,'.mat'],'timeEMG');
save([output_dir,'timeTrig_',output_name,'.mat'],'timeTrig');

emgTrials = emgAllTrials;
timeAxis = timeEMG;