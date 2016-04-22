%% Load data

clear

%Riston datat MT:n kohdassa
r_e_minus = load('/home/mmkukkon/Desktop/tuloksia/Risto/MT/raw_MT_e-.mat');
r_e_minus2 = load('/home/mmkukkon/Desktop/tuloksia/Risto/MT/raw_MT_e-_2.mat');
r_e_plus = load('/home/mmkukkon/Desktop/tuloksia/Risto/MT/raw_MT_e+.mat');
r_e_plus2 = load('/home/mmkukkon/Desktop/tuloksia/Risto/MT/raw_MT_e+_2.mat');
r_plain2 = load('/home/mmkukkon/Desktop/tuloksia/Risto/MT/raw_MT_plain_2.mat');
r_plain3 = load('/home/mmkukkon/Desktop/tuloksia/Risto/MT/raw_MT_plain_3.mat');
r_plain = load('/home/mmkukkon/Desktop/tuloksia/Risto/MT/raw_plain.mat');

%Matleenan datat MT:ssä
m_mt_e = load('/home/mmkukkon/Desktop/tuloksia/Matleena/MT/raw_MT_electric.mat');
m_mt_p = load('/home/mmkukkon/Desktop/tuloksia/Matleena/MT/raw_MT_plain.mat');

%Matleenan datat MT-1
m_mt_minus = load('/home/mmkukkon/Desktop/tuloksia/Matleena/MT-/raw_MT-.mat');

%Matleenan datat MT+1
m_mt_plus = load('/home/mmkukkon/Desktop/tuloksia/Matleena/MT+/raw_MT+.mat');

%Tuomaksen datat MT:ssä
t_mt = load('/home/mmkukkon/Desktop/tuloksia/Tuomas/MT/raw_MT.mat');

%Tuomaksen datat MT+2:ssa
t_mt_plus = load('/home/mmkukkon/Desktop/tuloksia/Tuomas/MT2+/raw_MT2+.mat');

%Risto_intensity
r_i_plus = load('/home/mmkukkon/Desktop/tuloksia/Risto/Intensity/raw_intensity+_.mat');
r_i_minus = load('/home/mmkukkon/Desktop/tuloksia/Risto/Intensity/raw_intensity-.mat');
r_i_plain = load('/home/mmkukkon/Desktop/tuloksia/Risto/Intensity/raw_intensity_.mat');

%Tuomas_intensity
t_i = load('/home/mmkukkon/Desktop/tuloksia/Tuomas/Intensity/raw_intensity.mat');

%% Split data to similar pieces

%Matleena's data

m_mt_eplus = m_mt_e.amplitudes(1:50);
m_mt_eminus = m_mt_e.amplitudes(51:100);
m_mt = m_mt_p.amplitudes(:)';

m_mtminus = m_mt_minus.amplitudes(1:50);
m_mtminus_eminus = m_mt_minus.amplitudes(51:100);
m_mtminus_eplus = m_mt_minus.amplitudes(101:150);

m_mtplus_eminus = m_mt_plus.amplitudes(1:50);
m_mtplus = m_mt_plus.amplitudes(51:100);
m_mtplus_eplus = m_mt_plus.amplitudes(101:150);

%Tuomas' data

t_mt_eplus = t_mt.amplitudes(51:100);
t_mt_eminus = t_mt.amplitudes(101:150);
t_mt = t_mt.amplitudes(1:50);

t_mtplus_eplus = t_mt_plus.amplitudes(1:50);
t_mtplus_eminus = t_mt_plus.amplitudes(51:100);
t_mtplus = t_mt_plus.amplitudes(101:150);

t_i_eplus = [t_i.amplitudes(151:175),t_i.amplitudes(101:125),t_i.amplitudes(176:200),t_i.amplitudes(126:150)];
t_i_eminus = [t_i.amplitudes(51:75),t_i.amplitudes(76:100),t_i.amplitudes(1:25),t_i.amplitudes(26:50)];
t_i = [t_i.amplitudes(226:275),t_i.amplitudes(201:225),t_i.amplitudes(276:300)];

%Risto's data

