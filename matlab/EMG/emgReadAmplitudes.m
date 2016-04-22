function [amplitudes,latencies] = emgReadAmplitudes(emgTrials,timeAxis,timeRange,output_dir);

nTrials = size(emgTrials,1);
amplitudes = zeros(1,nTrials);
latencies = zeros(1,nTrials);

scrsz = get(0,'ScreenSize');
fig = figure('Position',[1 scrsz(4) scrsz(3) scrsz(4)]);

i = 1;
redefine = 1;
while redefine
    while i<=nTrials
        plot(timeAxis,emgTrials(i,:))
        xlim(timeRange);
        title(['EMG response nr ',num2str(i),': Select the EMG response minimum and maximum {\bf AMPLITUDE} in any order using cursor, press SPACE to correct previous'])
        xlabel('Time (ms)')
        ylabel('Voltage (\mu V)')
        [lat,ampl,button] = ginput(2);
        
        %Reading the minimum amplitude and latency of EMG response: 
        if button(1)==1&&button(2)==1
            amplitudes(i) = abs(ampl(1)-ampl(2));
            [min_ampl, min_lat] = min(ampl);
            lower = lat(min_lat);
            if min_lat == 1
                upper = lat(2);
            else
                upper = lat(1);
            end
            latencies(i) = min([lower upper]);
        else
            i=i-1;
            continue
        end    
        i=i+1;
    end
    dlgButton = questdlg('Accept the amplitudes or redefine the last one','Continue?','Accept','Redefine','Accept');
    redefine = strcmp('Redefine',dlgButton);
    i=i-1;
end

display('Amplitudes and latencies read :)')