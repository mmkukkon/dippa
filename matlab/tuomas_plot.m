%% load data

clear all
load tuomas.mat 

%1) Amplitude
amplitudes = tuomas(1,:);
%2) EMG Accepted
emg_all = tuomas(2,:);
%3) Condition (1 = -2mA, 2 = 0, 3 = +2mA, 4 = something wrong)
condition = tuomas(3,:);

load tuomas_mt.mat

%1) Intensity (% of machine)
intensity1 = tuomas_mt(:,1)';
%2) Intensity (% V/m)
intensity2 = tuomas_mt(:,2)';

%remove false conditions
[~,rem] = find(condition ==4);

amplitudes(rem) = [];
intensity1(rem) = [];
intensity2(rem) = [];
condition(rem) = [];
emg_all(rem) = [];

%
emg_accepted = find(emg_all);
emg_not_accepted = find(~emg_all);

amplitudes_zeros = amplitudes;
amplitudes_zeros(emg_not_accepted) = 0;

%% plot amplitudes as function of intensity / machine

[~, i1] = sort(intensity1);
figure
plot(intensity1(i1), amplitudes_zeros(i1),'o')
figure
boxplot(amplitudes_zeros(i1), intensity1(i1) )

%% plot amplitudes as function of current

[~, i2] = sort(condition);
figure
plot(condition(i2), amplitudes_zeros(i2),'o')
figure
boxplot(amplitudes_zeros(i2), condition(i2))

size(condition(emg_accepted))
[~,i3] = sort(condition(emg_accepted));
temp1 = condition(emg_accepted);
temp2 = amplitudes_zeros(emg_accepted);
figure
plot(temp1(i3), temp2(i3),'o')
figure
boxplot(temp2(i3), temp1(i3))

%% plot all 9 different cases

mt = 65;

i1 = find(intensity1 == mt);
i2 = find(intensity1 == mt-1);
i3 = find(intensity1 == mt+1);

% mt intensity, -2, 0 +2
i11 = find(condition(i1)==1);
i12 = find(condition(i1)==2);
i13 = find(condition(i1)==3);

% mt-1 intensity, -2, 0, +2
i21 = find(condition(i2)==1);
i22 = find(condition(i2)==2);
i23 = find(condition(i2)==3);

%mt+1 intensity, -2, 0, +2
i31 = find(condition(i3)==1);
i32 = find(condition(i3)==2);
i33 = find(condition(i3)==3);

ind = [i11 i12 i13 i21 i22 i23 i31 i32 i33];

figure
hold on
subplot(3,1,1)
plot(condition(i1), amplitudes_zeros(i1),'o')
subplot(3,1,2)
plot(condition(i2), amplitudes_zeros(i2),'o')
subplot(3,1,3)
plot(condition(i3), amplitudes_zeros(i3),'o')

figure
hold on
subplot(3,1,1)
boxplot( amplitudes_zeros(i1),condition(i1))
subplot(3,1,2)
boxplot(amplitudes_zeros(i2), condition(i2))
subplot(3,1,3)
boxplot(amplitudes_zeros(i3), condition(i3))





