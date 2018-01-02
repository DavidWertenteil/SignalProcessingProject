% Neural Network Classifier
% =========================
% Classification through Neural networks
%% Train Neural Network using computed features on all buffers
% Load pre-computed features for all signal buffers available at once
load('features_fallRemoved.mat')
% Load buffered signals (here only using known activity IDs for buffers)
load('formatedData_fallRemoved.mat')
% Correct data orientation

% Divide all data to train and test 
[trainInd,testInd] = dividerand(size(feat,1),0.7,0.3);

% Correct data orientation
X = feat';
y = y';

Xtrain = X(:,trainInd);
ytrain = y(:,trainInd);
tgtTrain = dummyvar(ytrain)';

% Reset random number generators
rng default

% Initialize a Neural Network with 18 nodes in hidden layer
net = patternnet(18);

% Train network
net = train(net, Xtrain, tgtTrain);

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

save('..\trainedModelsData\finalNN__fallRemoved.mat','net','actnames');
%%
% First test
ntests = 1000;
idx = 1000+1*(0:ntests-1)+1;

for k = 1:ntests
    % Get data buffer
    ax = atx(idx(k),:);
    ay = aty(idx(k),:);
    az = atz(idx(k),:);
    
    % Plot 3 acceleration components
    plotAccelerationBuffer(ax,ay,az,t)
    
    % Extract features
    f = featuresFromBuffer(ax, ay, az, fs);
    
    % Classify with neural network
    scores = net(f');
    % Extract result
    [~, maxidx] = max(scores);
    % Display result as title in current plot 
    estimatedActivity = actnames{maxidx};
    % Look up actual activity
    actualActivity = actnames{y(idx(k))};
    
    % Overlay classification results as plot title
    title(sprintf('Estimated: %s\nActually: %s\n', ...
        estimatedActivity,actualActivity))
    drawnow
end

% Save traind network
save('..\trainedModelsData\trainedNueralNetwork.mat','net','actnames');

