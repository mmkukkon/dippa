function [average,timeAxis,numTrials] = emgAverage(filename,triggerPositions,timeRange,baselineRange) 

%function [average,timeAxis,numTrials] = emgAverage(filename,triggerPositions,timeRange,baselineRange) 
%
%average - average data vector
%timeAxis - time axis in milliseconds
%numTrials - number of trials averaged
%filename - data file
%triggerPositions - trigger positions in rows
%timeRange - in milliseconds e.g. [-300 1500]
%baselineRange - in milliseconds e.g. [-300 0]

fs = 20;    %kHz, sample frequency

[data,timeAxis] = emgGetTrial(filename,triggerPositions(1),timeRange,baselineRange);
average = data;
numTrials = 1;

for i=2:length(triggerPositions),
    [data,timeAxis] = emgGetTrial(filename,triggerPositions(i),timeRange,baselineRange);
    if length(data)==length(average), 
        average = average + data;
        numTrials = numTrials + 1;
    end
end

average = average./numTrials;
timeAxis = (0:length(average)-1)/fs+timeRange(1);
disp(['Averaged trials ' int2str(numTrials)]);