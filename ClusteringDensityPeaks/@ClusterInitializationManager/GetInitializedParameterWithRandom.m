function [initializationParameter] = GetInitializedParameterWithRandom(data, componentsCount)
%GETINITIALIZEDPARAMETERWITHRANDOM This function is used to getting a
%initialized parameter with random sample
%   initializationParameter:    Return a initialized parameter.
%   data:   The sampling data.
%   componentsCount:    The number of components.
[dataCount, dimension] = size(data);
initializationParameter = InitialParameter();
randomSequence = ClusterInitializationManager.GetRandomSample(data, componentsCount);
initializationParameter.Means = data(randomSequence, :);
initializationParameter.Variances = repmat(var(data), 1, componentsCount);
initializationParameter.MixProportions = ones(1, componentsCount, 'like', data) / componentsCount;
end

