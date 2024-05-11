function [sensingData,randomMeasurementSequences, scaledSparsenesses] = getSensingData(compressedData, sparsenesses, samplingRatio, measurementBasisType, measurementBasisDimension, rowsCount)
%GETSENSINGDATA This functon is used to generated the
%sensing data and measurement data.
%   sensingData: return a sensing matrix for the compression.
%   randomMeasurementSequences: return a sort of observative random
%   scaledSparsenesses: return a sort of scaled_sparsenesses.
%   sequences for observation matrices.
%   compressedData: compressed data.
%   sparsenesses: a set of sparsenesses.
%   samplingRatio: sampling ratio.
%   measurementBasisType: observation basis type.
%   measurementBasisDimension: the dimension of a specified observation
%   basis
%   rowsCount: Rows count.

dataLength = length(compressedData);
sensingData = cell(1, dataLength);
randomMeasurementSequences = cell(1, dataLength);
scaledSparsenesses = cell(1, dataLength);

for i = 1:dataLength
    [sensingData{i}, randomMeasurementSequences{i}, scaledSparsenesses{i}] = getSingleSensingData(compressedData{i}, sparsenesses{i}, samplingRatio, measurementBasisType, measurementBasisDimension, rowsCount);
end
end

