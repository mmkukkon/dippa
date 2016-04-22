function [data,timeAxis] = emgGetTrial(filename,filePosition,timeRange,baselineRange)

%function [data,timeAxis] = emgGetTrial(filename,filePosition,timeRange,baselineRange)
%
%data - data vector
%timeAxis - time axis in ms
%filename - data file
%filePosition - in bytes
%timeRange - in milliseconds e.g. [-100 500]
%baselineRange - in milliseconds e.g. [-100 0]

if nargin<4,end          		

%numChannels = 1;
timeSf = 20;
tRange = round(timeRange.*timeSf);          % -2000 -- 10000 datapoints
bLine = round(baselineRange.*timeSf);       % -2000 -- 0 datapoints
duration = diff(tRange)+1;                  % 12001 datapoints

fid = fopen(filename,'rt');     		 
fseek(fid,filePosition+2*tRange(1),'bof');
%data = fread(fid,[numChannels duration],'short'); 			   
data = fscanf(fid,'%f',duration);
fclose(fid);

%Baseline correction: 
blStart = diff([tRange(1) bLine(1)])+1;
blStop = diff([tRange(1) bLine(2)])+1;
data = data-mean(data(blStart:blStop)); 

timeAxis = ((0:length(data)-1)+tRange(1))/timeSf;