r_mt_eplus = [r_e_plus.amplitudes(:)', r_e_plus2.amplitudes(:)'];
r_mt_eminus = [r_e_minus.amplitudes(:)', r_e_minus2.amplitudes(:)'];
r_mt = [r_plain.amplitudes(:)', r_plain2.amplitudes(:)', r_plain3.amplitudes(:)'];

r_i_eplus = [r_i_plus.amplitudes(21:30), r_i_plus.amplitudes(1:20), r_i_plus.amplitudes(31:40)];
r_i_eminus = r_i_minus.amplitudes(:)';
r_i = [r_i_plain.amplitudes(11:40),r_i_plain.amplitudes(1:10)];

%%
clear m_mt_e m_mt_p r_i_plus r_i_minus r_i_plain m_mt_minus m_mt_plus r_plain r_plain2 r_plain3 t_mt_plus r_e_plus r_e_plus2 r_e_minus r_e_minus2

%% Matleena's data to 0
m_mt_eminus0 = m_mt_eminus;
m_mt_eminus0(find(m_mt_eminus0 < 50)) = 0;

m_mt0 = m_mt;
m_mt0(find(m_mt0 < 50)) = 0;

m_mt_eplus0 = m_mt_eplus;
m_mt_eplus0(find(m_mt_eplus0 < 50)) = 0

%Plus
m_mtplus_eminus0 = m_mtplus_eminus;
m_mtplus_eminus0(find(m_mtplus_eminus0 < 50)) = 0;

m_mtplus0 = m_mtplus;
m_mtplus0(find(m_mtplus0 < 50)) = 0;

m_mtplus_eplus0 = m_mtplus_eplus;
m_mtplus_eplus0(find(m_mtplus_eplus0 < 50)) = 0

%Minus

m_mtminus_eminus0 = m_mtminus_eminus;
m_mtminus_eminus0(find(m_mtminus_eminus0 < 50)) = 0;

m_mtminus0 = m_mtminus;
m_mtminus0(find(m_mtminus0 < 50)) = 0;

m_mtminus_eplus0 = m_mtminus_eplus;
m_mtminus_eplus0(find(m_mtminus_eplus0 < 50)) = 0



%% Means/ Medians / What ever
figure
subplot(3,1,1)
hold on
plot([-2, 0, 2], [mean(m_mt_eminus), mean(m_mt), mean(m_mt_eplus)], 'r*-', 'LineWidth', 2)
plot([-2, 0, 2], [mean(m_mt_eminus(find(m_mt_eminus > 50))), mean(m_mt(find(m_mt > 50))), mean(m_mt_eplus(find(m_mt_eplus > 50)))], 'b*-', 'LineWidth', 2)
plot([-2, 0, 2], [mean(m_mt_eminus0), mean(m_mt0), mean(m_mt_eplus0)], 'g*-', 'LineWidth', 2)
legend('mean', 'mean with only > 50', 'mean with 0')
title('MT')

subplot(3,1,2)
hold on
plot([-2, 0, 2], [mean(m_mtminus_eminus), mean(m_mtminus), mean(m_mtminus_eplus)], 'r*-', 'LineWidth', 2)
plot([-2, 0, 2], [mean(m_mtminus_eminus(find(m_mtminus_eminus > 50))), mean(m_mtminus(find(m_mtminus > 50))), mean(m_mtminus_eplus(find(m_mtminus_eplus > 50)))], 'b*-', 'LineWidth', 2)
plot([-2, 0, 2], [mean(m_mtminus_eminus0), mean(m_mtminus0), mean(m_mtminus_eplus0)], 'g*-', 'LineWidth', 2)
%legend('mean', 'mean with only > 50', 'mean with 0')
title('Under MT')

subplot(3,1,3)
hold on
plot([-2, 0, 2], [mean(m_mtplus_eminus), mean(m_mtplus), mean(m_mtplus_eplus)], 'r*-', 'LineWidth', 2)
plot([-2, 0, 2], [mean(m_mtplus_eminus(find(m_mtplus_eminus > 50))), mean(m_mtplus(find(m_mtplus > 50))), mean(m_mtplus_eplus(find(m_mtplus_eplus > 50)))], 'b*-', 'LineWidth', 2)
plot([-2, 0, 2], [mean(m_mtplus_eminus0), mean(m_mtplus0), mean(m_mtplus_eplus0)], 'g*-', 'LineWidth', 2)
%legend('mean', 'mean with only > 50', 'mean with 0')
title('Above MT')


%% Plots

figure
subplot(3, 1, 1)
hold on
plot([-2, 0, 2], [mean(m_mt_eminus), mean(m_mt), mean(m_mt_eplus)], 'g*-', 'LineWidth', 2)

plot([-2, 0, 2], [mean(t_mt_eminus), mean(t_mt), mean(t_mt_eplus)], 'k*-','LineWidth', 2)

%plot([-2, 0, 2], [mean(r_mt_eminus), mean(r_mt), mean(r_mt_eplus)], 'c*-')
title('mean of all data in MT')

%% Plot of only meps > 50

subplot(3, 1, 2)
hold on

plot([-2, 0, 2], [mean(m_mt_eminus(find(m_mt_eminus > 50))), mean(m_mt(find(m_mt > 50))), mean(m_mt_eplus(find(m_mt_eplus > 50)))], 'g*-', 'LineWidth', 2)

plot([-2, 0, 2], [mean(t_mt_eminus(find(t_mt_eminus > 50))), mean(t_mt(find(t_mt > 50))), mean(t_mt_eplus(find(t_mt_eplus > 50)))], 'k*-', 'LineWidth', 2)

%plot([-2, 0, 2], [mean(r_mt_eminus(find(r_mt_eminus > 50))), mean(r_mt(find(r_mt > 50))), mean(r_mt_eplus(find(r_mt_eplus > 50)))], 'c*-')
title('mean of all meps (>50) in MT')

%% Plot num of meps > 50

subplot(3,1,3)
hold on

plot([-2, 0, 2], [length(find(m_mt_eminus > 50)), length(find(m_mt > 50)), length(find(m_mt_eplus > 50))], 'g*-', 'LineWidth', 2)

plot([-2, 0, 2], [length(find(t_mt_eminus > 50)), length(find(t_mt > 50)), length(find(t_mt_eplus > 50))], 'k*-', 'LineWidth', 2)

%plot([-2, 0, 2], [length(find(r_mt_eminus > 50)), length(find(r_mt > 50)), length(find(r_mt_eplus > 50))], 'c*-', 'LineWidth', 2)
title('num of meps in MT')
legend('g = Matleena', 'k = Tuomas')

%% Plot of Matleenas

figure
subplot(3, 1, 1)
hold on

plot([-2, 0, 2], [mean(m_mtplus_eminus), mean(m_mtplus), mean(m_mtplus_eplus)], 'k*-', 'LineWidth', 2)

plot([-2, 0, 2], [mean(m_mtminus_eminus), mean(m_mtminus), mean(m_mtminus_eplus)], 'b*-', 'LineWidth', 2)

plot([-2, 0, 2], [mean(m_mt_eminus), mean(m_mt), mean(m_mt_eplus)], 'c*-', 'LineWidth', 2)

title('mean of all data in MT')


% Plot of only meps > 50 (Plot of Matleena)

subplot(3, 1, 2)
hold on

plot([-2, 0, 2], [mean(m_mtplus_eminus(find(m_mtplus_eminus > 50))), mean(m_mtplus(find(m_mtplus > 50))), mean(m_mtplus_eplus(find(m_mtplus_eplus > 50)))], 'k*-', 'LineWidth', 2)

plot([-2, 0, 2], [mean(m_mtminus_eminus(find(m_mtminus_eminus > 50))), mean(m_mtminus(find(m_mtminus > 50))), mean(m_mtminus_eplus(find(m_mtminus_eplus > 50)))], 'b*-', 'LineWidth', 2)

plot([-2, 0, 2], [mean(m_mt_eminus(find(m_mt_eminus > 50))), mean(m_mt(find(m_mt > 50))), mean(m_mt_eplus(find(m_mt_eplus > 50)))], 'c*-', 'LineWidth', 2)

title('mean of all meps (>50) in MT')

% Plot num of meps > 50 (Plot of Matleena)

subplot(3, 1, 3)
hold on

plot([-2, 0, 2], [length(find(m_mtplus_eminus > 50)), length(find(m_mtplus > 50)), length(find(m_mtplus_eplus > 50))], 'k*-', 'LineWidth', 2)

plot([-2, 0, 2], [length(find(m_mtminus_eminus > 50)), length(find(m_mtminus > 50)), length(find(m_mtminus_eplus > 50))], 'b*-', 'LineWidth', 2)

plot([-2, 0, 2], [length(find(m_mt_eminus > 50)), length(find(m_mt > 50)), length(find(m_mt_eplus > 50))], 'c*-', 'LineWidth', 2)

legend('Matleena MT+', 'Matleena MT-', 'Matleena MT')
title('num of meps in MT')


%% Plot of Tuomas datas nro1

figure
subplot(3, 1, 1)
hold on

plot([-2, 0, 2], [mean(t_mtplus_eminus), mean(t_mtplus), mean(t_mtplus_eplus)], 'r*-', 'LineWidth', 2)

plot([-2, 0, 2], [mean(t_mt_eminus), mean(t_mt), mean(t_mt_eplus)], 'm*-', 'LineWidth', 2)

title('mean of all data in MT')


% Plot of only meps > 50 (Plot of Tuomas)

subplot(3, 1, 2)
hold on

plot([-2, 0, 2], [mean(t_mtplus_eminus(find(t_mtplus_eminus > 50))), mean(t_mtplus(find(t_mtplus > 50))), mean(t_mtplus_eplus(find(t_mtplus_eplus > 50)))], 'r*-', 'LineWidth', 2)

plot([-2, 0, 2], [mean(t_mt_eminus(find(t_mt_eminus > 50))), mean(t_mt(find(t_mt > 50))), mean(t_mt_eplus(find(t_mt_eplus > 50)))], 'm*-', 'LineWidth', 2)

title('mean of all meps (>50) in MT')

% Plot num of meps > 50 (Plot of Tuomas)

subplot(3, 1, 3)
hold on

plot([-2, 0, 2], [length(find(t_mtplus_eminus > 50)), length(find(t_mtplus > 50)), length(find(t_mtplus_eplus > 50))], 'r*-', 'LineWidth', 2)

plot([-2, 0, 2], [length(find(t_mt_eminus > 50)), length(find(t_mt > 50)), length(find(t_mt_eplus > 50))], 'm*-', 'LineWidth', 2)

legend('Tuomas MT 2+', 'Tuomas MT')
title('num of meps in MT')

%% Plot intensity curves
figure
subplot(2,1,1)
% hold on
% 
% plot([100, 110, 120, 140], [mean(r_i_eplus(1:10)), mean(r_i_eplus(11:20)), mean(r_i_eplus(21:30)), mean(r_i_eplus(31:40))], 'b*-', 'LineWidth', 2)
% plot([100, 110, 120, 140], [mean(r_i_eminus(1:10)), mean(r_i_eminus(11:20)), mean(r_i_eminus(21:30)), mean(r_i_eminus(31:40))], 'k*-', 'LineWidth', 2)
% plot([100, 110, 120, 140], [mean(r_i(1:10)), mean(r_i(11:20)), mean(r_i(21:30)), mean(r_i(31:40))], 'c*-')
% 
% subplot(2,1,2)
hold on

plot([100, 110, 120, 140], [mean(t_i_eplus(1:25)), mean(t_i_eplus(26:50)), mean(t_i_eplus(51:75)), mean(t_i_eplus(76:100))], 'b*-', 'LineWidth', 2)
plot([100, 110, 120, 140], [mean(t_i_eminus(1:25)), mean(t_i_eminus(26:50)), mean(t_i_eminus(51:75)), mean(t_i_eminus(76:100))], 'k*-', 'LineWidth', 2)
plot([100, 110, 120, 140], [mean(t_i(1:25)), mean(t_i(26:50)), mean(t_i(51:75)), mean(t_i(76:100))], 'c*-')
legend('anodal', 'catodal', 'plain tms')

% %% Plot num of meps in intensity curves

% figure
% subplot(2,1,1)
% hold on
% 
% plot([100, 110, 120, 140], [length(find(r_i_eplus(1:10)>50)), length(find(r_i_eplus(11:20)>50)), length(find(r_i_eplus(21:30)>50)), length(find(r_i_eplus(31:40)>50))], 'b*-', 'LineWidth', 2)
% plot([100, 110, 120, 140], [length(find(r_i_eminus(1:10)>50)), length(find(r_i_eminus(11:20)>50)), length(find(r_i_eminus(21:30)>50)), length(find(r_i_eminus(31:40)>50))], 'k*-', 'LineWidth', 2)
% plot([100, 110, 120, 140], [length(find(r_i(1:10)>50)), length(find(r_i(11:20)>50)), length(find(r_i(21:30)>50)), length(find(r_i(31:40)>50))], 'c*-', 'LineWidth', 2)

subplot(2,1,2)
hold on

plot([100, 110, 120, 140], [length(find(t_i_eplus(1:25)>50)), length(find(t_i_eplus(26:50)>50)), length(find(t_i_eplus(51:75)>50)), length(find(t_i_eplus(76:100)>50))], 'b*-', 'LineWidth', 2)
plot([100, 110, 120, 140], [length(find(t_i_eminus(1:25)>50)), length(find(t_i_eminus(26:50)>50)), length(find(t_i_eminus(51:75)>50)), length(find(t_i_eminus(76:100)>50))], 'k*-', 'LineWidth', 2)
plot([100, 110, 120, 140], [length(find(t_i(1:25)>50)), length(find(t_i(26:50)>50)), length(find(t_i(51:75)>50)), length(find(t_i(76:100)>50))], 'c*-', 'LineWidth', 2)

%legend('anodal', 'catodal', 'plain tms')

