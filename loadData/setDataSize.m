
%%
load('formatedData_4_acty.mat');
h = histogram(y);
minNumnumOfRecords = min(h.Values);

line = 128;

ac1Atx = zeros(size(atx,1), line);
ac1Aty = zeros(size(atx,1), line);
ac1Atz = zeros(size(atx,1), line);

ac2Atx = zeros(size(atx,1), line);
ac2Aty = zeros(size(atx,1), line);
ac2Atz = zeros(size(atx,1), line);

ac3Atx = zeros(size(atx,1), line);
ac3Aty = zeros(size(atx,1), line);
ac3Atz = zeros(size(atx,1), line);

ac4Atx = zeros(size(atx,1), line);
ac4Aty = zeros(size(atx,1), line);
ac4Atz = zeros(size(atx,1), line);

for index = 1 : length(atx)
    if (y(index) == 1)
        [ac1Atx(index, :), ac1Aty(index, :),ac1Atz(index, :)] = copy(index, atx, aty, atz);
    elseif (y(index) == 2)
        [ac2Atx(index, :), ac2Aty(index, :),ac2Atz(index, :)] = copy(index, atx, aty, atz);
    elseif (y(index) == 3)
        [ac3Atx(index, :), ac3Aty(index, :),ac3Atz(index, :)] = copy(index, atx, aty, atz);
    else
        [ac4Atx(index, :), ac4Aty(index, :),ac4Atz(index, :)] = copy(index, atx, aty, atz);
    end
end
%%
% To remove https://www.mathworks.com/help/nnet/ref/removerows.html
% randperm(minNumnumOfRecords,size(ac1Atx,1))
acts = [ac1Atx, ac2Atx, ac3Atx, ac4Atx];
numOfActsForTest = minNumnumOfRecords * length(actnames);
test_atx = zeros(numOfActsForTest, line);

for index = 1: length(actnames)
    test_atx = 
end
%%
function [x, y, z] = copy(ind, atx, aty, atz)
    x = atx(ind,:);
    y = aty(ind,:);
    z = atz(ind,:); 
end
%%
function [X, Y, Z] = insert(acts, index)
    ran = randperm(minNumnumOfRecords,size(acts(index),1));
    s = index * numOfActsForTest;
    test_atx(s:s + numOfActsForTest) = acts(index, ran, :);
end