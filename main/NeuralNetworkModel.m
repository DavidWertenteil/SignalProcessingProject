% Neural Network Classifier
% =========================
% Classification through Neural networks
%% Train Neural Network using computed features on all buffers
% Load pre-computed features for all signal buffers available at once
load('features_3_acty.mat')

% Correct data orientation
%load('finalNN__fallRemoved')
%%
% Correct data orientation
Xtrain = featTrain';
ytrain = trainTarget';
tgtTrain = dummyvar(ytrain)';

% Reset random number generators
rng default

% Initialize a Neural Network with 18 nodes in hidden layer
net = patternnet([66, 18, 66]);

% Train network
net = train(net, Xtrain, tgtTrain);
%%
% Test network
Xtest = featTest';
ytest = testTarget';
tgttest = dummyvar(ytest)';

% Run network on validation set
scoretest = net(Xtest);

% Display confusion matrix using results
% [confusionValue, confMat, ind, per] = confusion(tgttest,scoretest);
% 
% figure
% plotconfusion(tgttest, scoretest)

mA = ?ActivityLabels;
actnames = {mA.EnumerationMemberList(:).Name};
save('.\trainedModelsData\finalNN_3_acty.mat','net','actnames');
%%
% load('finalNN_4_acty.mat');
% 
% load('dividedFormatedData_4_acty.mat');
% 
% ntests = 1000;
% idx = 1000+1*(0:ntests-1)+1;
% sam_num=size(test_atx);
% for k = 1:sam_num(1)%ntests
%     % Get data buffer
%     ax = test_atx(k,:);
%     ay = test_aty(k,:);
%     az = test_atz(k,:);
%     
%     % Plot 3 acceleration components
%     plotAccelerationBuffer(ax,ay,az,t)
%     
%     % Extract features
%     f = featuresFromBuffer(ax,ay,az, fs);
%     
%     % Classify with neural network
%     scores = net(f');
%     % Extract result
%     [~, maxidx] = max(scores);
%     % Display result as title in current plot 
%     estimatedActivity = actnames{maxidx};
%     % Look up actual activity
%     actualActivity = actnames{testTarget(k)};
%     
%     % Overlay classification results as plot title
%     title(sprintf('Estimated: %s\nActually: %s\n', ...
%         estimatedActivity,actualActivity))
%     drawnow
%     pause(0.02)
% end
clear;
%% Improve:
% https://www.mathworks.com/help/nnet/ug/improve-neural-network-generalization-and-avoid-overfitting.html
