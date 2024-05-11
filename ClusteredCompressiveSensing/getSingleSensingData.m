function [sensingData, randomMeasurementSequence, scaledSparseness] = getSingleSensingData(compressedData, sparseness, samplingRatio, measurementBasisType, measurementBasisDimension, rowsCount)
%GET_SINGLE_COMPRESSED_DATA This function is used to getting a single sensing data
%   sensingData: Sensing data.
%   randomMeasurementSequence: A random observation sequence.
%   scaledSparseness: return a scaled sparseness corresponding to
%   sparseness ratio.
%   compressedData: Compressed data.
%   sparseness: Sparseness.
%   samplingRatio: Sampling ratio.
%   measurementBasisType: Measurement basis type.
%   measurementBasisDimension: Measurement basis dimension.
%   rowsCount: Rows count.

[compressedDataRowsCount, compressedDataColumnsCount] = size(compressedData);
randomMeasurementSequence = cell(1, compressedDataColumnsCount);
sensingData = cell(1, compressedDataColumnsCount);
scaledSparseness = cell(1, compressedDataColumnsCount);

for i = 1:compressedDataColumnsCount
    currentCompressedData = compressedData(:, i);
    currentCompressedDataColumnsCount = compressedDataRowsCount / rowsCount;
    currentCompressedData = reshape(currentCompressedData, rowsCount, currentCompressedDataColumnsCount);
    currentSparseness = round(rowsCount * sparseness(i));
    scaledSparseness{i} = currentSparseness;
    currentCompressionLevelsCount = rowsCount / (currentSparseness * (log(rowsCount / currentSparseness) / log(10)));
    samples_count = round(samplingRatio * currentCompressionLevelsCount * currentSparseness * log(rowsCount / currentSparseness) / log(10));
    measurementBasis = getMeasurementBasisMatrix(measurementBasisType, measurementBasisDimension);
    sequence = randperm(rowsCount, samples_count);
    randomMeasurementSequence{i} = measurementBasis(sequence, :);
    sensingData{i} = randomMeasurementSequence{i} * currentCompressedData;
end
end

