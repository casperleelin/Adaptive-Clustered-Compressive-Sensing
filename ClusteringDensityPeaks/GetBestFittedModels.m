function [gammaModel] = GetBestFittedModels(data, componentsCount, threshold)
%GETBESTFITTING Getting the best fitted models from all observers 
%   bestFittedModels: Return a set of best fitted models.
%   data: The original data.
%   observationsCount: The number of all observations.
%   dimension: The number of the dimension.
%   componentsCount: The number of components to build for the observation
%   point.
%   threshold:  The error threshold.

[dataCount, dimension] = size(data);
th =floor(dataCount * 0.4); %The threshold deciding when to use indexing on matrix compuation

initializationParameter = ClusterInitializationManager.GetInitializationParameter(data, componentsCount, InitializationTypes.RANDOMSAMPLE);
likelihoodPrevious = -inf;
optimalInformation = OptimalInformation();
optimalInformation.Converged = false;
optimalInformation.IterationsCount = 0;
optimalInformation.MaxIterationsCount = 100;
optimalInformation.postProbabilityThreshold = 1e-8;
optimalInformation.SolvingThreshold = 1e-6;

for i = 1 : optimalInformation.MaxIterationsCount
    logLikelihood = GetGaussianWeightedDensity(data, initializationParameter);
    [likelihood, postProbabilities, logPdf] = GetEstimationLikelihood(logLikelihood, optimalInformation.postProbabilityThreshold);
    likelihoodDifference = likelihood - likelihoodPrevious;
    if likelihoodDifference >= 0 && likelihoodDifference < optimalInformation.SolvingThreshold * abs(likelihood)
        optimalInformation.Converged = true;
        break;
    end
    likelihoodPrevious = likelihood;
    initializationParameter.MixProportions = sum(postProbabilities, 1);

    for j = 1 : componentsCount
        if initializationParameter.MixProportions(j) == 0
            continue;
        end
        postProbabilitiesForJ = postProbabilities(:, j)';
        nonzerosIndices = postProbabilitiesForJ > 0;
        initializationParameter.Means(j, :) = postProbabilitiesForJ * data / initializationParameter.MixProportions(j);

        if sum(nonzerosIndices) < th
            dataForRemovingCenter = data(nonzerosIndices, :) - initializationParameter.Means(j, :);
            postProbabilitiesForJ = postProbabilitiesForJ(nonzerosIndices);
        else
            dataForRemovingCenter = data - initializationParameter.Means(j, :);
        end

        dataForRemovingCenter = sqrt(postProbabilitiesForJ') .* dataForRemovingCenter;
        initializationParameter.Variances(:, j) = (dataForRemovingCenter' * dataForRemovingCenter) / initializationParameter.MixProportions(j);
    end

    initializationParameter.MixProportions = initializationParameter.MixProportions / sum(initializationParameter.MixProportions);
end

optimalInformation.IterationsCount = i;
initializationParameter.Likelihood = likelihood;
gammaModel = initializationParameter;
end