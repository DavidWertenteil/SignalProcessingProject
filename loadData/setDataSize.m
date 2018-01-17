
%%
testSize = 0.8;
load('formatedData_3_acty.mat');
h = histogram(y);
minNumOfRecords = min(h.Values);
minNumOfRecords = int16(minNumOfRecords * testSize);
numOfRecords = h.Values;
tempNumOfRecords = zeros(1, length(numOfRecords));
%%
placeToBegin = zeros(1, length(numOfRecords));
last = 0;
for i = 1: length(numOfRecords)
    placeToBegin(1, i) = 1 + last;
    last = last + numOfRecords(i);
end

acts = zeros(length(atx), line * 3);
%%
% Insert all database to the matrix
for i = 1 : length(y)
    acts(placeToBegin(1, y(i)) + tempNumOfRecords(1, y(i)), :) = ...
        insertToActs(atx, aty, atz, line, i);
    tempNumOfRecords(1, y(i)) = tempNumOfRecords(1, y(i)) + 1;
end
%%
% To remove https://www.mathworks.com/help/nnet/ref/removerows.html
% randperm(minNumnumOfRecords,size(ac1Atx,1))

numOfActsForTest = minNumOfRecords * length(numOfRecords);
train_atx = zeros(numOfActsForTest, line);
train_aty = zeros(numOfActsForTest, line);
train_atz = zeros(numOfActsForTest, line);
trainTarget = zeros(numOfActsForTest, 1);

cellsOfTest = zeros(length(numOfRecords), minNumOfRecords);

for i = 1 : length(numOfRecords)
    begin = 1 + (minNumOfRecords * (i-1));
    finish = minNumOfRecords * i;
    cellsOfTest(i , :) = ...
            randperm(numOfRecords(1,i) - 1, minNumOfRecords) + 1;
    
    [train_atx(begin: finish, :), train_aty(begin: finish, :),train_atz(begin: finish, :)]...
        = insertToTrainSet(acts(placeToBegin(1, i): placeToBegin(1, i) + numOfRecords(i) - 1,:)...
        , cellsOfTest(i, :), line);
    
    trainTarget(begin : finish) = i;
end

deleteFromMatrix = zeros(1, length(numOfRecords) * minNumOfRecords);
k = 1;
for i = 1 :length(numOfRecords)
    for j = 1 : length(cellsOfTest(1, :))
        deleteFromMatrix(1, k) = cellsOfTest(i, j) + placeToBegin(1, i) - 1;
        k = k + 1;
    end
end
[acts, ps] = removerows(acts,'ind',deleteFromMatrix(1, :));

numForTest = length(acts);

test_atx = zeros(numForTest, line);
test_aty = zeros(numForTest, line);
test_atz = zeros(numForTest, line);
testTarget = zeros(numForTest, 1);

numOfEachForTes = zeros(1 , length(numOfRecords));
for i = 1:length(numOfRecords)
    numOfEachForTes(1, i) = numOfRecords(i) - minNumOfRecords;
end
k = 1; l = 1;
for i = 1 : length(acts(:,1))
    test_atx(i, :) = acts(i, 1: line);
    test_aty(i, :) = acts(i, line + 1: line*2);
    test_atz(i, :) = acts(i, line*2 + 1: line*3);
    if (numOfEachForTes(k) < l)
        l = 1;
        k = k + 1;
    end
    testTarget(i, 1) = k;
    l = l + 1; 
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function at_x_y_z = insertToActs(atx, aty, atz, lineSize, index)
    at_x_y_z = zeros(1, lineSize * 3);
    at_x_y_z(1, 1:lineSize) = atx(index,:);
    at_x_y_z(1, lineSize+1:lineSize*2) = aty(index,:);
    at_x_y_z(1, lineSize*2+1:lineSize*3) = atz(index,:); 
end

function [X, Y, Z] = insertToTrainSet(M, cells, lineSize)
    
    X = zeros(length(cells), lineSize);
    Y = zeros(length(cells), lineSize);
    Z = zeros(length(cells), lineSize);
    for i = 1: length(cells)
        X(i, :) = M(i, 1: lineSize);
        Y(i, :) = M(i, lineSize+1: lineSize*2);
        Z(i, :) = M(i, lineSize*2+1: lineSize*3);
    end
end