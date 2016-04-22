clear;
close all;
%A script for reading the data, calculating the
%Calculate correlation between ADM and APB muscle responses


%-------------------------------------------------------

skipTrigAcceptReject = 'on';
skipAcceptReject = 'on';
n_measurements = 8; %n_subjects (MEP05b ei hyv�� sessiota sek� ADM:lle ett� APB:lle, MEP06, no APB responses/noisy data, MEP10: 2 APB responses)
noResponses = 'skip'; %'skip' = mark as rejected, 'zero' = set amplitude as 0, 'accept' = use the amplitude of the noise

%-------------------------------------------------------


correl = zeros(1,n_measurements);
p_corr = zeros(1,n_measurements);


for meas_i = 1:n_measurements

        strArray = java_array('java.lang.String', n_measurements);
        strArray(1) = java.lang.String('MEP03b'); %Best subjects
        strArray(2) = java.lang.String('MEP14');
        strArray(3) = java.lang.String('MEP04');  %Other subjects
        strArray(4) = java.lang.String('MEP08');
        strArray(5) = java.lang.String('MEP09');
        strArray(6) = java.lang.String('MEP11');
        strArray(7) = java.lang.String('MEP13');
        strArray(8) = java.lang.String('AM02');
    measArray = cell(strArray);
    clear strArray;
    experiment = measArray{meas_i}


    if strcmp(experiment(1),'M')
        dir = ['E:\MEP sorting\',experiment,'\'];
    elseif strcmp(experiment(1),'A')
        dir = ['E:\Auditory masking\',experiment,'\'];
    end
    input_dir = [dir,'EEG\'];
    output_dir = [dir,'EEG_kasitelty\'];
    emgdir = [dir,'EMG_kasitelty\'];


    if strcmp(experiment,'MEP03b')
        output_number = '4';
        input_file = [input_dir,'20071210_093038_tuomas_t�lli_',num2str(output_number),'.nxe'];
    elseif strcmp(experiment,'MEP04')
        output_number = '1';
        input_file = [input_dir,'20071128_093942_jaakko_nieminen_jn_',num2str(output_number),'.nxe'];
    elseif strcmp(experiment,'MEP07')
        output_number = '3';
        input_file = [input_dir,'20071217_093107_frans_vinberg_',num2str(output_number),'.nxe'];
    elseif strcmp(experiment,'MEP08')
        output_number = '2';
        input_file = [input_dir,'20080212_122205_johanna_metsomaa_',num2str(output_number),'.nxe'];
    elseif strcmp(experiment,'MEP09')
        output_number = '1';
        input_file = [input_dir,'20080215_094752_mikko_lilja_',num2str(output_number),'.nxe'];
    elseif strcmp(experiment,'MEP11')
        output_number = '3';
        input_file = [input_dir,'20080220_115320_tommi_ekholm_',num2str(output_number),'.nxe'];
    elseif strcmp(experiment,'MEP13')
        output_number = '1';
        input_file = [input_dir,'20080226_113336_yrj�_h�me_masking',num2str(output_number),'.nxe'];
    elseif strcmp(experiment,'MEP14')
        output_number = '3';
        input_file = [input_dir,'20080227_095110_lauri_lipi�inen_masking',num2str(output_number),'.nxe'];
    elseif strcmp(experiment,'AM02')
        output_number = '0n';
        input_file = [input_dir,'20070910_091757_hanna_maki_',num2str(output_number),'.nxe'];
    end
    nSessions = 1;



    %-------------------------------------------------------

    trig_channel = 1;   % 1=gate, 2=trig1, 3=trig2
    plotLimits = [-20 20];


    before = 1000;
    after = 0;
    fs = 1.45;  %1/ms
    % downsamplingFactor = 1;
    nChans = 60;
    nTimepoints = round((before + after + 1)*fs);
    ylimits = [-10 10];


    %-------Load EMG responses: 
    amplitudes_new = [];
    acceptedEmg_new = [];
    output_muscle = 'ADM';
    output_name = [output_number,'_',output_muscle];
    output_name1 = output_name;
    for i=1:nSessions
        eval(['load([emgdir,''amplitudes_'',output_name',num2str(i),',''.mat'']);']);
        eval(['load([emgdir,''acceptedEmg_'',output_name',num2str(i),',''.mat'']);']);
        amplitudes_new = [amplitudes_new; amplitudes'];
        acceptedEmg_new = [acceptedEmg_new; emgAccepted'];
    end
    amplitudes_ADM = amplitudes_new;
    emgAccepted_ADM = acceptedEmg_new;
    clear amplitudes_new acceptedEmg_new;
    nEmgTrials_ADM = length(amplitudes);
    
    if strcmp(noResponses,'skip') || strcmp(noResponses,'zero')
        load([emgdir,'emgResponseOrNot_',output_name,'.mat']);
        emgResponseOrNot_ADM = emgResponseOrNot;
    end
    
    amplitudes_new = [];
    acceptedEmg_new = [];
    output_muscle = 'APB';
    output_name = [output_number,'_',output_muscle];
    output_name1 = output_name;
    for i=1:nSessions
        eval(['load([emgdir,''amplitudes_'',output_name',num2str(i),',''.mat'']);']);
        eval(['load([emgdir,''acceptedEmg_'',output_name',num2str(i),',''.mat'']);']);
        amplitudes_new = [amplitudes_new; amplitudes'];
        acceptedEmg_new = [acceptedEmg_new; emgAccepted'];
    end
    amplitudes_APB = amplitudes_new;
    emgAccepted_APB = acceptedEmg_new;
    clear amplitudes_new acceptedEmg_new;
    nEmgTrials_APB = length(amplitudes);
    
    if strcmp(noResponses,'skip') || strcmp(noResponses,'zero')
        load([emgdir,'emgResponseOrNot_',output_name,'.mat']);
        emgResponseOrNot_APB = emgResponseOrNot;
    end

    output_number = {output_number};

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
            eval([varname_acceptedTrigPositions '= nxeSelectTrials(input_file',num2str(i),',trig_channel,''rising'',[-100 500],[-100 0],[4:64],30);']);
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

    if nEmgTrials_ADM~=nEegTrials || nEmgTrials_APB~=nEegTrials
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
    acceptedEegEmg = acceptedEeg.*emgAccepted_APB.*emgAccepted_ADM;
    if strcmp(noResponses,'skip')
        acceptedEegEmg = acceptedEegEmg .* emgResponseOrNot_APB' .* emgResponseOrNot_ADM';
    end
    nAccepted = sum(acceptedEegEmg)

    if strcmp(noResponses,'zero')
        for ind = 1:length(amplitudes_ADM)
            if ~emgResponseOrNot_ADM(ind)
                amplitudes_ADM(ind) = 0;
            end
            if ~emgResponseOrNot_APB(ind)
                amplitudes_APB(ind) = 0;
            end
        end
    end
    
    %Remove rejected trials:
    amplitudes_ADM = amplitudes_ADM(find(acceptedEegEmg));
    amplitudes_APB = amplitudes_APB(find(acceptedEegEmg));

    %Sort amplitudes:
    [sortedAmplitudes_ADM,sortIndex_ADM] = sort(amplitudes_ADM);
    [sortedAmplitudes_APB,sortIndex_APB] = sort(amplitudes_APB);
   
    figure
    plot(sortedAmplitudes_ADM,'o')
    hold on
    plot(sortedAmplitudes_APB,'oc')
    plot([1 length(sortedAmplitudes_ADM)],[50 50],'g')
    title(experiment)
    xlabel('Trial # (sorted)')
    ylabel('MEP amplitude (\muV)')
    
    [correl(meas_i), p_corr(meas_i)] = corr(amplitudes_ADM,amplitudes_APB,'type','Spearman');
    disp([experiment,': CorrCoeff = ',num2str(correl(meas_i)),', pValue = ',num2str(p_corr(meas_i))]);
    
    rank_ADM = zeros(1,length(amplitudes_ADM));
    for ind=1:length(sortIndex_ADM)
        rank_ADM(ind) = find(sortIndex_ADM==ind);
    end
    for ind=1:length(sortIndex_ADM)
        sameAmplInd = find(amplitudes_ADM == amplitudes_ADM(ind));
        if length(sameAmplInd) > 1
            rank_ADM(sameAmplInd) = mean(rank_ADM(sameAmplInd));
        end
    end
    
    rank_APB = zeros(1,length(amplitudes_APB));
    for ind=1:length(sortIndex_APB)
        rank_APB(ind) = find(sortIndex_APB==ind);
    end
    for ind=1:length(sortIndex_APB)
        sameAmplInd = find(amplitudes_APB == amplitudes_APB(ind));
        if length(sameAmplInd) > 1
            rank_APB(sameAmplInd) = mean(rank_APB(sameAmplInd));
        end
    end

    
    p = polyfit(rank_ADM,rank_APB,1);
    f = polyval(p,rank_ADM);
    
    figure
    varname_figh = genvarname('figh', who);
    eval([varname_figh ' = area([1 round(length(rank_ADM)/3)],[max(rank_APB) max(rank_APB)]);']);
    eval(['set(',varname_figh,',''FaceColor'',[0.7 1 1])']);
    hold on
    eval([varname_figh ' = area([length(rank_ADM)-round(length(rank_ADM)/3)+1 length(rank_ADM)],[max(rank_APB) max(rank_APB)]);']);
    eval(['set(',varname_figh,',''FaceColor'',[1 0.7 1])']);
    xlim([min(rank_ADM) max(rank_ADM)])
    plot(rank_ADM,rank_APB,'o')
    plot(rank_ADM,f,'r')
    title(experiment)
    xlabel('ADM rank')
    ylabel('APB rank')
   

end