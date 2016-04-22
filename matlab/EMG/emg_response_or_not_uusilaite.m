clear;
close all;

dir = 'E:\MEP sorting\MEP14\';
input_dir = [dir,'EMG\'];
output_dir = [dir,'EMG_kasitelty\'];

emgfile = 'masking3.mat';
output_number = '3';

load([input_dir,emgfile]);
celldata = struct2cell(datablock1);
emgdata = cell2mat(celldata(2));
firstsampletime = cell2mat(celldata(1));

baseline = 0.2; %sec = 200 msec
triallength = 0.5;  %sec = 500 msec
timeAxis = 1000*(-baseline:1/sampfreq:triallength);
% save([output_dir,'timeAxis.mat'],'timeAxis');

disp(comment);
%Change the muscle name:
% sources = 'FCR'
%----------------------

triggers = (markers - firstsampletime) * sampfreq +1;
for muscle=1:channels
%     emgtrials = [];
%     disp(sources(muscle,:))
%     for i=1:length(markers)
%         emgtrials = [emgtrials emgdata(round(triggers(i)-(sampfreq*0.2)):round(triggers(i)+(sampfreq*triallength)),muscle)];
%     end
%     emgtrials = emgtrials';
%     save([output_dir,'emgtrials_',output_number,'_',sources(muscle,:),'.mat'],'emgtrials');
    load([output_dir,'emgtrials_',output_number,'_',sources(muscle,:),'.mat']);
    
    boksi = msgbox('Click mouse if there is a response / keyboard if there is not!','Message!');
    uiwait(boksi);

    %Select the accepted/rejected trials:
    emgResponseOrNot = ones(1,size(emgtrials,1));
    figure
    for i=1:size(emgtrials,1)
        plot(timeAxis,emgtrials(i,:))
        title('Select accepted(mouse) / rejected(keyboard) trials')
        xlabel('Time (ms)')
        ylabel('Voltage (\mu V)')
        xlim([15 45])
        button = waitforbuttonpress;
        if button==0,  
            disp(['Trial ' int2str(i) ', Accepted']);
        else
            emgResponseOrNot(i) = 0;
            disp(['Trial ' int2str(i) ', Rejected']);
        end
    end
    save([output_dir,'emgResponseOrNot_',output_number,'_',sources(muscle,:),'.mat'],'emgResponseOrNot');
    nAcceptedEmgTrials = sum(emgResponseOrNot)
    
    load([output_dir,'acceptedEmg_',output_number,'_',sources(muscle,:),'.mat'])
    load([output_dir,'amplitudes_',output_number,'_',sources(muscle,:),'.mat']);

    %Plots the amplitudes:
    figure
    for i=1:size(emgtrials,1)
        if ~emgResponseOrNot(i)
            plot(i,amplitudes(i),'co')
            hold on
        elseif emgAccepted(i)
            plot(i,amplitudes(i),'bo')
            hold on
        else
            plot(i,amplitudes(i),'ro')
            hold on
        end
    end
    title('Amplitudes')
    xlabel('Trial #')
    ylabel('Amplitude (\mu V)')
    
    [sortedAmplitudes,sortIndex] = sort(amplitudes);
    sortedResponseOrNot = emgResponseOrNot(sortIndex);
    sortedAccepted = emgAccepted(sortIndex);
    
    %Plots the sorted amplitudes:
    figure
    for i=1:size(emgtrials,1)
        if ~sortedResponseOrNot(i)
            plot(i,sortedAmplitudes(i),'co')
            hold on
        elseif sortedAccepted(i)
            plot(i,sortedAmplitudes(i),'bo')
            hold on
        else
            plot(i,sortedAmplitudes(i),'ro')
            hold on
        end
    end
    title('Sorted amplitudes')
    xlabel('Trial # (sorted)')
    ylabel('Amplitude (\mu V)')
    
    meanAmpl = mean(amplitudes)
    stdAmpl = std(amplitudes)
end