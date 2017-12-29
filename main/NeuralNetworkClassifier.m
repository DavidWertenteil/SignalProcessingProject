% Neural Network Classifier
% =========================
% Classification through Neural networks
%% Train Neural Network using computed features on all buffers
% Load pre-computed features for all signal buffers available at once
load('features.mat')
% Load buffered signals (here only using known activity IDs for buffers)
load('formatedData.mat')
% Correct data orientation
X = feat';
y = y';
tgt = dummyvar(y)';
% Reset random number generators
rng default

% Initialize a Neural Network with 18 nodes in hidden layer
net = patternnet(18);

% Train network
net = train(net, X, tgt);

%% Validate network more systematically, by selecting a test subset

% Randomly divide data between training, test and validation sets
[trainInd,valInd,testInd] = dividerand(size(X,2),0.7,0.15,0.15);

Xtest = X(:,testInd);
ytest = y(:,testInd);
tgttest = dummyvar(ytest)';

% Run network on validation set
scoretest = net(Xtest);

% Display confusion matrix using results
figure
plotconfusion(tgttest,scoretest)

save('.\trainedModelsData\test_NN_Validation.mat','net','actnames');
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

