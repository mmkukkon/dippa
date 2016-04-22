function ranska_aja_emg(data);

close all;

%load 'E:\Cortical excitability\Bonnard_data\cecexp\CECCOM1.EXP';
%data = CECCOM1;

fs = 4000;  %Hz
time = (1:1:size(data,1))/fs;    %Time axis in seconds
size(data,1)

trig = data(:,1);
movement = data(:,2);
emg_flex = data(:,4);
emg_ext = data(:,5);

figure
plot(trig)
title('Trigger signal')
%xlabel('Time (s)')
xlabel('Datapoints')
ylabel('Voltage (V)')

figure
plot(time,movement)
title('Movement')
xlabel('Time (s)')
ylabel('FLEXION -- Degrees -- EXTENSION')

figure
plot(time,emg_flex)
title('EMG signal of flexor carpi radialis')
xlabel('Time (s)')
ylabel('Voltage (mV)')

figure
plot(time,emg_ext)
title('EMG signal of extensor carpi radialis')
xlabel('Time (s)')
ylabel('Voltage (mV)')

%-------------------------------------------------%

acceptedTrigPositions = emgSelectTrials(trigfile,emgfile,[-300 1500],[-300 0]);
save('E:\Cortical excitability\Bonnard_data\cecexp\trig_positions.mat','acceptedTrigPositions');
%load('E:\Cortical excitability\Data\CE01_test\EMG_kasitelty\trig_positions.mat');