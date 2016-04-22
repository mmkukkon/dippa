%----------------------------------
% REMEMBER TO DEFINE THE FILES FOR 
% * READING TRIGGERS AND EMG DATA
% * SAVING ACCEPTED TRIGGER POSITIONS
% * SAVING AMPLITUDE AND LATENCY DATA
% * SAVING SILENT PERIOD DATA
% * SAVING LOGFILE
%
% DEFINE ALSO
% * TRIGGER GRADIENT THRESHOLD
%----------------------------------

% Triggers for paired-pulses: TMS trig out -channels give the EMG device
% only one trigger pulse corresponding to the conditioning (first) pulse. 
% In case of paired-pulses, subtract the ISI from the time axis. 

%----------------------------------
% FOR USE AS A FUNCTION ONLY:
%
%----------------------------------

%function aja_emg(trig,emg)

%fs = 20000; %Hz, sampling frequency

%timeTrig = (1:1:length(trig))/fs;    %Time axis in seconds
%timeEmg = (1:1:length(emg))/fs;    %Time axis in seconds

%figure
%plot(timeTrig,trig)
%plot(trig,'o-')
%plot(trig)
%title('Trigger signal')
%xlabel('Time (sec)')
%xlabel('datapoints')
%ylabel('Voltage (\mu V)')

%triggerLength = length(trig)

%figure
%plot(timeEmg,emg)
%title('EMG signal')
%xlabel('Time (sec)')
%ylabel('Voltage (\mu V)')
%------------------------------------

trigfile = 'E:\Cortical excitability\Data\CE01_pp\EMG\mt_sp_c_EXP_1.TXT';
emgfile = 'E:\Cortical excitability\Data\CE01_pp\EMG\mt_sp_c_EXP_2.TXT';
logfile = 'E:\Cortical excitability\Data\CE01_pp\EMG_kasitelty\log_demo.TXT';

%--Select accepted trials and save the trigger positions of the accepted trials into a .mat file OR load a .mat file
%   with the accepted trigger positions:--

acceptedTrigPositions = emgSelectTrials(trigfile,emgfile,[-300 1500],[-300 0]);
save('E:\Cortical excitability\Data\CE01_pp\EMG_kasitelty\accepted_demo.mat','acceptedTrigPositions');
%load('E:\Cortical excitability\Data\CE01_pp\EMG_kasitelty\accepted_demo.mat');

[averageData,timeAxis,numTrials] = emgAverage(emgfile,acceptedTrigPositions,[-300 1500],[-300 0]);

figure
plot(timeAxis,averageData)
title('Average EMG response')
xlabel('Time (ms)')
ylabel('Voltage (\mu v)')

[amplitudes,latencies] = emgReadAmplitudes(emgfile,acceptedTrigPositions,[-50 150],[-50 0]);
save('E:\Cortical excitability\Data\CE01_pp\EMG_kasitelty\amplitudes_demo.mat','amplitudes');
%load('E:\Cortical excitability\Data\CE01_pp\EMG_kasitelty\amplitudes_demo.mat');
save('E:\Cortical excitability\Data\CE01_pp\EMG_kasitelty\latencies_demo.mat','latencies');
%load('E:\Cortical excitability\Data\CE01_pp\EMG_kasitelty\latencies_demo.mat');

figure
plot(amplitudes,'o')
title('Amplitudes')
figure
plot(latencies,'o')
title('Latencies')

meanAmpl = mean(amplitudes)
stdAmpl = std(amplitudes)
meanLat = mean(latencies)
stdLat = std(latencies)

%[spStart,spStop] = emgReadSilentPeriod(emgfile,acceptedTrigPositions,[-50 150],[-50 0]);
%save('E:\Cortical excitability\Data\CE01_pp\EMG_kasitelty\sp_start_pp3.mat','spStart');
%load('E:\Cortical excitability\Data\CE02_contraction_levels\EMG_kasitelty\sp_start_high.mat');
%save('E:\Cortical excitability\Data\CE01_pp\EMG_kasitelty\sp_stop_pp3.mat','spStop');
%load('E:\Cortical excitability\Data\CE02_contraction_levels\EMG_kasitelty\sp_stop_high.mat');

%spLength = abs(spStop-spStart);

%meanSpStart = mean(spStart)
%stdSpStart = std(spStart)
%meanSpStop = mean(spStop)
%stdSpStop = std(spStop)
%meanSpLength = mean(spLength)
%stdSpLength = std(spLength)

%Logfile entries:
today = date;
c = clock;

fid_log = fopen(logfile, 'wt');
fprintf(fid_log, date);
fprintf(fid_log, '\n');
fprintf(fid_log, 'Analyzed: Year Month Day Hour Minutes Seconds: ');
fprintf(fid_log, '%g ', clock);
%fprintf(fid_log, '\n\n Silent period lenth: %g +/- %g ms',meanSpLength,stdSpLength);
fprintf(fid_log, '\n MEP amplitude: %g +/- %g \mu V', meanAmpl, stdAmpl);
fprintf(fid_log, '\n MEP latency: %g +/- %g ms', meanLat, stdLat);
fclose(fid_log);