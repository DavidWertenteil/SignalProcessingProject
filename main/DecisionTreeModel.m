%% ------------------------- Random Forest ---------------------------------------
%
% https://www.mathworks.com/help/stats/treebagger.html
% http://kawahara.ca/matlab-treebagger-example/
% -------------------------------------------------------------------------
% Load features
load('features.mat')

Xtrain = featTest;
Ytrain = testTarget;
 
Xtest = featTrain;
tgtTest = trainTarget;

% -------------------------------------------------------------------------
rng default
numberOfTrees = 50;

% Run random forest model
randomForest = TreeBagger(numberOfTrees, Xtrain, Ytrain,...
    'OOBPrediction','on','Method', 'classification');

% Save the final module
save('..\activityDetection.mat','randomForest');

% Predict confusion matrix
pred = randomForest.predict(Xtest);
pred = str2double(pred);
[matrix, target] = confusionmat(tgtTest,pred);

% Display the confusion matrix
matrix
