dir = 'E:\Topographical mapping\TM05\EMG_kasitelty\';

load([dir,'amplitudes_0_ADM.mat']);
amplitudes_adm = amplitudes;
load([dir,'amplitudes_0_APB.mat']);
amplitudes_apb = amplitudes;
clear 'amplitudes';

p1 = polyfit(amplitudes_adm,amplitudes_apb,1)
p2 = polyfit(amplitudes_apb,amplitudes_adm,1)

figure
plot(amplitudes_adm,amplitudes_apb,'o')
hold on
plot([0 max(amplitudes_adm)],polyval(p1,[0 max(amplitudes_adm)]),'r')
text(600,300,['APB = ',num2str(p1(1)),'*ADM + ',num2str(p1(2))])
xlabel('Amplitude of ADM MEP (\mu V)')
ylabel('Amplitude of APB MEP (\mu V)')

figure
plot(amplitudes_apb,amplitudes_adm,'o')
hold on
plot([0 max(amplitudes_apb)],polyval(p2,[0 max(amplitudes_apb)]),'r')
text(200,700,['ADM = ',num2str(p2(1)),'*APB + ',num2str(p2(2))])
xlabel('Amplitude of APB MEP (\mu V)')
ylabel('Amplitude of ADM MEP (\mu V)')

correlation = corr(amplitudes_adm',amplitudes_apb')