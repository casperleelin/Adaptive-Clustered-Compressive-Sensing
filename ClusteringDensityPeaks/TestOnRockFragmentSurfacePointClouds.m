close all; clear; clc;
rng('default');
pcloud = pcread("ApproximateVolume.ply");
data = pcloud.Location;

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

threshold = 1e-7;

AICInformations = [];
gammaModels = {};
modelIndex = 1;
tic
for i = 2 : 100
    [gammaModel] = GetBestFittedModels(distances, i, threshold);
    [AICInformation] = GetAICInformation(distances, gammaModel);
    gammaModels{modelIndex} = gammaModel;
    AICInformations = [AICInformations; AICInformation];
    modelIndex = modelIndex + 1;
end
toc

[minValue, minIndex] = min(AICInformations);
optimalModel = gammaModels{minIndex};
%%
close all;
dc = 5;
optimalModelComponentsCount = size(optimalModel.Means, 1);
allCenterPoints = [];
for i = 1 : optimalModelComponentsCount
    meanValue = optimalModel.Means(i, :);
    varianceValue = optimalModel.Variances(:, i);

    loglikelihoods = log(normpdf(distances, meanValue, varianceValue));
    [sortedValue, sortedIndex] = sort(loglikelihoods);
    higherLocalDensityIndices = sortedIndex(floor(length(sortedIndex) / 1.06) : end);

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
%     figure(i);
%     plot(densities, densityDistances, 'bo');hold on;
%     plot([densityThreshold; densityThreshold], [0; maxDensityDistance], 'r-', 'LineWidth', 2.5);
%     plot([0; maxDensity], [densityDistanceThreshold; densityDistanceThreshold], 'r-', 'LineWidth', 2.5);
%     grid on;
%     xlabel('density');
%     ylabel('density distance');
end
centerPointsCount = size(allCenterPoints, 1);
%%
centerPoints = GetMergedCenterPoints(allCenterPoints);
centerPoints = GetClusters(centerPoints);