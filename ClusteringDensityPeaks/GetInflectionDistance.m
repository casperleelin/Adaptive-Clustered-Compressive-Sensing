function [inflectionDistance] = GetInflectionDistance(dissimilarityMatrix, threshold)
%GETINFLECTIONDISTANCE 此处显示有关此函数的摘要
%   此处显示详细说明

sortedVector = sort(dissimilarityMatrix, 'ascend');
% sortedVectorLength = length(sortedVector);

differentialWith2Order = diff(sortedVector, 2);
zeroWith2Order = find(abs(differentialWith2Order) < threshold);
% zeroWith2Order = find(abs(differentialWith2Order) == 0);
inflectionDistance = sortedVector(zeroWith2Order);
end

