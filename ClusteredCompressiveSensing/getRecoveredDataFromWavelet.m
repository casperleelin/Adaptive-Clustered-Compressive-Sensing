function [recoveredDataFromWavelet] = getRecoveredDataFromWavelet(recoveredData, xWaveletType, yWaveletType, zWaveletType, rowsCount)
%GET_RECOVERED_DATA_FROM_WAVELET This function is used to generating
%recovered data from wavelet basis.
%   recoveredDataFromWavelet: return recovered data with corresponding
%   wavelet basis.
%   recoveredData: the compressed signal from sensing matrix and
%   observation matrix.
%   xWaveletType: The wavelet type on x axis.
%   yWaveletType: The wavelet type on y axis.
%   zWaveletType: The wavelet type on z axis.
%   rowsCount: rows count.
dataLength = length(recoveredData);
recoveredDataFromWavelet = cell(1, dataLength);

xWaveletBasis = getWaveletBasis(rowsCount, xWaveletType, 8);
yWaveletBasis = getWaveletBasis(rowsCount, yWaveletType, 8);
zWaveletBasis = getWaveletBasis(rowsCount, zWaveletType, 8);

for i = 1:dataLength
    data = recoveredData{i};
    recoveredDataLength = length(data);
    singleRecoveredDataFromWavelet = [];
    for j = 1:recoveredDataLength
        if j == 1
            single_data = real(xWaveletBasis \ data{j});
        elseif j == 2
            single_data = real(yWaveletBasis \ data{j});
        else
            single_data = real(zWaveletBasis \ data{j});
        end
        [singleDataRowsCount, singleDataColumnsCount] = size(single_data);
        singleRecoveredDataFromWavelet = [singleRecoveredDataFromWavelet reshape(single_data, singleDataRowsCount * singleDataColumnsCount, 1)];
    end
    recoveredDataFromWavelet{i} = singleRecoveredDataFromWavelet;
end
end

