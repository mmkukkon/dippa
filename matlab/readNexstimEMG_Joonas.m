% Read Nexstim EMG data and analyze MEPs

clear;
close all;

addpath('/proj/tms_eeg/Matleena/tDCS-project/Niko/')
addpath('/archive/tms_eeg/hanna2/analysis/EMG/')
addpath('/archive/tms_eeg/hanna2/analysis/EMG/edf/')
addpath('/archive/tms_eeg/hanna2/analysis/EMG/edf/biosig4octmat/biosig/t200_FileAccess/')

%% Read data file and save into vectors:

subject = 'niko';
condition = 'mt+_3';

dir = '/proj/tms_eeg/Matleena/tDCS-project/Niko/';
outputdir = '/home/mmkukkon/Desktop/tuloksia/Niko/';
input_file = [dir,'Niko Mäkelä_2014_07_01_10_38_52EMG.edf'];
output_file = [outputdir,'emg_',condition,'.mat'];
output_result_file = [outputdir,'niko_',condition,'.mat'];

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
    elec = 3 %electric curren channel
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

figure
plot(timeAll, elec)

%% electrical current 

ind1 = [];
ind2 = [];

for i = 0:10
    ind1(i+1) = find(timeAll>72.5+i,1, 'first')
    ind2(i+1) = find(timeAll>72+i,1, 'first')
end

m1 = [];
m2 = [];
m1i = [];
m2i = [];

for i = 1:10
    [m1,m1i] = max(elec(ind1(i):ind1(i+1)))
    [m2,m2i] = min(elec(ind2(i):ind2(i+1)))
end

%% filtering
wn = 0.3
[a,b] = butter(2,wn)

elec2 = filtfilt(b,a,elec)

hold on 
plot(timeAll,elec2,'r')



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

% TODO later see if the phase is more interesting

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

