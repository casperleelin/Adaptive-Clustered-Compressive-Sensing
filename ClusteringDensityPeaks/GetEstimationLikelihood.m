function [likelihood, postProbabilities, logPdf] = GetEstimationLikelihood(logLikelihood, threshold)
%GETESTIMATIONLIKELIHOOD 此处显示有关此函数的摘要
%   此处显示详细说明
maxLikelihood = max(logLikelihood, [], 2);%minus maxll to avoid underflow
postProbabilities = exp(logLikelihood - maxLikelihood);
density = sum(postProbabilities, 2);
logPdf = log(density) + maxLikelihood;
likelihood = sum(logPdf);
postProbabilities = postProbabilities ./ density;

postProbabilities(postProbabilities < threshold) = 0;
density = sum(postProbabilities, 2);
postProbabilities = postProbabilities ./ density;%renormalize posteriors
end
