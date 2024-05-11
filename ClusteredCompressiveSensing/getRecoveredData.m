function [recoveredData] = getRecoveredData(sensingData, scaledSparsenesses, randomMeasurementSequences, measurementBasisType, xWaveletType, yWaveletType, zWaveletType, rowsCount)
%GETRECOVEREDDATA This function is used to generating the recovered data.
%   recoveredData: return a recovered data.
%   sensingData: sensing data.
%   scaledSparsenesses: Scaled sparsenesses.
%   randomMeasurementSequences: a sort of random observation sequencies.
%   measurementBasisType: a specific measurement basis type
%   xWaveletType: The wavelet type on x axis.
%   yWaveletType: The wavelet type on y axis.
%   zWaveletType: The wavelet type on z axis.
%   rowsCount: rows count.

sensingDataLength = length(sensingData);
recoveredData = cell(1, sensingDataLength);

for i = 1:sensingDataLength
    [recoveredData{i}] = getSingleRecoveredData(sensingData{i}, scaledSparsenesses{i}, randomMeasurementSequences{i}, measurementBasisType, rowsCount);
end

end

