function [measurementBasisMatrix] = getMeasurementBasisMatrix(measurementBasisType, dataRowsCount)
%GETMEASUREMENTBASISMATRIX Get the measurement basis matrix with basis type.
%   measurementBasisMatrix:   return measurement basis matrix.
%   measurementBasisType: measurement basis type such as fft, dct,
%   toeplitz and so on.
%   dataRowsCount:    the basis dimensions count of rows.

assistantMatrix = eye(dataRowsCount);

switch measurementBasisType
    case MeasurementBasisTypes.FOURIER
        measurementBasisMatrix = fft(assistantMatrix);
    case MeasurementBasisTypes.DCT
        measurementBasisMatrix = dct(assistantMatrix);
    case MeasurementBasisTypes.TOEPLITZ
        randomValues = randi([0, 1], 1, 2 * dataRowsCount - 1);
        randomValues(randomValues == 0) = -1;
        measurementBasisMatrix = toeplitz(randomValues(dataRowsCount : end), fliplr(randomValues(1 : dataRowsCount)));
    case MeasurementBasisTypes.BERNOULLI
        measurementBasisMatrix = randi([0,1], dataRowsCount, dataRowsCount);
        measurementBasisMatrix(measurementBasisMatrix == 0) = -1;
    case MeasurementBasisTypes.HADAMARD
        hadamard_dimensions_12 = (12 - mod(dataRowsCount, 12)) + dataRowsCount;
        hadamard_dimensions_20 = (20 - mod(dataRowsCount, 20)) + dataRowsCount;
        hadamard_dimensions_power = 2 ^ ceil(log2(dataRowsCount));
        hadamard_dimensions = min([hadamard_dimensions_12, hadamard_dimensions_20, hadamard_dimensions_power]);
        measurementBasisMatrix = hadamard(hadamard_dimensions);
    case MeasurementBasisTypes.GAUSSIAN
        measurementBasisMatrix = randn(dataRowsCount);
    case MeasurementBasisTypes.SPARSERANDOM
        measurementBasisMatrix = zeros(dataRowsCount);
        for i = 1 : dataRowsCount
            row_indices = randperm(dataRowsCount);
            measurementBasisMatrix(row_indices(1 : 8), i) = 1;
        end
    case MeasurementBasisTypes.CIRCULANT
        randomValues = randi([0, 1], 1, dataRowsCount);
        randomValues(randomValues == 0) = -1;
        measurementBasisMatrix = toeplitz(circshift(randomValues, [1, 1]), fliplr(randomValues(1 : dataRowsCount)));
    otherwise
        measurementBasisMatrix = fft(assistantMatrix);
end
end

