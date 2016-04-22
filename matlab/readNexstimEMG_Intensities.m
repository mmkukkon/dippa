% Read Nexstim EMG data and analyze MEPs

clear;
close all;

addpath('/proj/tms_eeg/Matleena/tDCS-project/Tuomas_ Mutanen_21032014/')
addpath('/archive/tms_eeg/hanna2/analysis/EMG/')
addpath('/archive/tms_eeg/hanna2/analysis/EMG/edf/')
addpath('/archive/tms_eeg/hanna2/analysis/EMG/edf/biosig4octmat/biosig/t200_FileAccess/')

%% Read data file and save into vectors:

subject = 'tuomas';
condition = 'intensity';

dir = '/proj/tms_eeg/Matleena/tDCS-project/Tuomas_ Mutanen_21032014/';
outputdir = '/home/mmkukkon/Desktop/tuloksia/Tuomas/Intensity/';
input_file = [dir,'Tuomas Mutanen_2014_03_21_17_09_22EMG.edf'];
output_file = [outputdir,'results_',condition,'.mat'];
output_result_file = [outputdir,'raw_',condition,'.mat'];

try 
    load(output_file);
catch
    [signals,header]=sload(input_file);
    save(output_file,'signals','header');
end

%% muuta

header.Label

if header.NS == 5 %number of signals
    muscle_ind = 2; %kts. recstruct.label, mik� indeksi vastaa EMG-signaalia
    trig_ind = 3; %kts. recstruct.label, Gate In
else
    disp('Check recstruct.label for EMG and trig data indices!')
    return;
end

%Scale data to correspond to the right units:
data = 10^6*signals(:,muscle_ind); %uV
trig = signals(:,trig_ind); %V

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

% trial_ind = 4;
% figure
% plot(timeAxis,emgData(trial_ind,:));
% xlabel('Time (ms)')n

% figure
% plot(1000*timeAxis,trigData(4,:));
% xlabel('Time (ms)')

%% Accept/reject EMG trials

emgAccepted = ones(1,size(emgData,1));

%% one by one
% figure
% for i=1:size(emgData,1)
%     plot(timeAxis,emgData(i,:))
%     hold on
%     plot([timeAxis(1) timeAxis(end)],[-10 -10],'g');
%     plot([timeAxis(1) timeAxis(end)],[10 10],'g');
%     plot([0 0],[min(emgData(i,:)) max(emgData(i,:))],'r');
%     title('Select accepted(mouse) / rejected(keyboard) trials')
%     xlabel('Time (ms)')
%     ylabel('Voltage (\mu V)')
%     %         xlim([max(timeAxis(1),latency_TMS-100) latency_TMS+100]);
%     button = waitforbuttonpress;
%     if button==0,
%         disp(['Trial ' int2str(i) ', Accepted']);
%     else
%         emgAccepted(i) = 0;
%         disp(['Trial ' int2str(i) ', Rejected']);
%     end
%     hold off
% end


%% Plot MEPs:
% for i=1:size(emgData,1)
%     figure;
%     plot(timeAxis,emgData(i,:))
%     title(['Response ',num2str(i)]);
% end
% 
% figure
% plot(timeAxis,emgData(5,:),'k','LineWidth',2)
% xlim([-50 150])
% ylim([-310 270])

%% Read EMG amplitudes
%emgAccepted = ones(1,size(emgData,1)) %accept all trials

timeRange = [20 38]; %ms; expected time when the MEP appears with respect to stimulus
amplitudes = emgReadAmplAutomaticallyNew(emgData,timeAxis,emgAccepted,fs,timeRange);

accepted_ind = find(emgAccepted);
rejected_ind = find(~emgAccepted);

figure
plot(accepted_ind,amplitudes(accepted_ind),'ro');
hold on
plot(rejected_ind,amplitudes(rejected_ind),'ko');
plot([1 length(amplitudes)],[50 50],'g')
title('MEP amplitudes')
xlabel('Trial #')
ylabel('Amplitude (uV)')

mean_MEP = mean(amplitudes(accepted_ind))
std_MEP = std(amplitudes(accepted_ind))
n_MEP = length(amplitudes(accepted_ind));


%% Read EMG with different intensities

intensities = [-2120,-2140,-2100,-2110, 2110,2140,2100,2120, 120, 100,110,140]
amount = 25

if length(intensities) > 1

