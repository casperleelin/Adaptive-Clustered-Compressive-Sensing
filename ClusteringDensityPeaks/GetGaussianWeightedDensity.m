function [logLikelihoods] = GetGaussianWeightedDensity(data, initializationParameter)
%GETGAUSSIANWEIGHTEDDENSITY 

logPriorMixProportions = log(initializationParameter.MixProportions);
[dataCount, dimension] = size(data);
componentsCount = size(initializationParameter.Means, 1);

logLikelihoods = zeros(dataCount, componentsCount, 'like', data);

for i = 1 : componentsCount
    standardVariance = sqrt(initializationParameter.Variances(:, i));
%     if  any(standardVariance < eps(max(standardVariance)) * dimension)
%         error(message('stats:gmdistribution:wdensity:IllCondCov'));
%     end
    logDeterminantVariance = sum(log(initializationParameter.Variances(:, i)));
    logLikelihoods(:, i) = sum(((data - initializationParameter.Means(i, :)) / standardVariance) .^ 2, 2);
    logLikelihoods(:, i) = -0.5 * (logLikelihoods(:, i) + logDeterminantVariance);
end

logLikelihoods = logLikelihoods + logPriorMixProportions - dimension * log(2 * pi) / 2;

end

