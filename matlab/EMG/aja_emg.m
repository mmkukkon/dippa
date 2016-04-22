%----------------------------------
% Remember to define the... 
% * Experiment directory
% * Files containing EMG and trigger data
%
% And save/load...
% * Matrix containing selected trials
%
% You can also save...
% * MEP amplitudes/latencies
% * Silent period start/stop times
% * Trigger positions (all triggers, emgSelectTrials.m)
% * Logfile containing amplitude, latency and silent period
%   information
%
% Sometimes you need to check...
% * Trigger gradient threshold (emgGetTriggers.m), if not all triggers are
%   detected/ some are detected several times
%----------------------------------

%-----Triggering from TMS device---
% Triggers for paired-pulses: TMS trig out -channels give the EMG device
% only one trigger pulse corresponding to the conditioning (first) pulse. 
% In case of paired-pulses, subtract the ISI from the time axis. 
%----------------------------------

% %Files and directories:
% dir = 'E:\Auditory masking\AM01\';  %Experiment directory
% dir = 'E:\MEP sorting\MEP06b\';  %Experiment directory
% dir = 'E:\Topographical mapping\TM04\';  %Experiment directory
keno = '/';
% dir = '/proj/tms/Topographical mapping/TM01b/';  %Experiment directory
dir = '/proj/tms/Auditory masking/AM01/'; 
input_dir = [dir,'EMG',keno];       %Experiment directory containing raw input EMG files
output_dir = [dir,'EMG_kasitelty',keno];    %Output directory
trigfile = [input_dir,'h0s_EXP_1.TXT'];     %Input trigger file name
emgfile = [input_dir,'h0s_EXP_3.TXT'];      %Input EMG file name
output_name = '0s_ADM';    %output name defining the condition (e.g. control, contraction...)
% logfile = [output_dir,'log_',output_name,'.txt'];   %logfile for saving results

%--Select accepted trials and save them into a .mat file OR load a .mat file
%   with the accepted trials
try 
    load([output_dir,'emgtrials_',output_name,'.mat']);
    load([output_dir,'timeAxis.mat']);
catch
    [emgTrials,timeAxis] = emgSelectTrials(trigfile,emgfile,output_dir,output_name,[-200 1000],[-200 0]);  %emgTrials (trials x samples)
    save([output_dir,'emgtrials_',output_name,'.mat'],'emgTrials');
    save([output_dir,'timeAxis.mat'],'timeAxis');
end

boksi = msgbox('Select the TMS artefact latency in the following plot by clicking with mouse!','Message!');
uiwait(boksi);

%Find the time of the TMS pulse:
fig = figure;
plot(timeAxis,emgTrials(1,:))
title('Select the TMS artefact latency!')
xlabel('Time (ms)')
ylabel('Voltage (\mu V)')
datacursormode on;
dcm_obj = datacursormode(fig);
button = waitforbuttonpress;
info_struct = getCursorInfo(dcm_obj);
info_struct_cell = struct2cell(info_struct);
info_mat = cell2mat(info_struct_cell(2));
latency_TMS = info_mat(1);

%Average the accepted trials
% averageData = mean(emgTrials);
% save([output_dir,'average_',output_name,'.mat'],'averageData');
% figure
% plot(timeAxis,averageData)
% title('Average EMG response')
% xlabel('Time (ms)')
% ylabel('Voltage (\mu v)')

boksi = msgbox('Select the accepted (mouse) / rejected (keyboard) trials!','Message!');
uiwait(boksi);

%Select the accepted/rejected trials:
try 
    load([output_dir,'acceptedEmg_',output_name,'.mat']);
catch
    emgAccepted = ones(1,size(emgTrials,1));
    figure
    for i=1:size(emgTrials,1)
        plot(timeAxis,emgTrials(i,:))
        title('Select accepted(mouse) / rejected(keyboard) trials')
        xlabel('Time (ms)')
        ylabel('Voltage (\mu V)')
        xlim([max(timeAxis(1),latency_TMS-100) latency_TMS+100]);
        button = waitforbuttonpress;
        if button==0,  
            disp(['Trial ' int2str(i) ', Accepted']);
        else
            emgAccepted(i) = 0;
            disp(['Trial ' int2str(i) ', Rejected']);
        end
    end
    save([output_dir,'acceptedEmg_',output_name,'.mat'],'emgAccepted');
end

nAcceptedEmgTrials = sum(emgAccepted)

%Read MEP amplitudes and latencies of each trial by clicking with mouse
% [amplitudes,latencies] = emgReadAmplitudes(emgTrials,timeAxis,[latency_TMS+15 latency_TMS+45],output_dir);
% save([output_dir,'amplitudes_',output_name,'.mat'],'amplitudes');
%load([output_dir,'amplitudes_',output_name,'.mat']);

