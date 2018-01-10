
%%
testSize = 0.8;
load('formatedData_4_acty.mat');
h = histogram(y);
minNumnumOfRecords = min(h.Values);
minNumnumOfRecords = int16(minNumnumOfRecords * testSize);
numOfRecords = h.Values;
tempNumnumOfRecords = zeros(1, length(numOfRecords));
%%
placeToBegin = zeros(1, length(numOfRecords));
last = 0;
for i = 1: length(numOfRecords)
    placeToBegin(1, i) = 1 + last;
    last = last + numOfRecords(i);
end
    line = 128;

ac1Atx = zeros(numOfRecords(1), line);
ac1Aty = zeros(numOfRecords(1), line);
ac1Atz = zeros(numOfRecords(1), line);

ac2Atx = zeros(numOfRecords(2), line);
ac2Aty = zeros(numOfRecords(2), line);
ac2Atz = zeros(numOfRecords(2), line);

ac3Atx = zeros(numOfRecords(3), line);
ac3Aty = zeros(numOfRecords(3), line);
ac3Atz = zeros(numOfRecords(3), line);

ac4Atx = zeros(numOfRecords(4), line);
ac4Aty = zeros(numOfRecords(4), line);
ac4Atz = zeros(numOfRecords(4), line);

acts = [ac1Atx, ac1Aty, ac1Atz;...
        ac2Atx, ac2Aty, ac2Atz;...
        ac3Atx, ac3Aty, ac3Atz;...
        ac4Atx, ac4Aty, ac4Atz];
%%
% Insert all database to the matrix
for i = 1 : length(y)
    acts(placeToBegin(1, y(i)) + tempNumnumOfRecords(1, y(i)), :) = ...
        insertToActs(atx, aty, atz, line, i);
    tempNumnumOfRecords(1, y(i)) = tempNumnumOfRecords(1, y(i)) + 1;
end
%%
% To remove https://www.mathworks.com/help/nnet/ref/removerows.html
% randperm(minNumnumOfRecords,size(ac1Atx,1))

numOfActsForTest = minNumnumOfRecords * length(numOfRecords);
train_atx = zeros(numOfActsForTest, line);
train_aty = zeros(numOfActsForTest, line);
train_atz = zeros(numOfActsForTest, line);
train_tgt = zeros(numOfActsForTest, 1);

cellsOfTest = zeros(length(numOfRecords), minNumnumOfRecords);

for i = 1 : length(numOfRecords)
    
    begin = 1 + (minNumnumOfRecords * (i-1));
    finish = minNumnumOfRecords * i;
    cellsOfTest(i , :) = ...
            randperm(numOfRecords(1,i) - 1, minNumnumOfRecords) + 1;
    
    [train_atx(begin: finish, :), train_aty(begin: finish, :),train_atz(begin: finish, :)]...
        = insertToTrainSet(acts(placeToBegin(1, i): placeToBegin(1, i) + numOfRecords(i) - 1,:)...
        , cellsOfTest(i, :), line);
    
    train_tgt(placeToBegin(1, i) : numOfRecords(i)) = i;
end

for i = 1 :length(numOfRecords)
    for j = 1 : length(cellsOfTest(1, :))
        cellsOfTest(i, j) = cellsOfTest(i, j) + placeToBegin(1, i) - 1;
    end
    [acts, ps] = removerows(acts,'ind',cellsOfTest(i, :));
end

numForTest = -(minNumnumOfRecords * length(numOfRecords));
for i = 0: length(numOfRecords)
    numForTest = numForTest + numOfRecords(i);
end

test_atx = zeros(numForTest, line);
test_aty = zeros(numForTest, line);
test_atz = zeros(numForTest, line);
test_tgt = zeros(numForTest, 1);

for i = 1 : length(acts(:,1))
    test_atx(i, :) = acts(i, 1: line);
    test_atx(i, :) = acts(i, line + 1: line*2);
    test_atx(i, :) = acts(i, line*2 + 1: line*3);
    for j = 1: length(numOfRecords)
        if (numOfRecords(j) - (minNumnumOfRecords * j) > i)
            break;
        end
    end
    test_tgt(i, 1) = j;
    
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