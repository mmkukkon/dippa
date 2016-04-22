% Read Nexstim EMG data and analyze MEPs

clear;
close all;

addpath('Q:\tms\hanna\analysis\EMG\')
addpath('Q:\tms\hanna\analysis\EMG\edf\')
addpath('Q:\tms\hanna\analysis\EMG\edf\biosig4octmat\biosig\t200_FileAccess\')

%% Read data file and save into vectors:

subject = 'hanna';
condition = '2';

dir = ['Q:\tms\hanna\data\silent_period\',subject,'\'];
input_file = [dir,'emg\',subject,'_',condition,'.edf'];
output_file = [dir,'emg_analyzed\emgdata_',condition,'.mat'];
output_result_file = [dir,'emg_analyzed\emgresults_',condition,'.mat'];

try 
    load(output_file);
catch
    [signals,header]=sload(input_file);
%     [recstruct,nsig,duration,nrecs] = readEDFfile(input_file,[]); %a slower way to read the file
    save(output_file,'signals','header');
end

header.Label

if header.NS == 5 %number of signals
    muscle_ind = 2; %kts. recstruct.label, mikä indeksi vastaa EMG-signaalia
    trig_ind = 3; %kts. recstruct.label, Gate In
else
    disp('Check recstruct.label for EMG and trig data indices!')
    return;
end

%Scale data to correspond to the right units:
data = 10^6*signals(:,muscle_ind); %uV
trig = signals(:,trig_ind); %V

%When readEDFfile.m is used to read the file:
% data = reshape((recstruct(muscle_ind).data)',1,size(recstruct(muscle_ind).data,1)*size(recstruct(muscle_ind).data,2));
% trig =
% reshape((recstruct(trig_ind).data)',1,size(recstruct(trig_ind).data,1)*size(recstruct(trig_ind).data,2));

%When readEDFfile.m is used to read the file:
% data = 10^6*data*0.010989/32767; %uV; tarkista digital ja physical_maximum kustakin datasta!
% trig = trig/32767*5; %V

fs = header.SampleRate; %Hz
timeAll = (1:length(data))/fs;

%% Plot all the data:

figure;
plot(timeAll,trig);
title('Trigger')
ylabel('V')
xlabel('Time (s)')

figure;
plot(timeAll,data);
ylabel('uV')
title('EMG signal')
xlabel('Time (s)')

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
% xlabel('Time (ms)')

% figure
% plot(1000*timeAxis,trigData(4,:));
% xlabel('Time (ms)')

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
        emgAccepted(i) = 0;
        disp(['Trial ' int2str(i) ', Rejected']);
    end
    hold off
end


%% Plot MEPs:
for i=1:size(emgData,1)
    figure;
    plot(timeAxis,emgData(i,:))
    title(['Response ',num2str(i)]);
end

figure
plot(timeAxis,emgData(5,:),'k','LineWidth',2)
xlim([-50 150])
ylim([-310 270])

%% Read EMG amplitudes
% emgAccepted = ones(1,size(emgData,1)); %accept all trials

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

%% Save results

save(output_result_file,'amplitudes','emgAccepted','mean_MEP','std_MEP','n_MEP');