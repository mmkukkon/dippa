function trigPos = emgGetTriggers(trigfile)

%trigPos = emgGetTriggers(trigfile)
%
%trigPos - row numbers in the text file containing triggers
%trigfile - file containing the trigger channel data

[fid,message]=fopen(trigfile,'rt');
if fid == -1
    display('The file cannot be opened')
    display(message)
end

%trigGradThreshold = 80000; %Trigger from presentation
%trigGradThreshold = 60000;  %Trigger from Nexstim TMS device
trigGradThreshold = 81000;

numSamples = file_row_count(trigfile);
blockSamples = 200000;                      %One block consists of 100 seconds of data (100 sec * 20000 1/sec)
numBlocks = ceil(numSamples/blockSamples);

trigPos=[];

for i=1:numBlocks
    if i<numBlocks
        rowBegin = (i-1)*blockSamples;
        rowEnd = i*blockSamples;
        data = csvread(trigfile,rowBegin,0,[rowBegin 0 rowEnd 0]);
    else
        nDatapointsLeft = numSamples - (numBlocks-1)*blockSamples;
        rowBegin = (i-1)*blockSamples;
        rowEnd = (i-1)*blockSamples+nDatapointsLeft-1;
        data = csvread(trigfile,rowBegin,0,[rowBegin 0 rowEnd 0]);
    end
    trigPos = [trigPos, (find(diff(data)>trigGradThreshold))'+(i-1)*blockSamples-1];
end    


%for i = 1:numBlocks
%    fPos = ftell(fid);
%    data = fscanf(fid,'%f',blockSamples+1);
%    [n,m] = size(data);
%    find(diff(data)>trigGradThreshold)
%    trigPos = [trigPos,intersect(find(diff(data(1,:))>trigGradThreshold),find(data(1,:)>trigThreshold)).*2+fPos];
        
%    trigPos = [trigPos, (find(diff(data)>trigGradThreshold))'.*2+fPos];

%    trigPos = [trigPos, (find(diff(data)>trigGradThreshold)+fPos)'];
%    trigPos = [trigPos, find(data(1,:)>trigThreshold).*2+fPos];
%    figure
%    plot(data,'o-')
%    fseek(fid,-2,'cof'); 
%    if n < blockSamples+1
%        break
%    end
%end

fclose('all');