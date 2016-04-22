%plot all
clear all

%% load data
load tuomas.mat
load tuomas_mt.mat
load matleena.mat
load matleena_mt.mat
load teemu.mat
load teemu_mt.mat


%% read data to vectors and remove "bad" conditions
%%Tuomas


%1) Amplitude
amplitudes_t = tuomas(1,:);
%2) EMG Accepted
emg_all_t = tuomas(2,:);
%3) Condition (1 = -2mA, 2 = 0, 3 = +2mA, 4 = something wrong)
condition_t = tuomas(3,:);

%1) Intensity (% of machine)
intensity1_t = tuomas_mt(:,1)';
%2) Intensity (% V/m)
intensity2_t = tuomas_mt(:,2)';

%remove false conditions
[~,rem] = find(condition_t ==4);

amplitudes_t(rem) = [];
intensity1_t(rem) = [];
intensity2_t(rem) = [];
condition_t(rem) = [];
emg_all_t(rem) = [];

%
emg_accepted_t = find(emg_all_t);
emg_not_accepted_t = find(~emg_all_t);

amplitudes_zeros_t = amplitudes_t;
amplitudes_zeros_t(emg_not_accepted_t) = 0;


% Matleena

%1) Amplitude
amplitudes_m = matleena(1,:);
%2) EMG Accepted
emg_all_m = matleena(2,:);
%3) Condition (1 = -2mA, 2 = 0, 3 = +2mA, 4 = something wrong)
condition_m = matleena(3,:);

%1) Intensity (% of machine)
intensity1_m = matleena_mt(:,1)';
%2) Intensity (% V/m)
intensity2_m = matleena_mt(:,2)';

%remove false conditions
[~,rem] = find(condition_m ==4);

amplitudes_m(rem) = [];
intensity1_m(rem) = [];
intensity2_m(rem) = [];
condition_m(rem) = [];
emg_all_m(rem) = [];

%
emg_accepted_m = find(emg_all_m);
emg_not_accepted_m = find(~emg_all_m);

amplitudes_zeros_m = amplitudes_m;
amplitudes_zeros_m(emg_not_accepted_m) = 0;

% Teemu

%1) Amplitude
amplitudes_te = teemu(1,:);
%2) EMG Accepted
emg_all_te = teemu(2,:);
%3) Condition (1 = -2mA, 2 = 0, 3 = +2mA, 4 = something wrong)
condition_te = teemu(3,:);

%1) Intensity (% of machine)
intensity1_te = teemu_mt(:,1)';
%2) Intensity (% V/m)
intensity2_te = teemu_mt(:,2)';

%remove false conditions
[~,rem] = find(condition_te ==4);

amplitudes_te(rem) = [];
intensity1_te(rem) = [];
intensity2_te(rem) = [];
condition_te(rem) = [];
emg_all_te(rem) = [];

%
emg_accepted_te = find(emg_all_te);
emg_not_accepted_te = find(~emg_all_te);

amplitudes_zeros_te = amplitudes_te;
amplitudes_zeros_te(emg_not_accepted_te) = 0;

%% percentage of meps for Tuomas

%all 9 different cases

mt = 65;

i1_t = find(intensity1_t == mt-1);
i2_t = find(intensity1_t == mt);
i3_t = find(intensity1_t == mt+1);

% mt intensity, -2, 0 +2
i11_t = find(condition_t(i1_t)==1); i12_t = find(condition_t(i1_t)==2); i13_t = find(condition_t(i1_t)==3);

% mt-1 intensity, -2, 0, +2
i21_t = find(condition_t(i2_t)==1); i22_t = find(condition_t(i2_t)==2); i23_t = find(condition_t(i2_t)==3);

%mt+1 intensity, -2, 0, +2
i31_t = find(condition_t(i3_t)==1); i32_t = find(condition_t(i3_t)==2); i33_t = find(condition_t(i3_t)==3);

