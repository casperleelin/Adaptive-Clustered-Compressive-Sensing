function [dissimilarityMatrix] = GetDissimilarityMatrix(clusterCenterPoints)
%GETDISSIMILARITYMATRIX 此处显示有关此函数的摘要
%   此处显示详细说明
[rowsCount, dimension] = size(clusterCenterPoints);
dissimilarityMatrix = [];
for i = 1 : rowsCount - 1
    rowVector = zeros(1, rowsCount - i);
    for j = 1 : rowsCount - i
        rowVector(j) = norm(clusterCenterPoints(i, :) - clusterCenterPoints(i + j, :));
        if j == 81
            ss = 'kk';
        end
    end
    dissimilarityMatrix = [dissimilarityMatrix rowVector];
end
end

