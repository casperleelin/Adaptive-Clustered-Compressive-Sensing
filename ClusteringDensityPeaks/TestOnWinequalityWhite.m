close all; clear; clc;
rng('default');
wine = readtable('winequality-white.csv');
testData = table2array(wine);
data = testData(:, 1 : size(testData, 2) - 1);

[dataCount, dimension] = size(data);
minValues = min(data);
maxValues = max(data);
observation = [];
for d = 1 : dimension
    minValue = minValues(1, d);
    maxValue = maxValues(1, d);
    subObservation = unifrnd(minValue, maxValue, [1 1]);
    observation = [observation subObservation];
end

distances = pdist2(data, observation);

threshold = 1e-5;

AICInformations = [];
gammaModels = {};
modelIndex = 1;
tic
for i = 2 : 100
    [gammaModel] = GetBestFittedModels(distances, i, threshold);
    [AICInformation] = GetAICInformation(distances, gammaModel);
%     [gammaModel] = fitgmdist(distances, i, 'RegularizationValue', threshold);
    gammaModels{modelIndex} = gammaModel;
    AICInformations = [AICInformations; AICInformation];
    modelIndex = modelIndex + 1;
end
toc

[minValue, minIndex] = min(AICInformations);
optimalModel = gammaModels{minIndex};

%%
optimalInformation = OptimalInformation();
optimalInformation.Converged = false;
optimalInformation.IterationsCount = 0;
optimalInformation.MaxIterationsCount = 100;
optimalInformation.postProbabilityThreshold = 1e-8;
optimalInformation.SolvingThreshold = 1e-6;
sortedData = sort(distances);
logLikelihood = GetGaussianWeightedDensity(sortedData, optimalModel);
[likelihood, postProbabilities, logPdf] = GetEstimationLikelihood(logLikelihood, optimalInformation.postProbabilityThreshold);
densityPdf = exp(logPdf);
figure(1);
plot(sortedData, densityPdf, 'k-');
xlabel('Distance');
ylabel('Probability density function');
%%
dc = 5;
optimalModelComponentsCount = size(optimalModel.Means, 1);
allCenterPoints = [];
rowIndex = 0;
figure(3);
hold on;
sortedDistances = sort(distances, 'ascend');
for i = 1 : optimalModelComponentsCount
    meanValue = optimalModel.Means(i, :);
    varianceValue = optimalModel.Variances(:, i);
    
    probabilities = normpdf(sortedDistances, meanValue, varianceValue);
    plot(sortedDistances, probabilities, 'k-', 'LineWidth', 1);
end
xlabel('distance');
ylabel('probability');
figure(2);
for i = 1 : optimalModelComponentsCount
    meanValue = optimalModel.Means(i, :);
    varianceValue = optimalModel.Variances(:, i);

    loglikelihoods = log(normpdf(distances, meanValue, varianceValue));
    [sortedValue, sortedIndex] = sort(loglikelihoods);
    higherLocalDensityIndices = sortedIndex(floor(length(sortedIndex) / 1.8) : end);

    subData = data(higherLocalDensityIndices, :);
    [densities, densityDistances, densityIndices] = GetDensitiesAndDistancesForHigherDensity(subData, dc);
    maxDensity = densities(1);
    maxDensityDistance = densityDistances(1);
    densityThreshold = maxDensity * .3;
    densityDistanceThreshold = maxDensityDistance * .3;
    densitiesWithThreshold = densities > densityThreshold;
    densityDistancesWithThreshold = densityDistances > densityDistanceThreshold;
    conditions = densitiesWithThreshold & densityDistancesWithThreshold;
    conditionIndices = find(conditions == 1);
    centerPoints = data(higherLocalDensityIndices(densityIndices(conditionIndices)), :);
    allCenterPoints = [allCenterPoints; centerPoints];

    subplot(2, 4, i);
    plot(densities, densityDistances, 'bo');hold on;
    plot([densityThreshold; densityThreshold], [0; maxDensityDistance], 'r-', 'LineWidth', 2.5);
    plot([0; maxDensity], [densityDistanceThreshold; densityDistanceThreshold], 'r-', 'LineWidth', 2.5);
    grid on;
    xlabel('density');
    ylabel('density distance');
end
centerPointsCount = size(allCenterPoints, 1);
%%
centerPoints = GetMergedCenterPoints(allCenterPoints);
centerPoints = GetClusters(centerPoints);