%number of zeros in every piece
t11 = (length(amplitudes_zeros_t(i11_t)) - length(find(amplitudes_zeros_t(i11_t) == 0))) / length(amplitudes_zeros_t(i11_t));
t12 = (length(amplitudes_zeros_t(i12_t)) - length(find(amplitudes_zeros_t(i12_t) == 0))) / length(amplitudes_zeros_t(i12_t));
t13 = (length(amplitudes_zeros_t(i13_t)) - length(find(amplitudes_zeros_t(i13_t) == 0))) / length(amplitudes_zeros_t(i13_t));
t21 = (length(amplitudes_zeros_t(i21_t)) - length(find(amplitudes_zeros_t(i21_t) == 0))) / length(amplitudes_zeros_t(i21_t));
t22 = (length(amplitudes_zeros_t(i22_t)) - length(find(amplitudes_zeros_t(i22_t) == 0))) / length(amplitudes_zeros_t(i22_t));
t23 = (length(amplitudes_zeros_t(i23_t)) - length(find(amplitudes_zeros_t(i23_t) == 0))) / length(amplitudes_zeros_t(i23_t));
t31 = (length(amplitudes_zeros_t(i31_t)) - length(find(amplitudes_zeros_t(i31_t) == 0))) / length(amplitudes_zeros_t(i31_t));
t32 = (length(amplitudes_zeros_t(i32_t)) - length(find(amplitudes_zeros_t(i32_t) == 0))) / length(amplitudes_zeros_t(i32_t));
t33 = (length(amplitudes_zeros_t(i33_t)) - length(find(amplitudes_zeros_t(i33_t) == 0))) / length(amplitudes_zeros_t(i33_t));



%% percentage of meps for Matleena

%all 9 different cases

mt = 50;

i1_m = find(intensity1_m == mt-1);
i2_m = find(intensity1_m == mt);
i3_m = find(intensity1_m == mt+1);

% mt-1 intensity, -2, 0 +2
i11_m = find(condition_m(i1_m)==1); i12_m = find(condition_m(i1_m)==2); i13_m = find(condition_m(i1_m)==3);

% mt intensity, -2, 0, +2
i21_m = find(condition_m(i2_m)==1); i22_m = find(condition_m(i2_m)==2); i23_m = find(condition_m(i2_m)==3);

%mt+1 intensity, -2, 0, +2
i31_m = find(condition_m(i3_m)==1); i32_m = find(condition_m(i3_m)==2); i33_m = find(condition_m(i3_m)==3);

%number of zeros in every piece
m11 = (length(amplitudes_zeros_m(i11_m)) - length(find(amplitudes_zeros_m(i11_m) == 0))) / length(amplitudes_zeros_m(i11_m));
m12 = (length(amplitudes_zeros_m(i12_m)) - length(find(amplitudes_zeros_m(i12_m) == 0))) / length(amplitudes_zeros_m(i12_m));
m13 = (length(amplitudes_zeros_m(i13_m)) - length(find(amplitudes_zeros_m(i13_m) == 0))) / length(amplitudes_zeros_m(i13_m));
m21 = (length(amplitudes_zeros_m(i21_m)) - length(find(amplitudes_zeros_m(i21_m) == 0))) / length(amplitudes_zeros_m(i21_m));
m22 = (length(amplitudes_zeros_m(i22_m)) - length(find(amplitudes_zeros_m(i22_m) == 0))) / length(amplitudes_zeros_m(i22_m));
m23 = (length(amplitudes_zeros_m(i23_m)) - length(find(amplitudes_zeros_m(i23_m) == 0))) / length(amplitudes_zeros_m(i23_m));
m31 = (length(amplitudes_zeros_m(i31_m)) - length(find(amplitudes_zeros_m(i31_m) == 0))) / length(amplitudes_zeros_m(i31_m));
m32 = (length(amplitudes_zeros_m(i32_m)) - length(find(amplitudes_zeros_m(i32_m) == 0))) / length(amplitudes_zeros_m(i32_m));
m33 = (length(amplitudes_zeros_m(i33_m)) - length(find(amplitudes_zeros_m(i33_m) == 0))) / length(amplitudes_zeros_m(i33_m));

%% percentage of meps for Teemu

%all 9 different cases

mt = 59;

i1_te = find(intensity1_te == mt-1);
i2_te = find(intensity1_te == mt);
i3_te = find(intensity1_te == mt+1);

% mt-1 intensity, -2, 0 +2
i11_te = find(condition_te(i1_te)==1); i12_te = find(condition_te(i1_te)==2); i13_te = find(condition_te(i1_te)==3);

