clear;
close all;
%Calculate average MEP amplitudes (1/3 smallest, 1/3 largest)


%-------------------------------------------------------a';
skipTrigAcceptReject = 'on';
skipAcceptReject = 'on';    %'on' if accepting/rejecting already done, 'off' if not
output_muscle = 'ADM' %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if strcmp(output_muscle,'ADM')
    n_measurements = 14; %n_subjects
elseif strcmp(output_muscle,'APB')
    n_measurements = 11;
end
anal_period_samples = 1; % = cycles at dominant frequency
noResponses = 'accept'; %'skip' = mark as rejected, 'zero' = set amplitude as 0, 'accept' = use the amplitude of the noise
%-------------------------------------------------------

ampls_small = zeros(1,n_measurements);
ampls_large = zeros(1,n_measurements);

fs = 1.45;

anal_period_end = 0;
anal_period_end_samples = round((anal_period_end)*fs);

for meas_i = 1:n_measurements

%     meas_i = 14
    
    if strcmp(output_muscle,'ADM')
        strArray = java_array('java.lang.String', n_measurements);
        strArray(1) = java.lang.String('MEP03b'); %Best subjects
        strArray(2) = java.lang.String('MEP05b');
        strArray(3) = java.lang.String('MEP06');
        strArray(4) = java.lang.String('MEP10');
        strArray(5) = java.lang.String('MEP14');
        strArray(6) = java.lang.String('MEP04');  %Other subjects
        strArray(7) = java.lang.String('MEP08');
        strArray(8) = java.lang.String('MEP09');
        strArray(9) = java.lang.String('MEP11');
        strArray(10) = java.lang.String('MEP13');
        strArray(11) = java.lang.String('AM02');
        strArray(12) = java.lang.String('MEP02');
        strArray(13) = java.lang.String('TM05'); %Samuli
        strArray(14) = java.lang.String('TM02c'); %Miikka
