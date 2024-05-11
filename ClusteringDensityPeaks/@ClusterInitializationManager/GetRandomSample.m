function [randomRowIndices] = GetRandomSample(data, componentsCount)

dataCount = size(data, 1);
randomSeed = RandStream.getGlobalStream();
randomData = false(1, dataCount); % flags
nonZerosCount = 0;

while nonZerosCount < floor(componentsCount) % prevent infinite loop when 0<k<1
    randomData(randi(randomSeed, dataCount, 1, componentsCount - nonZerosCount)) = true; % sample w/replacement
    nonZerosCount = nnz(randomData); % count how many unique elements so far
end

randomRowIndices = find(randomData);
randomRowIndices = randomRowIndices(randperm(randomSeed, componentsCount));
end