num_MEP = [length(find(amplitudes(accepted_ind(1:amount))>50)), length(find(amplitudes(accepted_ind(amount+1:amount*2))>50)), length(find(amplitudes(accepted_ind(amount*2+1:amount*3))>50)), length(find(amplitudes(accepted_ind(amount*3+1:amount*4))>50)), length(find(amplitudes(accepted_ind(amount*4+1:amount*5))>50)), length(find(amplitudes(accepted_ind(amount*5+1:amount*6))>50)), length(find(amplitudes(accepted_ind(amount*6+1:amount*7))>50)), length(find(amplitudes(accepted_ind(amount*7+1:amount*8))>50)), length(find(amplitudes(accepted_ind(amount*8+1:amount*9))>50)), length(find(amplitudes(accepted_ind(amount*9+1:amount*10))>50)), length(find(amplitudes(accepted_ind(amount*10+1:amount*11))>50)), length(find(amplitudes(accepted_ind(amount*11+1:amount*12))>50))]

mean2_MEP = [mean(amplitudes((find(amplitudes(accepted_ind(1:amount))>50)))), mean(amplitudes((find(amplitudes(accepted_ind(amount+1:amount*2))>50)))), mean(amplitudes((find(amplitudes(accepted_ind(amount*2+1:amount*3))>50)))), mean(amplitudes((find(amplitudes(accepted_ind(amount*3+1:amount*4))>50)))), mean(amplitudes((find(amplitudes(accepted_ind(amount*4+1:amount*5))>50)))), mean(amplitudes((find(amplitudes(accepted_ind(amount*5+1:amount*6))>50)))), mean(amplitudes((find(amplitudes(accepted_ind(amount*6+1:amount*7))>50)))), mean(amplitudes((find(amplitudes(accepted_ind(amount*7+1:amount*8))>50)))), mean(amplitudes((find(amplitudes(accepted_ind(amount*8+1:amount*9))>50)))), mean(amplitudes((find(amplitudes(accepted_ind(amount*9+1:amount*10))>50)))), mean(amplitudes((find(amplitudes(accepted_ind(amount*10+1:amount*11))>50)))), mean(amplitudes((find(amplitudes(accepted_ind(amount*11+1:amount*12))>50))))]


% %number of meps per intensity
% num_MEP = [length(find(amplitudes(accepted_ind(1:amount))>50)), length(find(amplitudes(accepted_ind(amount+1:amount*2))>50)), length(find(amplitudes(accepted_ind(amount*2+1:amount*3))>50)), length(find(amplitudes(accepted_ind(amount*3+1:amount*4))>50)), length(find(amplitudes(accepted_ind(amount*4+1:amount*5))>50)), length(find(amplitudes(accepted_ind(amount*5+1:amount*6))>50)), length(find(amplitudes(accepted_ind(amount*6+1:amount*7))>50)), length(find(amplitudes(accepted_ind(amount*7+1:amount*8))>50)), length(find(amplitudes(accepted_ind(amount*8+1:amount*9))>50)), length(find(amplitudes(accepted_ind(amount*9+1:amount*10))>50)), length(find(amplitudes(accepted_ind(amount*10+1:amount*11))>50)), length(find(amplitudes(accepted_ind(amount*11+1:amount*12))>50))]
% num_MEP = num_MEP(b)
% 
% mean2_MEP = [mean(amplitudes((find(amplitudes(accepted_ind(1:amount))>50)))), mean(amplitudes((find(amplitudes(accepted_ind(amount+1:amount*2))>50)))), mean(amplitudes((find(amplitudes(accepted_ind(amount*2+1:amount*3))>50)))), mean(amplitudes((find(amplitudes(accepted_ind(amount*3+1:amount*4))>50)))), mean(amplitudes((find(amplitudes(accepted_ind(amount*4+1:amount*5))>50)))), mean(amplitudes((find(amplitudes(accepted_ind(amount*5+1:amount*6))>50)))), mean(amplitudes((find(amplitudes(accepted_ind(amount*6+1:amount*7))>50)))), mean(amplitudes((find(amplitudes(accepted_ind(amount*7+1:amount*8))>50)))), mean(amplitudes((find(amplitudes(accepted_ind(amount*8+1:amount*9))>50)))), mean(amplitudes((find(amplitudes(accepted_ind(amount*9+1:amount*10))>50)))), mean(amplitudes((find(amplitudes(accepted_ind(amount*10+1:amount*11))>50)))), mean(amplitudes((find(amplitudes(accepted_ind(amount*11+1:amount*12))>50))))]
% mean2_MEP = mean2_MEP(b)

else
    num_MEP = length(find(amplitudes(accepted_ind(1:amount))>50))
    mean2_MEP = mean(amplitudes((find(amplitudes(accepted_ind(1:amount))>50))))
end


%% Save results
save(output_result_file, 'amplitudes','intensities','num_MEP', 'mean2_MEP', 'amount')