% Read Nexstim EMG data and analyze MEPs  % Matleenas version

clear;
close all;


addpath('EMG')
addpath('EMG\edf')
addpath('EMG\edf\biosig4octmat\biosig\t200_FileAccess\')



matleena = [];


%% Read data file and save into vectors:

outputdir = '..\tulokset\Matleenadc\';

truefile = [outputdir, 'matleena.mat'];

% file, num of repeats, condition (1 = -2mA, 2 = 0, 3 = +2mA, 4 = something
% wrong)

files = ['..\data\Matleena K_2014_08_08_09_29_46\Matleena K_2014_08_08_10_48_58EMG.edf';...
'..\data\Matleena K_2014_08_08_09_29_46\Matleena K_2014_08_08_10_52_48EMG.edf';...
'..\data\Matleena K_2014_08_08_09_29_46\Matleena K_2014_08_08_10_55_52EMG.edf';...
'..\data\Matleena K_2014_08_08_09_29_46\Matleena K_2014_08_08_10_59_10EMG.edf';...
'..\data\Matleena K_2014_08_08_09_29_46\Matleena K_2014_08_08_11_03_46EMG.edf';...
'..\data\Matleena K_2014_08_08_09_29_46\Matleena K_2014_08_08_11_06_21EMG.edf';...
'..\data\Matleena K_2014_08_08_09_29_46\Matleena K_2014_08_08_11_10_08EMG.edf';...
'..\data\Matleena K_2014_08_08_09_29_46\Matleena K_2014_08_08_11_13_59EMG.edf';...
'..\data\Matleena K_2014_08_08_09_29_46\Matleena K_2014_08_08_11_16_56EMG.edf';...
'..\data\Matleena K_2014_08_08_09_29_46\Matleena K_2014_08_08_11_24_17EMG.edf';...
'..\data\Matleena K_2014_08_08_09_29_46\Matleena K_2014_08_08_11_27_51EMG.edf';...
'..\data\Matleena K_2014_08_08_09_29_46\Matleena K_2014_08_08_11_31_07EMG.edf';...
'..\data\Matleena K_2014_08_08_09_29_46\Matleena K_2014_08_08_11_34_09EMG.edf';...
'..\data\Matleena K_2014_08_08_09_29_46\Matleena K_2014_08_08_11_37_27EMG.edf';...
'..\data\Matleena K_2014_08_08_09_29_46\Matleena K_2014_08_08_11_40_18EMG.edf';...
'..\data\Matleena K_2014_08_08_09_29_46\Matleena K_2014_08_08_11_43_38EMG.edf';...
'..\data\Matleena K_2014_08_08_09_29_46\Matleena K_2014_08_08_11_47_29EMG.edf';...
'..\data\Matleena K_2014_08_08_09_29_46\Matleena K_2014_08_08_11_50_35EMG.edf';...
'..\data\Matleena K_2014_08_08_09_29_46\Matleena K_2014_08_08_11_53_12EMG.edf'];


cond = [[50,0,0], [1, 0, 0];...
[51, 0, 0], [3, 0, 0];...
[50, 0, 0], [1, 0, 0];...
[50, 0, 0], [2, 0, 0];...
[50, 0, 0], [1, 0, 0];...
[53, 0, 0], [2, 0, 0];...
[50, 0, 0], [3, 0, 0];...
[50, 0, 0], [2, 0, 0];...
[50, 0, 0], [3, 0, 0];...
[50, 0, 0], [3, 0, 0];...
[50, 0, 0], [1, 0, 0];...
[50, 0, 0], [2, 0, 0];...
[50, 0, 0], [1, 0, 0];...
[50, 0, 0], [2, 0, 0];...
[50, 0, 0], [4, 0, 0];... %3?
[50, 0, 0], [3, 0, 0];...
[51, 0, 0], [3, 0, 0];...
[50, 0, 0], [2, 0, 0];...
[50, 0, 0], [1, 0, 0]];


%% something

num_f = size(files, 1);
subject = 'matleena';

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

if header.NS == 6 %number of signals
    muscle_ind = 2 %EMG (FDI) channel
    trig_ind = 4 % Gate In (triggers)
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

%% make condition matrix
    nums = [];
    for i = 1:3
        nums = [nums; repmat(condition(i), num_c(i), 1)];
    end


%% Accept/reject EMG trials

emgAccepted = ones(1,size(emgData,1));
figure
for i=1:size(emgData,1)
    plot(timeAxis,emgData(i,:))
    hold on
    plot([timeAxis(1) timeAxis(end)],[-10 -10],'g');
    plot([timeAxis(1) timeAxis(end)],[10 10],'g');
    plot([0 0],[min(emgData(i,:)) max(emgData(i,:))],'r');
    title('Select accepted(mouse) / rejected(keyboard) trials')
    xlabel('Time (ms)')
    ylabel('Voltage (\mu V)')
    %         xlim([max(timeAxis(1),latency_TMS-100) latency_TMS+100]);
    button = waitforbuttonpress;
    if button==0,
        disp(['Trial ' int2str(i) ', Accepted']);
    else
        nums(i) = 4;
        disp(['Trial ' int2str(i) ', Rejected']);
    end
    hold off
end




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
            
       
        
%% save files

temp = [amplitudes; emgAccepted; nums'];

matleena = [matleena, temp];

save(output_r_file, 'temp')

end

save(truefile, 'matleena')
    
end

FIGURE 14 1 2 3 on ok eikä huonoja