%         strArray(nn) = java.lang.String('AM01'); Sama subj. kuin AM01
    elseif strcmp(output_muscle,'APB')
        strArray = java_array('java.lang.String', n_measurements);
        strArray(1) = java.lang.String('MEP03b'); %Best subjects
        strArray(2) = java.lang.String('MEP05b');
        strArray(3) = java.lang.String('MEP14');
        strArray(4) = java.lang.String('MEP04');  %Other subjects
        strArray(5) = java.lang.String('MEP08');
        strArray(6) = java.lang.String('MEP09');
        strArray(7) = java.lang.String('MEP11');
        strArray(8) = java.lang.String('MEP13');
        strArray(9) = java.lang.String('AM02');
        strArray(10) = java.lang.String('TM05');
        strArray(11) = java.lang.String('TM02c');
    end
    measArray = cell(strArray);
    clear strArray;
    experiment = measArray{meas_i}


    if strcmp(experiment(1),'M')
        dir = ['E:\MEP sorting\',experiment,'\'];
    elseif strcmp(experiment(1),'A')
        dir = ['E:\Auditory masking\',experiment,'\'];
    elseif strcmp(experiment(1),'T')
        dir = ['E:\Topographical mapping\',experiment,'\'];
    end
    input_dir = [dir,'EEG\'];
    output_dir = [dir,'EEG_kasitelty\'];
    emgdir = [dir,'EMG_kasitelty\'];


    if strcmp(experiment,'MEP03b')
        output_number = '4';
        output_name = [output_number,'_',output_muscle];
        input_file = [input_dir,'20071210_093038_tuomas_tölli_',num2str(output_number),'.nxe'];
    elseif strcmp(experiment,'MEP04')
        output_number = '1';
        output_name = [output_number,'_',output_muscle];
        input_file = [input_dir,'20071128_093942_jaakko_nieminen_jn_',num2str(output_number),'.nxe'];
    elseif strcmp(experiment,'MEP05b')
        if strcmp(output_muscle,'ADM')
            output_number = '1';
        elseif strcmp(output_muscle,'APB')
            output_number = '3';
        end
        output_name = [output_number,'_',output_muscle];
        input_file = [input_dir,'20071207_122929_janne_räsänen_',num2str(output_number),'.nxe'];
    elseif strcmp(experiment,'MEP06')
        output_number = '4';
        output_name = [output_number,'_',output_muscle];
        input_file = [input_dir,'20071205_104459_atte_lajunen_',num2str(output_number),'.nxe'];
    elseif strcmp(experiment,'MEP07')
        output_number = '3';
        output_name = [output_number,'_',output_muscle];
        input_file = [input_dir,'20071217_093107_frans_vinberg_',num2str(output_number),'.nxe'];
    elseif strcmp(experiment,'MEP08')
        output_number = '2';
        output_name = [output_number,'_',output_muscle];
        input_file = [input_dir,'20080212_122205_johanna_metsomaa_',num2str(output_number),'.nxe'];
    elseif strcmp(experiment,'MEP09')
        output_number = '1';
        output_name = [output_number,'_',output_muscle];
        input_file = [input_dir,'20080215_094752_mikko_lilja_',num2str(output_number),'.nxe'];
    elseif strcmp(experiment,'MEP10')
        output_number = '1';
        output_name = [output_number,'_',output_muscle];
        input_file = [input_dir,'20080220_083449_jaakko_virtanen_',num2str(output_number),'.nxe'];
    elseif strcmp(experiment,'MEP11')
        output_number = '3';
        output_name = [output_number,'_',output_muscle];
        input_file = [input_dir,'20080220_115320_tommi_ekholm_',num2str(output_number),'.nxe'];
    elseif strcmp(experiment,'MEP13')
        output_number = '1';
        output_name = [output_number,'_',output_muscle];
        input_file = [input_dir,'20080226_113336_yrjö_häme_masking',num2str(output_number),'.nxe'];
    elseif strcmp(experiment,'MEP14')
        output_number = '3';
        output_name = [output_number,'_',output_muscle];
        input_file = [input_dir,'20080227_095110_lauri_lipiäinen_masking',num2str(output_number),'.nxe'];
    elseif strcmp(experiment,'AM02')
        output_number = '0n';
        output_name = [output_number,'_',output_muscle];
        input_file = [input_dir,'20070910_091757_hanna_maki_',num2str(output_number),'.nxe'];
    elseif strcmp(experiment,'MEP02')
        output_number = '2';
        output_name = [output_number,'_',output_muscle];
        input_file = [input_dir,'20070820_084211_frans_vinberg_',num2str(output_number),'.nxe'];
    elseif strcmp(experiment,'AM01')
        output_number = '0';
        output_name = [output_number,'_',output_muscle];
        input_file = [input_dir,'20070827_101206_hanna_maki_',num2str(output_number),'.nxe'];
    elseif strcmp(experiment,'TM05')
        output_number = '0';
        output_name = [output_number,'_',output_muscle];
        input_file = [input_dir,'20070718_082952_Samuli_Salminen_1_',num2str(output_number),'.nxe'];
    elseif strcmp(experiment,'TM02c')
        output_number = '0';
        output_name = [output_number,'_',output_muscle];
        input_file = [input_dir,'20070920_084929_fredrik_sannholm_',num2str(output_number),'.nxe'];
    end
    nSessions = 1;
    output_number = {output_number};

    resultDir = 'E:\MEP sorting\yhteisanalyysi\TSE\TSE_small_large\';

        sessions = [];
        for i=1:nSessions
            sessions = [sessions output_number{i}];
        end
        if nSessions == 1
            output_name1 = output_name;
            input_file1 = input_file;
        end

    %-------------------------------------------------------

    trig_channel = 1;   % 1=gate, 2=trig1, 3=trig2
    plotLimits = [-20 20];


    before = 1500;
    after = 0;
    fs = 1.45;  %1/ms
    % downsamplingFactor = 1;
    nChans = 60;
    nTimepoints = round((before + after + 1)*fs);
    ylimits = [-10 10];


    %-------Load EMG responses: 
    amplitudes_new = [];
    acceptedEmg_new = [];
    for i=1:nSessions
        eval(['load([emgdir,''amplitudes_'',output_name',num2str(i),',''.mat'']);']);
        eval(['load([emgdir,''acceptedEmg_'',output_name',num2str(i),',''.mat'']);']);
        amplitudes_new = [amplitudes_new; amplitudes'];
        acceptedEmg_new = [acceptedEmg_new; emgAccepted'];
    end
    amplitudes = amplitudes_new;
    emgAccepted = acceptedEmg_new;
    clear amplitudes_new acceptedEmg_new;
    nEmgTrials = length(amplitudes);

    if strcmp(noResponses,'skip') strcmp(noResponses,'zero')
        load([emgdir,'emgResponseOrNot_',output_name,'.mat']);
        emgAccepted = emgAccepted .* emgResponseOrNot';
    elseif strcmp(noResponses,'zero')
        load([emgdir,'emgResponseOrNot_',output_name,'.mat']);
        amplitudes(find(~emgResponseOrNot)) = 0;
    end
    nEmgTrials = length(amplitudes);
    
    %----------Select trials with a TMS pulse (reject others; don't care about artefacts at this point) 
    %   and save the trigger positions of the accepted trials into a .mat file OR load a .mat file
    %   with the accepted trigger positions:--
    acceptedTrigPositions = [];
    nEegTrials = 0;
    tPos = [];
    nTriggers = zeros(1,nSessions);
    for i=1:nSessions
        if strcmp(skipTrigAcceptReject,'off')
            varname_acceptedTrigPositions = genvarname(['acceptedTrigPositions',output_number{i}],who);
            boksi = msgbox('Select the triggers that actually resulted in a TMS pulse (check if there is a TMS-associated artefact)','Message!');
            uiwait(boksi);
            eval([varname_acceptedTrigPositions '= nxeSelectTrials(input_file',num2str(i),',trig_channel,''rising'',[-100 100],[-100 0],[4:64],30);']);
            eval(['save([output_dir,''accepted_triggers_instphase_'',output_name',num2str(i),',''.mat''], ''acceptedTrigPositions',output_number{i},''');']);
        else
            eval(['load([output_dir,''accepted_triggers_instphase_'',output_name',num2str(i),',''.mat'']);'])
        end
        if nSessions == 1
            eval(['acceptedTrigPositions = acceptedTrigPositions',output_number{i},';']);
        end
        eval(['nEegTrials = nEegTrials + length(acceptedTrigPositions',output_number{i},');']);
    %     eval(['disp([''Session '',output_name',num2str(i),','' cleared''])'])
        eval(['tPos = [tPos; acceptedTrigPositions',output_number{i},'];']);
        eval(['nTriggers(i) = length(acceptedTrigPositions',output_number{i},');']);
    end
    % clear acceptedTrigPositions;
    % nEegTrials

    if nEmgTrials~=nEegTrials
        disp(['Error: There is a different number of EMG and EEG responses! nEEG = ',num2str(nEegTrials),', nEMG = ',num2str(nEmgTrials)])
        return;
    end

    %--------Accept or reject trials based on artefacts (acceptedEeg = vector of 1s (accepted) and 0s (rejected)):
    acceptedEeg = [];
    for i=1:nSessions
        if strcmp(skipAcceptReject,'off')
            boksi = msgbox('Select the accepted trials by clicking the figure using mouse. Reject by pressing any key on the keyboard.)','Message!');
            uiwait(boksi);
            scrsz = get(0,'ScreenSize');
            fig = figure('Position',[1 scrsz(4) scrsz(3) scrsz(4)/2]);
            accepted_new = eval(['acceptRejectResponses(input_file',num2str(i),', acceptedTrigPositions',output_number{i},',[4:64],[-1*before after],[-1*before 0],50);']);
            save([output_dir,'acceptedEeg_instphase_',output_number{i},'.mat'], 'accepted_new');
        else
            accepted_new = cell2mat(struct2cell(load([output_dir,'acceptedEeg_instphase_',output_number{i},'.mat'])));
        end
        acceptedEeg = [acceptedEeg; accepted_new'];
    %     eval(['disp([''Session '',output_name',num2str(i),','' cleared''])'])
    end
    % close all;
    acceptedEegEmg = acceptedEeg.*emgAccepted;
    nAccepted = sum(acceptedEegEmg)

    %Remove rejected trials:
    amplitudes = amplitudes(find(acceptedEegEmg));   
    %Sort amplitudes and tPos:
    [sortedAmplitudes,sortIndex] = sort(amplitudes);
    sortedTPos = tPos(sortIndex);
    
   ampls_small(meas_i) = mean(sortedAmplitudes(1:round(nAccepted/3)));
   ampls_large(meas_i) = mean(sortedAmplitudes(end-round(nAccepted/3)+1:end));
   
end

ampls_small
ampls_large