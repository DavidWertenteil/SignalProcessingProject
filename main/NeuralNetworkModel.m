% Neural Network Classifier
% =========================
% Classification through Neural networks
%% Train Neural Network using computed features on all buffers
% Load pre-computed features for all signal buffers available at once
load('features_fallRemoved.mat')
% Load buffered signals (here only using known activity IDs for buffers)
load('formatedData_fallRemoved.mat')
% Correct data orientation
load('finalNN__fallRemoved')
%% Divide all data to train and test 
[trainInd,testInd] = dividerand(size(feat,1),0.7,0.3);

% Correct data orientation
X = feat';
y = y';
%%
Xtrain = X(:,trainInd);
ytrain = y(:,trainInd);
tgtTrain = dummyvar(ytrain)';

% Reset random number generators
rng default

% Initialize a Neural Network with 18 nodes in hidden layer
net = patternnet(18);

% Train network
net = train(net, Xtrain, tgtTrain);
%%
% Test network
Xtest = X(:,testInd);
ytest = y(:,testInd);
tgttest = dummyvar(ytest)';

% Run network on validation set
scoretest = net(Xtest);

% Display confusion matrix using results
[confusionValue, confMat, ind, per] = confusion(tgttest,scoretest);

figure
plotconfusion(tgttest,scoretest)

save('.\trainedModelsData\finalNN_4_acty.mat','net','actnames');
%% Improve:
% https://www.mathworks.com/help/nnet/ug/improve-neural-network-generalization-and-avoid-overfitting.html
