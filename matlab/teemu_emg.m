% Read Nexstim EMG data and analyze MEPs  % Matleenas version

clear;
close all;

addpath('/archive/tms_eeg/hanna2/analysis/EMG/')
addpath('/archive/tms_eeg/hanna2/analysis/EMG/edf/')
addpath('/archive/tms_eeg/hanna2/analysis/EMG/edf/biosig4octmat/biosig/t200_FileAccess/')



 teemu = [];


%% Read data file and save into vectors:

outputdir = '/home/mmkukkon/Desktop/tuloksia/Teemu/';

truefile = [outputdir, 'teemu.mat'];

% file, num of repeats, condition (1 = -2mA, 2 = 0, 3 = +2mA, 4 = something
% wrong)

files = ['/proj/tms_eeg/Matleena/tDCS-project/Teemu/Teemu Turunen_2014_08_06_12_01_01EMG.edf';...
'/proj/tms_eeg/Matleena/tDCS-project/Teemu/Teemu Turunen_2014_08_06_12_07_20EMG.edf';...
'/proj/tms_eeg/Matleena/tDCS-project/Teemu/Teemu Turunen_2014_08_06_12_10_48EMG.edf';...
'/proj/tms_eeg/Matleena/tDCS-project/Teemu/Teemu Turunen_2014_08_06_12_17_29EMG.edf';...
'/proj/tms_eeg/Matleena/tDCS-project/Teemu/Teemu Turunen_2014_08_06_12_26_18EMG.edf';...
'/proj/tms_eeg/Matleena/tDCS-project/Teemu/Teemu Turunen_2014_08_06_12_30_40EMG.edf';...
'/proj/tms_eeg/Matleena/tDCS-project/Teemu/Teemu Turunen_2014_08_06_12_43_07EMG.edf';...
'/proj/tms_eeg/Matleena/tDCS-project/Teemu/Teemu Turunen_2014_08_06_12_48_19EMG.edf';...
'/proj/tms_eeg/Matleena/tDCS-project/Teemu/Teemu Turunen_2014_08_06_12_56_05EMG.edf';...
'/proj/tms_eeg/Matleena/tDCS-project/Teemu/Teemu Turunen_2014_08_06_12_58_49EMG.edf';...
'/proj/tms_eeg/Matleena/tDCS-project/Teemu/Teemu Turunen_2014_08_06_13_01_51EMG.edf';...
'/proj/tms_eeg/Matleena/tDCS-project/Teemu/Teemu Turunen_2014_08_06_13_04_29EMG.edf';...
'/proj/tms_eeg/Matleena/tDCS-project/Teemu/Teemu Turunen_2014_08_06_13_09_06EMG.edf';...
'/proj/tms_eeg/Matleena/tDCS-project/Teemu/Teemu Turunen_2014_08_06_13_12_19EMG.edf';...
'/proj/tms_eeg/Matleena/tDCS-project/Teemu/Teemu Turunen_2014_08_06_13_15_20EMG.edf'];

cond = [[50, 50, 0], [3, 2, 0];...
[50, 0, 0], [1, 0, 0];...
[50, 0, 0], [2, 0, 0];...
[50, 50, 0], [3, 1, 0];...
[50, 0, 0], [2, 0, 0];...
[7, 50, 50], [4, 1, 3];...
[50, 0, 0], [1, 0, 0];...
[50, 0, 0], [3, 0, 0];...
[50, 0, 0], [2, 0, 0];...
[50, 0, 0], [3, 0, 0];...
[50, 0, 0], [1, 0, 0];...
[50, 0, 0], [2, 0, 0];...
[50, 0, 0], [1, 0, 0];...
[50, 0, 0], [2, 0, 0];...
[9, 50, 0], [4, 3, 0]];

%% something

num_f = size(files, 1);
subject = 'teemu';

for i = 1:num_f
    input_file = files(i,:);
    output_file = [outputdir, 'raw_', subject, int2str(i), '.mat'];
    output_r_file = [outputdir, subject, int2str(i), '.mat'];
    condition = cond(i,4:6);
    num_c = cond(i,1:3);

    %% try if raw output file is already done

try 
    load(output_file);
catch
    [signals,header]=sload(input_file);
    save(output_file,'signals','header');
end

    %% try if result file is already done

try
    load(output_r_file);
catch
    
%% find data and trigger channels    
    
header.Label

if header.NS == 5 %number of signals
    muscle_ind = 2 %EMG (FDI) channel
    trig_ind = 3 % Gate In (triggers)
else
    disp('Check recstruct.label for EMG and trig data indices!')
    return;
end

%Scale data to correspond to the right units:
data = 10^6*signals(:,muscle_ind); %uV
trig = signals(:,trig_ind); %V

fs = header.SampleRate; %Hz
timeAll = (1:length(data))/fs;


%% Parse EMG trials

%Find trigger timepoints:
trigGradThreshold = 1;
trigInds = find(diff(trig)>trigGradThreshold);

l = length(trigInds);
inds = []
for i = 2:l
    if (trigInds(i)-trigInds(i-1)<10)
        inds = [inds, i-1]
    end
end

trigInds(inds) = [];


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


%% Accept/reject EMG trials

emgAccepted = ones(1,size(emgData,1));


%% Read EMG amplitudes
% emgAccepted = ones(1,size(emgData,1)); %accept all trials

figure
timeRange = [20 38]; %ms; expected time when the MEP appears with respect to stimulus
amplitudes = emgReadAmplAutomaticallyNew(emgData,timeAxis,emgAccepted,fs,timeRange);

for i = 1:length(amplitudes)
    if amplitudes(i) < 50
        emgAccepted(i) = 0;
    end
end

accepted_ind = find(emgAccepted);
rejected_ind = find(~emgAccepted);

%% make condition matrix

    nums = [];
    for i = 1:3
        nums = [nums; repmat(condition(i), num_c(i), 1)];
    end

            
       
        
%% save files

temp = [amplitudes; emgAccepted; nums'];

teemu = [teemu, temp];

save(output_r_file, 'temp')

end

save(truefile, 'teemu')
    
end

