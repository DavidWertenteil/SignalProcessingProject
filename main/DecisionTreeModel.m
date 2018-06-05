
% Decision Tree Model
%%
load('features_3_acty.mat')

%%

Xtrain = featTest;
Ytrain = testTarget;
 
Xtest = featTrain;
tgtTest = trainTarget;

%% Tree model: 
% Read more: https://www.mathworks.com/help/stats/fitctree.html
% 
% Test
% Recieves model and data and returns:
% 'label' - Predicted lables
% 
% 'score' - A matrix of classification scores (score) indicating the likelihood that 
% a label comes from a particular class. For classification trees, 
% scores are posterior probabilities. For each observation in X, 
% the predicted class label corresponds to the minimum expected misclassification cost among all classes.
%
% 'node' - A vector of predicted node numbers for the classification (node).
%
% 'cnum' - A vector of predicted class number for the classification (cnum).
%
% Read more: https://www.mathworks.com/help/stats/compactclassificationtree.predict.html

%% Simple tree
rng default

% Create tree
simpleTree = fitctree(Xtrain, Ytrain);

[simpleTreeLabel,simpleTreeScore,simpleTreeNode,simpleTreeCnum]...
    = predict(simpleTree, Xtest);

% Display confusion matrix using results
[simpleTreeConfMatrix, simpleTreeTargets] = confusionmat(tgtTest,simpleTreeLabel);

save('..\trainedModelsData\finalDTfeatures_3_acty.mat','simpleTree', 'simpleTreeConfMatrix');

%% Tree with parameters
rng default

% Control Tree Depth
maxNumSplits = 25;
minLeafSize = 5;
minParentSize = 2;

parameterTree = fitctree(Xtrain, Ytrain,...
    'MinLeafSize', minLeafSize,...
    'MaxNumSplits',maxNumSplits,...
    'MinParentSize', minParentSize);

[parameterTreeLabel,parameterTreeScore,parameterTreevNode,parameterTreeCnum]...
    = predict(parameterTree, Xtest);

% Display confusion matrix using results
[parameterTreeConfMatrix, parameterTreeTargets] = confusionmat(tgtTest,parameterTreeLabel);
 
%% Cross validation tree

combineX = Xtrain + Xtest;
combineY = Ytest + tgtTest;

crossValTree = fitctree(combineX, combineY,...
    'MinLeafSize', minLeafSize,...
    'MaxNumSplits',maxNumSplits,...
    'MinParentSize', minParentSize,...
    'CrossVal','on');

predicCrossTree = kfoldPredict(crossValTree);
%Mdl = fitctree(Xtrain,Ytrain,'OptimizeHyperparameters','auto')
%pred = predict(Mdl, Xtest);
%pred = str2double(pred);
[matr, targe] = confusionmat(combineY,predicCrossTree);
%cvmodel = crossval(tree);
%L = kfoldLoss(cvmodel);
% Use view(tree) to see the decision tree
%view(tree, 'Mode', 'Graph') % To see the graph

%% For improvement, read more: https://www.mathworks.com/help/stats/classification-trees.html

%% ------------------------- Forest ---------------------------------------
%
% https://www.mathworks.com/help/stats/treebagger.html
% http://kawahara.ca/matlab-treebagger-example/
% -------------------------------------------------------------------------
rng default
numberOfTrees = 100;
forest = TreeBagger(numberOfTrees, Xtrain, Ytrain,...
    'OOBPrediction','on','Method', 'classification');
% cvmodel = crossval(forest);
% L = kfoldLoss(cvmodel)

pred = forest.predict(Xtest);
pred = str2double(pred);
[matr, targe] = confusionmat(tgtTest,pred);
figure;
oobErrorBaggedEnsemble = oobError(forest);
plot(oobErrorBaggedEnsemble)
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';


