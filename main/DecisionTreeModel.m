
% Decision Tree Model
%%
load('features_3_acty.mat')

%%
% Xtrain = featTrain;
% Ytrain = trainTarget;
% 
% Xtest = featTest;
% tgtTest = testTarget;

Xtrain = featTest;
Ytrain = testTarget;
 
Xtest = featTrain;
tgtTest = trainTarget;
%% Train network
% 
% Tree model: 
% Read more: https://www.mathworks.com/help/stats/fitctree.html
rng default
tree = fitctree(Xtrain, Ytrain);

cvmodel = crossval(tree);
L = kfoldLoss(cvmodel)
% Use view(tree) to see the decision tree
view(tree, 'Mode', 'Graph') % To see the graph

%% Test

% Xtest = featTest;
% tgtTest = testTarget;

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
[label,score,node,cnum] = predict(tree, Xtest);

%% Display confusion matrix using results

[matrix, targets] = confusionmat(tgtTest,label);


save('.\trainedModelsData\finalDTfeatures_3_acty.mat','tree');
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


