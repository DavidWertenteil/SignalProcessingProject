function ExtractAllFeatures

load('formatedData.mat')
% Expect as many rows of features as number of available data buffers
train = zeros(length(trainTarget),10);
test = zeros(length(testTarget),10);

for n = 1:length(trainTarget)
    % Extract features for train data buffers
    train(n,:) = featuresFromBuffer(train_aty(n,:), train_atz(n,:), fs); 
end
%%
for n = 1:length(testTarget)
    % Extract features for test data buffers
    test(n,:) = featuresFromBuffer(test_aty(n,:), test_atz(n,:), fs); 
end

% Save extracted features to a data file
featTrain = train;
featTest = test;
featlabels = getFeatureNames;

save('features.mat','featTrain','featTest','trainTarget','testTarget','featlabels')
clear

function featureNames = getFeatureNames

featureNames(1,1) = {'TotalAccYMean'};%
featureNames(2,1) = {'TotalAccZMean'};%
featureNames(3,1) = {'BodyAccYRMS'};%
featureNames(4,1) = {'BodyAccYCovZeroValue'};%
featureNames(5,1) = {'BodyAccZSpectPos6'};%
featureNames(6,1) = {'BodyAccZSpectVal3'};%
featureNames(7,1) = {'BodyAccYPowerBand2'};%
featureNames(8,1) = {'BodyAccYPowerBand3'};%
featureNames(9,1) = {'BodyAccYPowerBand4'};%
featureNames(10,1) = {'BodyAccZPowerBand4'};%

