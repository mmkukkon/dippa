function emgPlotData(timeEMG,timeTrig,emgData,trigData,trialNum)

%emgPlotData(timeEMG,timeTrig,emgData,trigData)
%
%tAxis - time scale in ms, e.g. -100...500ms
%data - data vector
%emgData - EMG data vector
%trigData - trigger data vector
%trialNum - number of trial

if nargin<4, end

subplot(2,1,1)
plot(timeEMG,emgData)
title(['Trial no ',num2str(trialNum)]);
ylabel('Voltage (\mu V)')
subplot(2,1,2)
plot(timeTrig,trigData,'k')
xlabel('Time (ms)')