function [centerPoints] = GetClusters(allCenterPoints)
%GETCLUSTERS 此处显示有关此函数的摘要
%   此处显示详细说明
centerPoints = allCenterPoints;
allCenterPointsCount = size(centerPoints, 1);

dissimilarityVector = GetDissimilarityMatrix(centerPoints);
centerPointSeries = ones(allCenterPointsCount, 1);
distances = GetInflectionDistance(dissimilarityVector, 1e-4);
distances = [0 unique(distances)];
if length(distances) <= 1
    return;
end
subCenterPoints = [];
dissimilarityMatrix = squareform(pdist(centerPoints));

for j = 1 : length(distances) - 1
    [dissimilarityColIndices, dissimilarityRowIndices] = find(dissimilarityMatrix < distances(j + 1) & dissimilarityMatrix > distances(j));

    dissimilarityRowGroup = unique(dissimilarityRowIndices);
    for i = 1 : length(dissimilarityRowGroup)
        sign = dissimilarityRowGroup(i);
        if centerPointSeries(sign) == 1
            subCenterPoints = [subCenterPoints; centerPoints(sign, :)];
            rowIndices = find(dissimilarityRowIndices == sign);
            centerPointSeries(dissimilarityColIndices(rowIndices)) = 0;
            centerPointSeries(sign) = 0;
        end
    end
end
centerPointSeriesIndices = find(centerPointSeries ~= 0);
subCenterPoints = [subCenterPoints; centerPoints(centerPointSeriesIndices, :)];
centerPoints = subCenterPoints;
allCenterPointsCount = size(centerPoints, 1);

end