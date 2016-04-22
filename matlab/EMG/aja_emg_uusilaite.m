dir = 'E:\MEP sorting\MEP15\';
input_dir = [dir,'EMG\'];
output_dir = [dir,'EMG_kasitelty\'];

emgfile = 'masking5.mat';
output_number = '5';

load([input_dir,emgfile]);
celldata = struct2cell(datablock1);
emgdata = cell2mat(celldata(2));
firstsampletime = cell2mat(celldata(1));

baseline = 0.2; %sec = 200 msec
triallength = 0.5;  %sec = 500 msec
timeAxis = 1000*(-baseline:1/sampfreq:triallength);
save([output_dir,'timeAxis.mat'],'timeAxis');

disp(comment);
%Change the muscle name:
% sources = 'FCR'
%----------------------

triggers = (markers - firstsampletime) * sampfreq +1;
for muscle=1:channels
    emgtrials = [];
    disp(sources(muscle,:))
    for i=1:length(markers)
        emgtrials = [emgtrials emgdata(round(triggers(i)-(sampfreq*0.2)):round(triggers(i)+(sampfreq*triallength)),muscle)];
    end
    emgtrials = emgtrials';
    save([output_dir,'emgtrials_',output_number,'_',sources(muscle,:),'.mat'],'emgtrials');

    boksi = msgbox('Select the accepted (mouse) / rejected (keyboard) trials!','Message!');
    uiwait(boksi);

    %Select the accepted/rejected trials:
    emgAccepted = ones(1,size(emgtrials,1));
    figure
    for i=1:size(emgtrials,1)
        plot(timeAxis,emgtrials(i,:))
        title('Select accepted(mouse) / rejected(keyboard) trials')
        xlabel('Time (ms)')
        ylabel('Voltage (\mu V)')
%         xlim([max(timeAxis(1),latency_TMS-100) latency_TMS+100]);
        button = waitforbuttonpress;
        if button==0,  
            disp(['Trial ' int2str(i) ', Accepted']);
        else
            emgAccepted(i) = 0;
            disp(['Trial ' int2str(i) ', Rejected']);
        end
    end
    save([output_dir,'acceptedEmg_',output_number,'_',sources(muscle,:),'.mat'],'emgAccepted');
    % load([output_dir,'acceptedEmg_',output_number,'_',sources(muscle,:),'.mat']);
    nAcceptedEmgTrials = sum(emgAccepted)
    
    boksi = msgbox('Check the responses! The program will calculate response amplitude automatically. (|min-max| value visible in the plot)','Message!');
    uiwait(boksi)
    %Define amplitudes automatically: 
    amplitudes = emgReadAmplAutomaticallyNew(emgtrials,timeAxis,emgAccepted,sampfreq,[21 32]);
    save([output_dir,'amplitudes_',output_number,'_',sources(muscle,:),'.mat'],'amplitudes');
    % load([output_dir,'amplitudes_',output_number,'_',sources(muscle,:),'.mat']);

    %Plots the amplitudes:
    figure
    for i=1:size(emgtrials,1)
        if emgAccepted(i)
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
    meanAmpl = mean(amplitudes)
    stdAmpl = std(amplitudes)
end