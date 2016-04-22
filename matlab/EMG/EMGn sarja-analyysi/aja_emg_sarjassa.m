function aja_emg_sarjassa(dir,trig,emg,output_name)

%Files and directories:
input_dir = [dir,'EMG\'];       %Experiment directory containing raw input EMG files
output_dir = [dir,'EMG_kasitelty\'];    %Output directory
trigfile = [input_dir,trig];     %Input trigger file name
emgfile = [input_dir,emg];      %Input EMG file name

%--Select accepted trials and save them into a .mat file OR load a .mat file
%   with the accepted trials
[emgTrials,timeAxis] = emgSelectTrials_sarja(trigfile,emgfile,output_dir,output_name,[-50 1000],[-50 0]);  %emgTrials (trials x samples)
save([output_dir,'emgtrials_',output_name,'.mat'],'emgTrials');
save([output_dir,'timeAxis.mat'],'timeAxis');