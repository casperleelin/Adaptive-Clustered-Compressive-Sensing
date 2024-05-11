function [centerPoints] = GetMergedCenterPoints(clusterCenterPoints)
%GETMERGEDCENTERPOINTS 此处显示有关此函数的摘要
%   此处显示详细说明
[rowsCount, dimension] = size(clusterCenterPoints);
for i = 1 : size(clusterCenterPoints, 1) - 1
    removeRequired = [];
    for j = i + 1 : size(clusterCenterPoints, 1)
        distance = norm(clusterCenterPoints(i, :) - clusterCenterPoints(j, :));
        if distance == 0
            removeRequired = [removeRequired; j];
        end
    end
    clusterCenterPoints(removeRequired, :) = [];
end

centerPoints = clusterCenterPoints;
end

