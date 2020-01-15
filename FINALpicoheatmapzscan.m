file = input('What is the file name? ','s');

ext = '.csv';
filename = strcat(file,ext);

% Collects from the file 'filename' skipping 3 rows and 1 column.
data = abs(csvread(filename, 3, 1));

% Asks to input the sensitivity, multipler, width, and height.
sensexp = input('What is the sensitivity exponent [-3]? ');
if isempty(sensexp)
    sensexp = -3;
end
sens = 10^(sensexp);
mult = input('What is the multiplier [1]? ');
if isempty(mult)
    mult = 1;
end
width = input('What is the width of the box [1]? ');
if isempty(width)
    width = 1;
end
height = input('What is the height of the box [1]? ');
if isempty(height)
    height = 1;
end

% The numbers in 2nd column <6 and >6 are replaced with 0 and 12, respectively.
data(data(:,2) < 6, 2) = 0;
data(data(:,2) > 6, 2) = 12;

% Have matrix "grp" that replaces 0 with 1 and 12 with 2
[~, ~, grp] = unique(data(:,2), 'rows');

% Every number in 'blocks' is how long the rows are 1 or 2
blocks=diff([0;find(diff([grp;0]))])';

% Render cell array in which ON(1)s and OFF(2)s are separated
array=mat2cell(data, blocks, [2]);

% If the second column in the array has 12s, then we want to delete.

% New array for only when the laser is on.
ONarray = array;
for i = 1:length(array)
    if array{i}(:,2) ~= zeros (length(array{i}),1) %if second column in array does NOT =0
        ONarray{i} = [];
    end
end

% Empty cells are deleted
ONarrayonly = ONarray(~cellfun('isempty',ONarray));

% How to find thresholds of how long 'blocks' are
len = cellfun('length', ONarrayonly);

% Obtain 40 lengths of when laser is on. Delete if they are 'too short'
samplelen = len(5:46,:);
for i = 1:40;
    if samplelen(i) < min(samplelen(1:2,:)*0.1);
        samplelen (i) = [];
    end
end

% Rows split to every other so they can represent whole scans or edges.
scanORedge = samplelen(1:2:end,:);
edgeORscan = samplelen(2:2:end,:);

% Now let the longer lengths be 'scan' and shorter be 'edge'
if mean(scanORedge)>mean(edgeORscan)
    scan = scanORedge;
    edge = edgeORscan;
else scan = edgeORscan;
    edge = scanORedge;
end

% Get average of every other row and let be FScan, other is BScan
AvgFScan = mean(scan(1:2:end,:));
AvgBScan = mean(scan(2:2:end,:));

% You find difference between F/Bscan and let be how much lengths vary
Var = abs(AvgFScan-AvgBScan);

if Var>10
    disp('Image may not be accurate.')
end

if 3<Var<10
else disp('Image may not be accurate.')
end
    

% Use averages to find threshold
Thresh = (AvgFScan+AvgBScan)/2;

UpThresh = Thresh+Var;
LwThresh = Thresh-Var;

% Remove cells with lengths not within thresholds
ONarraysimple = ONarrayonly;
for i = 1:length(ONarrayonly)
    if length(ONarrayonly{i})>UpThresh
        ONarraysimple{i} = [];
    end
    if length(ONarrayonly{i})<LwThresh
        ONarraysimple{i} = [];
    end
end

% Empty cells that have nothing in them
ONarrayscan = ONarraysimple(~cellfun('isempty',ONarraysimple));
ONdata = [];

% Is only first column
for i = 1:length(ONarrayscan)
    ONdata{i} = ONarrayscan{i}(:,1);
end
map = zeros(max(cellfun('length', ONdata)),length(ONdata));
for i = 1:length(ONdata)
    map(1:length(ONdata{i}),i) = ONdata{i};
end

%for i = 2:round(size(map,2)*0.90);
    %if mean(map(:,i))<0.9*mean(map(:,i+1)) &&  mean(map(:,i))<0.9*mean(map(:,i-1));
        %map(:,i) = [];
    %end
%end

% Because z-scan, flip every other line
map(:,1:2:end) = flip(map(:,1:2:end));

% Every other line needs to be shifted because of z-scan. Find shifts.
map1 = map(:,1:2:end);
map2 = map(:,2:2:end);
avg1 = mean(find(mean(map1,2)>mean(mean(map1,2))));
avg2 = mean(find(mean(map2,2)>mean(mean(map2,2))));
shift = round(abs(avg1-avg2));

% Now shift every other line down by diff in averages of beginning of lines
if avg1>avg2
    map(:,2:2:end) = circshift(map(:,2:2:end), [shift, 0]);
    else map(:,1:2:end) = circshift(map(:,1:2:end), [shift, 0]);
end

rM = map;

% Next with preamp settings to get colorscale right
M = rot90(rM*sens*mult*10^3);

% Equate Max to either the maximum or the answer to "Autoscale" question
Max = input('Autoscale (Y/max(mA)) [Y]? ');
if isempty (Max);
  Max = max(max(M));
end

% To make the title of the figure.
name = input('What cell is this? ', 's');
cellwidth = input('What is the cell width (mm)? ', 's');
cellheight = input('What is the cell height (mm)? ', 's');

% To make contourmap
[C,h] = contourf(M, length(unique(M)));
caxis([0 Max]);
colormap parula;
h.LineColor = 'none';
ax = gca;
ax.XTick = ([]);
ax.YTick = ([]);

% Putting in colorbar and its settings.
c = colorbar;
c.Label.String = 'Current (mA)';
c.Label.FontSize = 12;
c.Ticks = sort([0:sens*mult*10^3:Max, max(max(M))]);
c.Limits = [0, Max];
daspect([height*10^6/size(M,1) width*10^6/size(M,2) 1])
fig = gcf;

% Letting the title be based on earlier inputs.
title(strcat(name ,' (',cellwidth,'mm','X',cellheight,'mm)'));
fig.PaperUnits = 'inches';

print(file,'-dpng','-r600')