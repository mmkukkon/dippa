parentdir = 'E:\MEP sorting\MEP03b\';
dir = [parentdir,'EMG_kasitelty\'];
eegdir = [parentdir,'EEG_kasitelty\'];
output_muscle = 'ADM';
output_number1 = '1';
output_number2 = '3';
output_number3 = '4';
output_name_eeg = 'masking';

output_name1 = [output_number1,'_',output_muscle];
output_name2 = [output_number2,'_',output_muscle];
output_name3 = [output_number3,'_',output_muscle];

%3 settiä:
%________________________________________________________
load([dir,'amplitudes_',output_name1,'.mat']);
amplitudes_new = amplitudes;
load([dir,'amplitudes_',output_name2,'.mat']);
amplitudes_new = [amplitudes_new amplitudes];
load([dir,'amplitudes_',output_name3,'.mat']);
amplitudes = [amplitudes_new amplitudes];
save([dir,'amplitudes_',output_name,'.mat'],'amplitudes');
load([dir,'acceptedEmg_',output_name1,'.mat']);
accepted_new = emgAccepted;
load([dir,'acceptedEMG_',output_name2,'.mat']);
accepted_new = [accepted_new emgAccepted];
load([dir,'acceptedEMG_',output_name3,'.mat']);
emgAccepted = [accepted_new emgAccepted];
save([dir,'acceptedEmg_',output_name_eeg,'_',output_muscle],'emgAccepted');
output_name = [output_name_eeg,'_',output_muscle];

load([eegdir,'allTrials_',output_number1,'.mat']);
allTrials_1 = allTrials;
load([eegdir,'allTrials_',output_number2,'.mat']);
allTrials_2 = allTrials;
load([eegdir,'allTrials_',output_number3,'.mat']);
allTrials_3 = allTrials;

allTrials = reshape([reshape(allTrials_1,size(allTrials_1,1),size(allTrials_1,2)*size(allTrials_1,3)) reshape(allTrials_2,size(allTrials_2,1),size(allTrials_2,2)*size(allTrials_2,3)) reshape(allTrials_3,size(allTrials_3,1),size(allTrials_3,2)*size(allTrials_3,3))],size(allTrials_1,1),size(allTrials_1,2),size(allTrials_1,3)+size(allTrials_2,3)+size(allTrials_3,3));
save([eegdir,'allTrials_',output_name_eeg,'.mat'],'allTrials');

load([eegdir,'accepted_trialNrs_',output_number1,'.mat']);
accepted_1 = accepted;
load([eegdir,'accepted_trialNrs_',output_number2,'.mat']);
accepted_2 = accepted;
load([eegdir,'accepted_trialNrs_',output_number3,'.mat']);
accepted_3 = accepted;

accepted = [accepted_1 accepted_2 accepted_3];
save([eegdir,'accepted_trialNrs_',output_name_eeg,'.mat'],'accepted');

%________________________________________________________

%2 settiä:
%________________________________________________________
% load([dir,'amplitudes_',output_name1,'.mat']);
% amplitudes_new = amplitudes;
% load([dir,'amplitudes_',output_name2,'.mat']);
% amplitudes = [amplitudes_new amplitudes];
% load([dir,'acceptedEmg_',output_name1,'.mat']);
% accepted_new = emgAccepted;
% load([dir,'acceptedEMG_',output_name2,'.mat']);
% emgAccepted = [accepted_new emgAccepted];
% save([dir,'acceptedEmg_',output_name_eeg,'_',output_muscle],'emgAccepted');
% output_name = [output_name_eeg,'_',output_muscle];
% 
% load([eegdir,'allTrials_',output_number1,'.mat']);
% allTrials_1 = allTrials;
% load([eegdir,'allTrials_',output_number2,'.mat']);
% allTrials_2 = allTrials;
% 
% allTrials = reshape([reshape(allTrials_1,size(allTrials_1,1),size(allTrials_1,2)*size(allTrials_1,3)) reshape(allTrials_2,size(allTrials_2,1),size(allTrials_2,2)*size(allTrials_2,3))],size(allTrials_1,1),size(allTrials_1,2),size(allTrials_1,3)+size(allTrials_2,3));
% save([eegdir,'allTrials_',output_name_eeg,'.mat'],'allTrials');
% 
% load([eegdir,'accepted_trialNrs_',output_number1,'.mat']);
% accepted_1 = accepted;
% load([eegdir,'accepted_trialNrs_',output_number2,'.mat']);
% accepted_2 = accepted;
% 
% accepted = [accepted_1 accepted_2];
% save([eegdir,'accepted_trialNrs_',output_name_eeg,'.mat'],'accepted');

%________________________________________________________

figure
for i=1:length(amplitudes)
    if emgAccepted(i) && accepted(i)
        plot(i,amplitudes(i),'o')
        hold on
    else
        plot(i,amplitudes(i),'ro')
        hold on
    end
end
title(['Amplitudes: ',output_name])
xlabel('Trial #')
ylabel('Amplitude (\mu V)')

[amplitudes_sorted,sortIndex] = sort(amplitudes);
save([dir,'amplitudes_sorted_',output_name,'.mat'],'amplitudes_sorted');
save([dir,'sortIndex_',output_name,'.mat'],'sortIndex');

sortedAcceptedEmg = zeros(1,length(amplitudes));
sortedAcceptedEeg = zeros(1,length(amplitudes));
for i=1:length(amplitudes)
    sortedAcceptedEmg(i) = emgAccepted(sortIndex(i));
    sortedAcceptedEeg(i) = accepted(sortIndex(i));
end
save([dir,'sortedAcceptedEmg_',output_name,'.mat'],'sortedAcceptedEmg');

figure
for i=1:length(amplitudes)
    if sortedAcceptedEmg(i) && sortedAcceptedEeg(i)
        plot(i,amplitudes_sorted(i),'o')
        hold on
    else
        plot(i,amplitudes_sorted(i),'ro')
        hold on
    end
end
plot([1 length(amplitudes)],[50 50],'g')
title(['Sorted amplitudes: ',output_name])
ylabel('Amplitude (\mu V)')