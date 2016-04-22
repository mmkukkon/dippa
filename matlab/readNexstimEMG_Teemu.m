% Read Nexstim EMG data and analyze MEPs

clear;
close all;

addpath('/proj/tms_eeg/Matleena/tDCS-project/Teemu/')
addpath('/archive/tms_eeg/hanna2/analysis/EMG/')
addpath('/archive/tms_eeg/hanna2/analysis/EMG/edf/')
addpath('/archive/tms_eeg/hanna2/analysis/EMG/edf/biosig4octmat/biosig/t200_FileAccess/')

%% Read data file and save into vectors:

subject = 'joonas';
condition = 'mt_3';

dir = '/proj/tms_eeg/Matleena/tDCS-project/Teemu/';
outputdir = '/home/mmkukkon/Desktop/tuloksia/Teemu/';
input_file = [dir,'Teemu Turunen_2014_08_06_12_01_01EMG.edf'];
output_file = [outputdir,'emg_',condition,'.mat'];
output_result_file = [outputdir,'joonas_',condition,'.mat'];

%% try if output file is already done

try 
    load(output_file);
catch
    [signals,header]=sload(input_file);
    save(output_file,'signals','header');
end

%% try if result file is already done

try
    load(output_result_file);
catch
%% find data and trigger channels    
    
header.Label

if header.NS == 6 %number of signals
    muscle_ind = 2 %EMG channel
    elec = 3 %electric current channel
    trig_ind = 4 % Gate In (triggers)
else
    disp('Check recstruct.label for EMG and trig data indices!')
    return;
end

%Scale data to correspond to the right units:
data = 10^6*signals(:,muscle_ind); %uV
trig = signals(:,trig_ind); %V
elec = signals(:, elec); %V

fs = header.SampleRate; %Hz
timeAll = (1:length(data))/fs;




% %% Plot all the data:
% 
% figure;
% plot(timeAll,trig);
% title('Trigger')
% ylabel('V')
% xlabel('Time (s)')
% 
% figure;
% plot(timeAll,data);
% ylabel('uV')
% title('EMG signal')
% xlabel('Time (s)')

plot(timeAll, elec)
n1 = [];
n2 = [];
n1_n = [];
n2_n = [];
n1_p = [];
n2_p = [];
i = 1;

for x = -0.0003:0.000001:0.0003
[n1(i), n2(i)] = around(n_mt_e', n_mt, x, 0.0004);
[n1_n(i), n2_n(i)] = around(n_n_e', n_n, x, 0.0004);
[n1_p(i), n2_p(i)] = around(n_p_e', n_p, x, 0.0004);
i = i+1;
end


figure
hold on
plot(-0.0003:0.000001:0.0003,n1)
plot(-0.0003:0.000001:0.0003,n1_n,'r')
plot(-0.0003:0.000001:0.0003,n1_p,'g')
title('niko')
legend('mt','below','above')
figure
hold on
plot(-0.0003:0.000001:0.0003,n2)
plot(-0.0003:0.000001:0.0003,n2_n,'r')
plot(-0.0003:0.000001:0.0003,n2_p,'g')
title('niko')
legend('mt','below','above')

%% Parse EMG trials

%Find trigger timepoints:
trigGradThreshold = 1;
trigInds = find(diff(trig)>trigGradThreshold);

%Read EMG trials into a matrix:
bl = 100; %ms
tw = 300; %ms
emgData = []; %trials x samples
% trigData = [];
for i=1:length(trigInds)
    %Parse and baseline correct trial i:
    trial = data(trigInds(i)-round(bl/1000*fs):trigInds(i)+round(tw/1000*fs))-mean(data(trigInds(i)-round(bl/1000*fs):trigInds(i)));
    emgData = [emgData; trial'];
%     trigData = [trigData; trig(trigInds(i)-round(bl/1000*fs):trigInds(i)+round(tw/1000*fs))'];
end
timeAxis = 1000*((0:(1/fs):(1/fs)*(size(emgData,2)-1))-bl/1000);


%% find electric current
% at first just see the current at that time
elec1 = -elec(trigInds);

%later see if the phase is more interesting


%% Accept/reject EMG trials

emgAccepted = ones(1,size(emgData,1));


%% Read EMG amplitudes
% emgAccepted = ones(1,size(emgData,1)); %accept all trials

figure
timeRange = [20 38]; %ms; expected time when the MEP appears with respect to stimulus
amplitudes = emgReadAmplAutomaticallyNew(emgData,timeAxis,emgAccepted,fs,timeRange);

accepted_ind = find(emgAccepted);
rejected_ind = find(~emgAccepted);

figure
plot(amplitudes,'ro');
hold on
plot([1 length(amplitudes)],[50 50],'g')
title('MEP amplitudes')
xlabel('Trial #')
ylabel('Amplitude (uV)')



%% Save results
save(output_result_file, 'amplitudes','emgAccepted','elec1')

end

%%plotting


figure(104)
plot(elec1,amplitudes, 'o')
hold on
plot([-0.00032 0.00032],[50 50],'r')

