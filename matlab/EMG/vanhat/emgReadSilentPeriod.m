function [spStart,spStop] = emgReadSilentPeriod(emgfile,tPos,timeRange,baselineRange);

spStart = zeros(1,length(tPos));
spStop = zeros(1,length(tPos));

scrsz = get(0,'ScreenSize');
fig = figure('Position',[1 scrsz(4) scrsz(3) scrsz(4)]);

i = 1;
redefine = 1;
while redefine
    while i<=length(tPos)
        [data,time] = emgGetTrial(emgfile,tPos(i),timeRange,baselineRange);
        plot(time,data)
        title(['EMG response nr ',num2str(i),': Select the {\bf SILENT PERIOD} start (first) and end time using cursor, press SPACE to correct previous'])
        xlabel('Time (ms)')
        ylabel('Voltage (\mu V)')
        datacursormode on;
        dcm_obj = datacursormode(fig);
    
        %Reading the start time of silent period: 
        button = waitforbuttonpress;
        if button == 0
            info_struct = getCursorInfo(dcm_obj);
            info_struct_cell = struct2cell(info_struct);
            cursorCoordinates=cell2mat(info_struct_cell(2));
            spStart(i) = cursorCoordinates(1);
        else
            i=i-1;
            continue
        end
    
        %Reading the end time of silent period: 
        button = waitforbuttonpress;
        if button == 0
            info_struct = getCursorInfo(dcm_obj);
            info_struct_cell = struct2cell(info_struct);
            cursorCoordinates=cell2mat(info_struct_cell(2));
            spStop(i) = cursorCoordinates(1);
        else
            continue
        end
        
        i=i+1;
        spStart
        spStop
    end
    dlgButton = questdlg('Accept the SP or redefine the last one','Continue?','Accept','Redefine','Accept');
    redefine = strcmp('Redefine',dlgButton);
    i=i-1;
end

display('Silent period read :D')