% % save([output_dir,'latencies_',output_name,'.mat'],'latencies');
% %load([output_dir,'latencies_',output_name,'.mat']);

% boksi = msgbox('Check the responses! The program will calculate response amplitude automatically. (|min-max| value visible in the plot)','Message!');
% uiwait(boksi)

%Define amplitudes automatically: 
try 
    load([output_dir,'amplitudes_',output_name,'.mat']);
catch
    %Hyvi� v�lej�: [408 418], [10 25], [808 818]
    amplitudes = emgReadAmplAutomatically(emgTrials,timeAxis,emgAccepted,[latency_TMS+15 latency_TMS+45]);
    save([output_dir,'amplitudes_',output_name,'.mat'],'amplitudes');
end

%------------
inds = [5 16 30 43 46 49];
figure
for i=1:length(inds)
    plot(timeAxis,emgTrials(inds(i),:))
    xlim([latency_TMS+15 latency_TMS+45])
    [lats,ampls]=ginput(2);
    amplitudes(inds(i))=abs(ampls(1)-ampls(2));
end
%-----------

%Plots the amplitudes:
figure
for i=1:size(emgTrials,1)
    if emgAccepted(i)
        plot(i,amplitudes(i),'bo')
        hold on
    else
        plot(i,amplitudes(i),'ro')
        hold on
    end
end
xlabel('Trial #','FontSize',14,'Position',[80 -33 1])
ylabel('Amplitude (\mu V)','FontSize',14,'Position',[-15 250 1])
tick2text(gca);
hx = getappdata(gca, 'XTickText');
hy = getappdata(gca, 'YTickText');
set(hx,'FontSize',14)
set(hy,'FontSize',14)

[sortedAmplitudes,sortIndex] = sort(amplitudes);
sortedAcceptedEmg = emgAccepted(sortIndex);
figure
for i=1:size(emgTrials,1)
    if sortedAcceptedEmg(i)
        plot(i,sortedAmplitudes(i),'bo')
        hold on
    else
        plot(i,sortedAmplitudes(i),'ro')
        hold on
    end
end
xlabel('Sorted trial #','FontSize',14,'Position',[80 -33 1])
ylabel('Amplitude (\mu V)','FontSize',14,'Position',[-15 250 1])
tick2text(gca);
hx = getappdata(gca, 'XTickText');
hy = getappdata(gca, 'YTickText');
set(hx,'FontSize',14)
set(hy,'FontSize',14)
plot([0 length(amplitudes)],[50 50],'g')


%Plot accepted amplitudes: 
amplitudesAccepted = amplitudes(find(emgAccepted));
[sortedAccepted,sortIndexAcc] = sort(amplitudesAccepted);
figure
plot(sortedAccepted,'ko')
xlabel('Trial')
ylabel('MEP amplitude (\muV)')

% figure
% plot(latencies,'o')
% title('Latencies')
% xlabel('Trial #')
% ylabel('Latency (ms)')

meanAmpl = mean(amplitudes)
stdAmpl = std(amplitudes)
% meanLat = mean(latencies)
% stdLat = std(latencies)

% %Read EMG silent period start and stop time using mouse
% [spStart,spStop] = emgReadSilentPeriod(emgTrials,timeAxis,[-10,200]);
% save([output_dir,'sp_start_',output_name,'.mat'],'spStart');
% %load([output_dir,'sp_start_',output_name,'.mat']);
% save([output_dir,'sp_stop_',output_name,'.mat'],'spStop');
% %load([output_dir,'sp_stop_',output_name,'.mat']);
% 
% spLength = abs(spStop-spStart);
% 
% meanSpStart = mean(spStart)
% stdSpStart = std(spStart)
% meanSpStop = mean(spStop)
% stdSpStop = std(spStop)
% meanSpLength = mean(spLength)
% stdSpLength = std(spLength)

% %Logfile entries:
% today = date;
% c = clock;
% 
% fid_log = fopen(logfile, 'wt');
% fprintf(fid_log, date);
% fprintf(fid_log, '\n');
% fprintf(fid_log, 'Analyzed: Year Month Day Hour Minutes Seconds: ');
% fprintf(fid_log, '%g ', clock);
% fprintf(fid_log, '\n');
% fprintf(fid_log, '\n %s', emgfile);
% % fprintf(fid_log, '\n\n Silent period lenth: %g +/- %g ms',meanSpLength,stdSpLength);
% fprintf(fid_log, '\n MEP amplitude: %g +/- %g \mu V', meanAmpl, stdAmpl);
% % fprintf(fid_log, '\n MEP latency: %g +/- %g ms', meanLat, stdLat);
% fclose(fid_log);