load('E:\MEP sorting\MEP02\EMG_kasitelty\amplitudes_sorted_all.mat');

nProbabBins = 200;
incr = max(amplitudes_sorted)/nProbabBins;
x = 0:incr:max(amplitudes_sorted);
y = histc(amplitudes_sorted,x)/length(amplitudes_sorted);
figure
bar(x,y)
title(['Probability histogram, increment = ',num2str(incr),' \mu V'])
xlabel('MEP amplitude (\mu V)')
ylabel('Probability')
xlim([min(amplitudes_sorted)-incr max(amplitudes_sorted)+incr])