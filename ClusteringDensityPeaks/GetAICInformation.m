function [AICInformation] = GetAICInformation(data, gammaModel)
%GETAICINFORMATION 此处显示有关此函数的摘要
%   此处显示详细说明
[dataCount, dimension] = size(data);
componentsCount = size(gammaModel.Means, 1);
nParam = componentsCount * dimension * (dimension + 1) / 2;
nParam = nParam + componentsCount - 1 + componentsCount * dimension;
AICInformation = 2 * (-gammaModel.Likelihood) + 2 * nParam;
end

