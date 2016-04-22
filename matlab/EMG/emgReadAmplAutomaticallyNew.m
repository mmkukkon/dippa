function amplitudes = emgReadAmplAutomaticallyNew(emgTrials,timeAxis,emgAccepted,fs,timeRange);

nTrials = size(emgTrials,1);
amplitudes = zeros(1,nTrials);

readStart = (timeRange(1)-timeAxis(1)+1)*fs/1000
readStop = (timeRange(2)-timeAxis(1)+1)*fs/1000

for i=1:nTrials
    lower = min(emgTrials(i,readStart:readStop));
    upper = max(emgTrials(i,readStart:readStop));
    plot(timeAxis,emgTrials(i,:))
    xlim(timeRange);
    title(['EMG response nr ',num2str(i),' (accepted = ',num2str(emgAccepted(i)),'): Mouse click to accept, keyboard to set ampl = 0'])
    xlabel('Time (ms)')
    ylabel('Voltage (\mu V)')
    button = waitforbuttonpress;
    if ~button %mouse click
        amplitudes(i)=abs(lower-upper);
    else %keyboard
        amplitudes(i) = 0;
    end
end

display('Amplitudes read automatically :)')