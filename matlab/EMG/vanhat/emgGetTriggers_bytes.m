function trigPos = emgGetTriggers(trigfile)

%trigPos = emgGetTriggers(trigfile)
%
%trigPos - trigger positions in bytes
%trigfile - file containing the trigger channel data

[fid,message]=fopen(trigfile,'rt');
if fid == -1
    display('The file cannot be opened')
    display(message)
end

%numChannels = 1;
blockSamples = 200000;                      %One block consists of 100 seconds of data (100 sec * 20000 1/sec)
trigGradThreshold = 80000;
%trigThreshold = 80000;

fseek(fid,0,'eof');                         %repositions the position indicator to the end of the file
numBytes = ftell(fid);                      %tells the number of bytes in the file
numSamples = (numBytes/2);                  %number of samples in the file
numBlocks = ceil(numSamples/blockSamples);  %divides the file into blocks of 14500 samples (10 seconds, 1450 samples/sec)

fseek(fid,0,'bof');
trigPos=[];

%Reads the whole emg file - not possible if the file is too large!
%wholedata = fscanf(fid,'%f',1253915);
%figure
%plot(wholedata)

fseek(fid,0,'bof');

for i = 1:numBlocks
    fPos = ftell(fid);
    data = fscanf(fid,'%f',blockSamples+1);
    [n,m] = size(data);
%    find(diff(data)>trigGradThreshold)
%    trigPos = [trigPos,intersect(find(diff(data(1,:))>trigGradThreshold),find(data(1,:)>trigThreshold)).*2+fPos];
        
    trigPos = [trigPos, (find(diff(data)>trigGradThreshold))'.*2+fPos];

%    trigPos = [trigPos, (find(diff(data)>trigGradThreshold)+fPos)'];
%    trigPos = [trigPos, find(data(1,:)>trigThreshold).*2+fPos];
%    figure
%    plot(data,'o-')
    fseek(fid,-2,'cof'); 
    if n < blockSamples+1
        break
    end
end

fclose(fid);
