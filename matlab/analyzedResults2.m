clear
t = load('/home/mmkukkon/Desktop/tuloksia/Tuomas/emg_analyzednew.mat');

figure
plot(1:300, t.e_e)

figure
hist(sort(t.e_e),30)

figure
m1 = find(t.mt_fdi > 50)
plot(m1, t.mt_fdi(m1), 'o')
title('fdi_mt')

figure
m = find(t.e_fdi > 50)
plot(t.e_e(m), t.e_fdi(m), '*')
title('fdi + sähkö')

figure
m2 = find(t.mt_apb > 50)
plot(m2, t.mt_apb(m2), 'o')
title('apb_mt')

figure
m3 = find(t.e_apb > 50)
plot(t.e_e(m3), t.e_apb(m3), '*')
title('apb + sähkö')

figure
plot(m3, t.e_apb(m3),'*')

%%

h1 = [];
h2 = [];
i = 1;

for x = -3500:100:3500
[h1(i), h2(i)] = around(t.e_e, t.e_fdi, x, 400);
i = i+1;
end

figure
plot(-3500:100:3500,h1)
figure
plot(-3500:100:3500,h2)