% mt intensity, -2, 0, +2
i21_te = find(condition_te(i2_te)==1); i22_te = find(condition_te(i2_te)==2); i23_te = find(condition_te(i2_te)==3);

% mt+1 intensity, -2, 0, +2
i31_te = find(condition_te(i3_te)==1); i32_te = find(condition_te(i3_te)==2); i33_te = find(condition_te(i3_te)==3);

%number of zeros in every piece
te11 = length(find(amplitudes_zeros_te(i11_te) ~= 0)) / length(amplitudes_zeros_te(i11_te));
te12 = length(find(amplitudes_zeros_te(i12_te) ~= 0)) / length(amplitudes_zeros_te(i12_te));
te13 = length(find(amplitudes_zeros_te(i13_te) ~= 0)) / length(amplitudes_zeros_te(i13_te));
te21 = length(find(amplitudes_zeros_te(i21_te) ~= 0)) / length(amplitudes_zeros_te(i21_te));
te22 = length(find(amplitudes_zeros_te(i22_te) ~= 0)) / length(amplitudes_zeros_te(i22_te));
te23 = length(find(amplitudes_zeros_te(i23_te) ~= 0)) / length(amplitudes_zeros_te(i23_te));
te31 = length(find(amplitudes_zeros_te(i31_te) ~= 0)) / length(amplitudes_zeros_te(i31_te));
te32 = length(find(amplitudes_zeros_te(i32_te) ~= 0)) / length(amplitudes_zeros_te(i32_te));
te33 = length(find(amplitudes_zeros_te(i33_te) ~= 0)) / length(amplitudes_zeros_te(i33_te));

%parts with zeros


%% plot percentages

figure
subplot(3,1,1)
bar([-2;0;2],[t11, t21, t31; t12, t22, t32; t13, t23, t33])
title('Subject1');
subplot(3,1,2)
bar([-2;0;2],[m11, m21, m31; m12, m22, m32; m13, m23, m33])   
title('Subject2');
subplot(3,1,3)
bar([-2;0;2],[te11, te21, te31; te12, te22, te32; te13, te23, te33])
title('Subject3');
suptitle('precentages of accepted meps')

%% plot averages without zeros

figure
subplot(3,1,1)
bar([-2;0;2],[mean(amplitudes_zeros_t(i11_t(amplitudes_zeros_t(i11_t) ~= 0))), mean(amplitudes_zeros_t(i21_t(amplitudes_zeros_t(i21_t) ~= 0))) , mean(amplitudes_zeros_t(i31_t(amplitudes_zeros_t(i31_t) ~= 0)));...
    mean(amplitudes_zeros_t(i12_t(amplitudes_zeros_t(i12_t) ~= 0))), mean(amplitudes_zeros_t(i22_t(amplitudes_zeros_t(i22_t) ~= 0))), mean(amplitudes_zeros_t(i32_t(amplitudes_zeros_t(i32_t) ~= 0)));...
    mean(amplitudes_zeros_t(i13_t(amplitudes_zeros_t(i13_t) ~= 0))), mean(amplitudes_zeros_t(i23_t(amplitudes_zeros_t(i23_t) ~= 0))), mean(amplitudes_zeros_t(i33_t(amplitudes_zeros_t(i33_t) ~= 0)))]);
title('Subject1')
subplot(3,1,2)
bar([-2;0;2],[mean(amplitudes_zeros_m(i11_m(amplitudes_zeros_m(i11_m) ~= 0))), mean(amplitudes_zeros_m(i21_m(amplitudes_zeros_m(i21_m) ~= 0))), mean(amplitudes_zeros_m(i31_m(amplitudes_zeros_m(i31_m) ~= 0)));...
    mean(amplitudes_zeros_m(i12_m(amplitudes_zeros_m(i12_m) ~= 0))), mean(amplitudes_zeros_m(i22_m(amplitudes_zeros_m(i22_m) ~= 0))), mean(amplitudes_zeros_m(i32_m(amplitudes_zeros_m(i32_m) ~= 0)));...
    mean(amplitudes_zeros_m(i13_m(amplitudes_zeros_m(i13_m) ~= 0))), mean(amplitudes_zeros_m(i23_m(amplitudes_zeros_m(i23_m) ~= 0))), mean(amplitudes_zeros_m(i33_m(amplitudes_zeros_m(i33_m) ~= 0)))]);
