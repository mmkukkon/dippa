dir = 'E:\MEP sorting\MEP03\EMG_kasitelty\';
output_name = 'noMasking_APB';

load([dir,'amplitudes_',output_name,'.mat']);

figure
plot(amplitudes)
xlabel('Trial #')
ylabel('Amplitude (\mu V)')

[amplitudes_sorted,sortIndex] = sort(amplitudes);
save([dir,'amplitudes_sorted_',output_name,'.mat'],'amplitudes_sorted');
save([dir,'sortIndex_',output_name,'.mat'],'sortIndex');

figure
plot(amplitudes_sorted)
ylabel('Amplitude (\mu V)')