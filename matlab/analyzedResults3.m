clear all

j1 = load('/home/mmkukkon/Desktop/tuloksia/Joonas/joonas_mt_1.mat');
j2 = load('/home/mmkukkon/Desktop/tuloksia/Joonas/joonas_mt_2.mat');
j3 = load('/home/mmkukkon/Desktop/tuloksia/Joonas/joonas_mt_3.mat');
j4 = load('/home/mmkukkon/Desktop/tuloksia/Joonas/joonas_mt-_1.mat');
j5 = load('/home/mmkukkon/Desktop/tuloksia/Joonas/joonas_mt-_2.mat');
j6 = load('/home/mmkukkon/Desktop/tuloksia/Joonas/joonas_mt-_3.mat');
j7 = load('/home/mmkukkon/Desktop/tuloksia/Joonas/joonas_mt+_1.mat');
j8 = load('/home/mmkukkon/Desktop/tuloksia/Joonas/joonas_mt+_2.mat');
j9 = load('/home/mmkukkon/Desktop/tuloksia/Joonas/joonas_mt+_3.mat');

%Joonas at MT

j_mt_e = [j1.elec1(2:101); j2.elec1; j3.elec1];
j_n_e = [j4.elec1; j5.elec1; j6.elec1];
j_p_e = [j7.elec1(2:101); j8.elec1; j9.elec1];

j_mt = [j1.amplitudes(2:101), j2.amplitudes, j3.amplitudes];
j_n = [j4.amplitudes, j5.amplitudes, j6.amplitudes];
j_p = [j7.amplitudes(2:101), j8.amplitudes, j9.amplitudes];

n1 = load('/home/mmkukkon/Desktop/tuloksia/Niko/niko_mt_1.mat');
n2 = load('/home/mmkukkon/Desktop/tuloksia/Niko/niko_mt_2.mat');
n3 = load('/home/mmkukkon/Desktop/tuloksia/Niko/niko_mt_3.mat');
n4 = load('/home/mmkukkon/Desktop/tuloksia/Niko/niko_mt-_1.mat');
n5 = load('/home/mmkukkon/Desktop/tuloksia/Niko/niko_mt-_2.mat');
n6 = load('/home/mmkukkon/Desktop/tuloksia/Niko/niko_mt-_3.mat');
n7 = load('/home/mmkukkon/Desktop/tuloksia/Niko/niko_mt+_1.mat');
n8 = load('/home/mmkukkon/Desktop/tuloksia/Niko/niko_mt+_2.mat');
n9 = load('/home/mmkukkon/Desktop/tuloksia/Niko/niko_mt+_3.mat');

n_mt_e = [n1.elec1(11:110); n2.elec1; n3.elec1(2:101)];
n_n_e = [n4.elec1(2:101); n5.elec1; n6.elec1];
n_p_e = [n7.elec1(11:110); n8.elec1; n9.elec1];

n_mt = [n1.amplitudes(11:110), n2.amplitudes, n3.amplitudes(2:101)];
n_n = [n4.amplitudes(2:101), n5.amplitudes, n6.amplitudes];
n_p = [n7.amplitudes(11:110), n8.amplitudes, n9.amplitudes];

clear j1 j2 j3 j4 j5 j6 j7 j8 j9 n1 n2 n3 n4 n5 n6 n7 n8 n9 

%% plot Joonas' data

ind1 = find(j_mt>50);
ind2 = find(j_n>50);
ind3 = find(j_p>50);


figure
hold on 
plot(-j_mt_e, j_mt, 'ro')
plot(-j_mt_e(ind1), j_mt(ind1), 'o')
title('motor threshold')

figure
hold on
plot(-j_n_e, j_n, 'ro')
plot(-j_n_e(ind2), j_n(ind2), 'o')
title('under motor threshold')

figure
hold on
plot(-j_p_e, j_p, 'ro')
plot(-j_p_e(ind3), j_p(ind3), 'o')
title('above motor threshold')


j1 = [];
j2 = [];
j1_n = [];
j2_n = [];
j1_p = [];
j2_p = [];
i = 1;

for x = -0.0006:0.000003:0.0006
[j1(i), j2(i)] = aroundj(-j_mt_e', j_mt, x, 0.0005);
[j1_n(i), j2_n(i)] = aroundj(-j_n_e', j_n, x, 0.0005);
[j1_p(i), j2_p(i)] = aroundj(-j_p_e', j_p, x, 0.0005);
i = i+1;
end


figure
hold on
plot(-0.0006:0.000003:0.0006,j1)
plot(-0.0006:0.000003:0.0006,j1_n,'r')
plot(-0.0006:0.000003:0.0006,j1_p,'g')
title('joonas')
legend('mt','below','above')
figure
hold on
plot(-0.0006:0.000003:0.0006,j2)
plot(-0.0006:0.000003:0.0006,j2_n,'r')
plot(-0.0006:0.000003:0.0006,j2_p,'g')
title('joonas')
legend('mt','below','above')


%% plot Niko'2 data

ind1 = find(n_mt>50);
ind2 = find(n_n>50);
ind3 = find(n_p>50);


j1 = [];
j2 = [];
j1_n = [];
j2_n = [];
j1_p = [];
j2_p = [];
i = 1;

for x = -0.0006:0.000003:0.0006
[j1(i), j2(i)] = aroundj(-j_mt_e', j_mt, x, 0.0001);
[j1_n(i), j2_n(i)] = aroundj(-j_n_e', j_n, x, 0.0001);
[j1_p(i), j2_p(i)] = aroundj(-j_p_e', j_p, x, 0.0001);
i = i+1;
end


figure
hold on
plot(-0.0006:0.000003:0.0006,j1)
plot(-0.0006:0.000003:0.0006,j1_n,'r')
plot(-0.0006:0.000003:0.0006,j1_p,'g')
title('joonas')
legend('mt','below','above')
figure
hold on
plot(-0.0006:0.000003:0.0006,j2)
plot(-0.0006:0.000003:0.0006,j2_n,'r')
plot(-0.0006:0.000003:0.0006,j2_p,'g')
title('joonas')
legend('mt','below','above')

figure
hold on 
plot(n_mt_e, n_mt, 'ro')
plot(n_mt_e(ind1), n_mt(ind1), 'o')
title('motor threshold')

figure
hold on
plot(n_n_e, n_n, 'ro')
plot(n_n_e(ind2), n_n(ind2), 'o')
title('under motor threshold')

figure
hold on
plot(n_p_e, n_p, 'ro')
plot(n_p_e(ind3), n_p(ind3), 'o')
title('above motor threshold')




n1 = [];
n2 = [];
n1_n = [];
n2_n = [];
n1_p = [];
n2_p = [];
i = 1;

for x = -0.0003:0.000001:0.0003
[n1(i), n2(i)] = around(n_mt_e', n_mt, x, 0.0004);
[n1_n(i), n2_n(i)] = around(n_n_e', n_n, x, 0.0004);
[n1_p(i), n2_p(i)] = around(n_p_e', n_p, x, 0.0004);
i = i+1;
end


figure
hold on
plot(-0.0003:0.000001:0.0003,n1)
plot(-0.0003:0.000001:0.0003,n1_n,'r')
plot(-0.0003:0.000001:0.0003,n1_p,'g')
title('niko')
legend('mt','below','above')
figure
hold on
plot(-0.0003:0.000001:0.0003,n2)
plot(-0.0003:0.000001:0.0003,n2_n,'r')
plot(-0.0003:0.000001:0.0003,n2_p,'g')
title('niko')
legend('mt','below','above')