title('Subject2')
subplot(3,1,3)
bar([-2;0;2],[mean(amplitudes_zeros_te(i11_te(amplitudes_zeros_te(i11_te) ~= 0))), mean(amplitudes_zeros_te(i21_te(amplitudes_zeros_te(i21_te) ~= 0))), mean(amplitudes_zeros_te(i31_te(amplitudes_zeros_te(i31_te) ~= 0)));...
    mean(amplitudes_zeros_te(i12_te(amplitudes_zeros_te(i12_te) ~= 0))), mean(amplitudes_zeros_te(i22_te(amplitudes_zeros_te(i22_te) ~= 0))), mean(amplitudes_zeros_te(i32_te(amplitudes_zeros_te(i32_te) ~= 0)));...
    mean(amplitudes_zeros_te(i13_te(amplitudes_zeros_te(i13_te) ~= 0))), mean(amplitudes_zeros_te(i23_te(amplitudes_zeros_te(i23_te) ~= 0))), mean(amplitudes_zeros_te(i33_te(amplitudes_zeros_te(i33_te) ~= 0)))]);
title('Subject3')
suptitle('Averages without zeros')

%% plot averages with zeros
figure
subplot(3,1,1)
bar([-2;0;2],[mean(amplitudes_zeros_t(i11_t)), mean(amplitudes_zeros_t(i21_t)) mean(amplitudes_zeros_t(i31_t));...
    mean(amplitudes_zeros_t(i12_t)), mean(amplitudes_zeros_t(i22_t)), mean(amplitudes_zeros_t(i32_t));...
    mean(amplitudes_zeros_t(i13_t)), mean(amplitudes_zeros_t(i23_t)), mean(amplitudes_zeros_t(i33_t))]);
title('Subject1')
subplot(3,1,2)
bar([-2;0;2],[mean(amplitudes_zeros_m(i11_m)), mean(amplitudes_zeros_m(i21_m)), mean(amplitudes_zeros_m(i31_m));...
    mean(amplitudes_zeros_m(i12_m)), mean(amplitudes_zeros_m(i22_m)), mean(amplitudes_zeros_m(i32_m));...
    mean(amplitudes_zeros_m(i13_m)), mean(amplitudes_zeros_m(i23_m)), mean(amplitudes_zeros_m(i33_m))]);
title('Subject2')
subplot(3,1,3)
bar([-2;0;2],[mean(amplitudes_zeros_te(i11_te)), mean(amplitudes_zeros_te(i21_te)), mean(amplitudes_zeros_te(i31_te));...
    mean(amplitudes_zeros_te(i12_te)), mean(amplitudes_zeros_te(i22_te)), mean(amplitudes_zeros_te(i32_te));...
    mean(amplitudes_zeros_te(i13_te)), mean(amplitudes_zeros_te(i23_te)), mean(amplitudes_zeros_te(i33_te))]);
title('Subject3')
suptitle('Averages with zeros')

%% same than above, but differently put

%% plot percentages 2

figure
subplot(3,1,1)
bar([-2;0;2],[t11, m11, te11; t12, m12, te12; t13, m13, te13])
title('MT-1');
subplot(3,1,2)
bar([-2;0;2],[t21, m21, te21; t22, m22, te22; t23, m23, te23])   
title('MT');
subplot(3,1,3)
bar([-2;0;2],[t31, m31, te31; t32, m32, te32; t33, m33, te33])
title('MT+1');
suptitle('precentages of accepted meps')

%% plot as function of max V/m

%Current -2
a1_te = find(condition_te==1);

%Current 0
a2_te = find(condition_te==2);

%Current +2
a3_te = find(condition_te==3);

figure
hold on
subplot(3,1,1)
plot(intensity2_te(a1_te),amplitudes_zeros_te(a1_te), 'ro');
xlabel('V/m')
ylabel('MEP size')
axis([75,105,0, 1000])
subplot(3,1,2)
plot(intensity2_te(a2_te),amplitudes_zeros_te(a2_te), 'bo');
xlabel('V/m')
ylabel('MEP size')
axis([75,105,0, 1000])
subplot(3,1,3)
plot(intensity2_te(a3_te),amplitudes_zeros_te(a3_te), 'go');
suptitle('Subject3')
xlabel('V/m')
ylabel('MEP size')
axis([75,105,0, 1000])

