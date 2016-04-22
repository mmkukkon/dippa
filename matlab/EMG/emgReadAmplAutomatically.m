function amplitudes = emgReadAmplAutomatically(emgTrials,timeAxis,emgAccepted,timeRange);

nTrials = size(emgTrials,1);
amplitudes = zeros(1,nTrials);

fs = 20;    %kHz, sample frequency

readStart = (timeRange(1)-timeAxis(1)+1)*fs;
readStop = (timeRange(2)-timeAxis(1)+1)*fs;

for i=1:nTrials
    lower = min(emgTrials(i,readStart:readStop));
    upper = max(emgTrials(i,readStart:readStop));
    plot(timeAxis,emgTrials(i,:))
    xlim(timeRange);
    title(['EMG response nr ',num2str(i),' (accepted = ',num2str(emgAccepted(i)),'): Press any button to show next response'])
    xlabel('Time (ms)')
    ylabel('Voltage (\mu V)')
    button = waitforbuttonpress;
    amplitudes(i)=abs(lower-upper);
end

display('Amplitudes read automatically :)')