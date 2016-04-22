dir = 'E:\MEP sorting\MEP02\';
eegdir = [dir,'EEG_kasitelty\'];
emgdir = [dir,'EMG_kasitelty\'];
output_number = '6';
output_muscle = 'ADM';
output_name = [output_number,'_',output_muscle];

load([eegdir,'sortedAccepted_',output_name,'.mat']);
load([emgdir,'amplitudes_sorted_',output_name,'.mat']);
load([emgdir,'sortIndex_',output_name,'.mat']);

if(length(amplitudes_sorted)~=length(sortedAccepted))
    disp('EEG- ja EMG-vasteiden m‰‰r‰ ei ole sama!')
    sortedAccepted = sortedAccepted(1:end-1);
end

figure
for i=1:length(sortedAccepted)
    if sortedAccepted(i)
        plot(i,amplitudes_sorted(i),'.')
        hold on
    else
        plot(i,amplitudes_sorted(i),'r*')
        hold on
    end
end
title('.=accepted, *=rejected')
xlabel('Sorted trial #')
ylabel('MEP amplitude (\mu V)')

figure
nAccepted = 1;
for i=1:length(sortedAccepted)
    if sortedAccepted(i)
        plot(nAccepted,amplitudes_sorted(i),'.')
        hold on
        nAccepted = nAccepted + 1;
    end
end
title('.=accepted, *=rejected')
xlabel('Sorted trial #')
ylabel('MEP amplitude (\mu V)')