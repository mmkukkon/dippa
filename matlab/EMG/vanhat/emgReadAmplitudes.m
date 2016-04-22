function [amplitudes,latencies] = emgReadAmplitudes(emgfile,tPos,timeRange,baselineRange);

amplitudes = zeros(1,length(tPos));
latencies = zeros(1,length(tPos));

scrsz = get(0,'ScreenSize');
fig = figure('Position',[1 scrsz(4) scrsz(3) scrsz(4)]);

i = 1;
redefine = 1;
while redefine
    while i<=length(tPos)
        [data,time] = emgGetTrial(emgfile,tPos(i),timeRange,baselineRange);
        plot(time,data)
        title(['EMG response nr ',num2str(i),': Select the EMG response minimum (first) and maximum {\bf AMPLITUDE} using cursor, press SPACE to correct previous'])
        xlabel('Time (ms)')
        ylabel('Voltage (\mu V)')
        datacursormode on;
        dcm_obj = datacursormode(fig);
    
        %Reading the minimum amplitude and latency of EMG response: 
        button = waitforbuttonpress;
        if button == 0
            info_struct = getCursorInfo(dcm_obj);
            info_struct_cell = struct2cell(info_struct);
            lowerLat=cell2mat(info_struct_cell(2));
            lower = lowerLat(2);
            latencies(i) = lowerLat(1);
        else
            i=i-1;
            continue
        end
    
        %Reading the maximum amplitude of EMG response: 
        button = waitforbuttonpress;
        if button == 0
            info_struct = getCursorInfo(dcm_obj);
            info_struct_cell = struct2cell(info_struct);
            upperLat=cell2mat(info_struct_cell(2));
            upper = upperLat(2);
        else
            continue
        end
    
        amplitudes(i)=abs(lower-upper);
        i=i+1;
    end
    dlgButton = questdlg('Accept the amplitudes or redefine the last one','Continue?','Accept','Redefine','Accept');
    redefine = strcmp('Redefine',dlgButton);
    i=i-1;
end

display('Amplitudes and latencies read :)')