parentdir = 'E:\MEP sorting\MEP08\';
dir = [parentdir,'EMG_kasitelty\'];
eegdir = [parentdir,'EEG_kasitelty\'];
output_number = '2';
output_muscle = 'ADM';
output_name = [output_number,'_',output_muscle];

load([dir,'amplitudes_',output_name,'.mat']);
load([dir,'acceptedEmg_',output_name,'.mat']);

load([eegdir,'accepted_trialNrs_',output_number,'.mat']);

figure
for i=1:length(amplitudes)
    if emgAccepted(i)*accepted(i)
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
    if sortedAcceptedEmg(i)*sortedAcceptedEeg(i)
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

nHyvaksyttyja = sum(sortedAcceptedEmg.*sortedAcceptedEeg)