%Current -2
a1_m = find(condition_m==1);

%Current 0
a2_m = find(condition_m==2);

%Current +2
a3_m = find(condition_m==3);

figure
hold on
subplot(3,1,1)
plot(intensity2_m(a1_m),amplitudes_zeros_m(a1_m), 'ro');
axis([59, 67, 0, 1000])
xlabel('V/m')
ylabel('MEP size')
subplot(3,1,2)
plot(intensity2_m(a2_m),amplitudes_zeros_m(a2_m), 'bo');
xlabel('V/m')
ylabel('MEP size')
axis([59, 67,0, 1000])
subplot(3,1,3)
plot(intensity2_m(a3_m),amplitudes_zeros_m(a3_m), 'go');
suptitle('Subject2')
xlabel('V/m')
ylabel('MEP size')
axis([59, 67,0, 1000])

%Current -2
a1_t = find(condition_t==1);

%Current 0
a2_t = find(condition_t==2);

%Current +2
a3_t = find(condition_t==3);

figure
hold on
subplot(3,1,1)
plot(intensity2_t(a1_t),amplitudes_zeros_t(a1_t), 'ro');
xlabel('V/m')
ylabel('MEP size')
axis([87, 100,0, 1000])
subplot(3,1,2)
plot(intensity2_t(a2_t),amplitudes_zeros_t(a2_t), 'bo');
xlabel('V/m')
ylabel('MEP size')
axis([87, 100,0, 1000])
subplot(3,1,3)
plot(intensity2_t(a3_t),amplitudes_zeros_t(a3_t), 'go');
suptitle('Subject1')
xlabel('V/m')
ylabel('MEP size')
axis([87, 100,0, 1000])

%% plot as function of max V/m

%Current -2
a1_te = find(condition_te==1);

%Current 0
a2_te = find(condition_te==2);

%Current +2
a3_te = find(condition_te==3);

figure
hold on
subplot(3,1,1)
plot(amplitudes_zeros_te(a1_te),intensity2_te(a1_te), 'ro');
ylabel('V/m')
xlabel('MEP size')
axis([0, 1000,75,105])
subplot(3,1,2)
plot(amplitudes_zeros_te(a2_te),intensity2_te(a2_te), 'bo');
ylabel('V/m')
xlabel('MEP size')
axis([0, 1000,75,105])
subplot(3,1,3)
plot(amplitudes_zeros_te(a3_te),intensity2_te(a3_te), 'go');
suptitle('Subject3')
ylabel('V/m')
xlabel('MEP size')
axis([0, 1000,75,105])

%Current -2
a1_m = find(condition_m==1);

%Current 0
a2_m = find(condition_m==2);

%Current +2
a3_m = find(condition_m==3);

figure
hold on
subplot(3,1,1)
plot(intensity2_m(a1_m),amplitudes_zeros_m(a1_m), 'ro');
axis([59, 67, 0, 1000])
xlabel('V/m')
ylabel('MEP size')
subplot(3,1,2)
plot(intensity2_m(a2_m),amplitudes_zeros_m(a2_m), 'bo');
xlabel('V/m')
ylabel('MEP size')
axis([59, 67,0, 1000])
subplot(3,1,3)
plot(intensity2_m(a3_m),amplitudes_zeros_m(a3_m), 'go');
suptitle('Subject2')
xlabel('V/m')
ylabel('MEP size')
axis([59, 67,0, 1000])

%Current -2
a1_t = find(condition_t==1);

%Current 0
a2_t = find(condition_t==2);

%Current +2
a3_t = find(condition_t==3);

figure
hold on
subplot(3,1,1)
plot(intensity2_t(a1_t),amplitudes_zeros_t(a1_t), 'ro');
xlabel('V/m')
ylabel('MEP size')
axis([87, 100,0, 1000])
subplot(3,1,2)
plot(intensity2_t(a2_t),amplitudes_zeros_t(a2_t), 'bo');
xlabel('V/m')
ylabel('MEP size')
axis([87, 100,0, 1000])
subplot(3,1,3)
plot(intensity2_t(a3_t),amplitudes_zeros_t(a3_t), 'go');
suptitle('Subject1')
xlabel('V/m')
ylabel('MEP size')
axis([87, 100,0, 1000])