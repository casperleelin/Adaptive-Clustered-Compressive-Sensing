function [densities, densityDistances, densityIndices] = GetDensitiesAndDistancesForHigherDensity(higherLikelihoodData, dc)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
[dataCount, dimension] = size(higherLikelihoodData);
densityValues = [];
densityDistances = [];
for i = 1 : dataCount
    density = 0;
    for j = 1 : dataCount
        if i == j
            continue;
        end
        
        density = density + exp(-(norm(higherLikelihoodData(i, :) - higherLikelihoodData(j, :)) / dc) ^ 2);
    end
    densityValues = [densityValues density];
end

[densities, densityIndices] = sort(densityValues, 'descend');
maxDensityData = higherLikelihoodData(densityIndices(1), :);

distances = pdist2(maxDensityData, higherLikelihoodData);
densityDistanceMax = max(distances);
densityDistances = [densityDistances densityDistanceMax];
for i = 2 : dataCount
    currentEntry = higherLikelihoodData(densityIndices(i), :);
    minDistance = Inf;
    for j = 1 : i - 1
        if densityIndices(i) == densityIndices(j)
            continue;
        end

        entry = higherLikelihoodData(densityIndices(j), :);
        distance = norm(currentEntry - entry);
        if distance < minDistance
            minDistance = distance;
        end
    end
    densityDistances = [densityDistances minDistance];
end
end

