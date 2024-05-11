function [compressedData, dwtTransformedData, revisedSparsenesses] = getCompressedData(cloudData, xWaveletType, yWaveletType, zWaveletType, rowsCount, sparseness)
%COMPRESS_DATA Compress the cloud data
%   compressedData: Compressed cloud data.
%   dwtTransformedData: Recovered data from a DWT transformation
%   revisedSparsenesses: revised sparsenesses.
%   cloudData: Source data.
%   xWaveletType: wavelet type on x axis.
%   yWaveletType: wavelet type on y axis.
%   zWaveletType: wavelet type on z axis.
%   rowsCount: reshape the source data to rows_count rows data.
%   sparseness: the percent of zeros number.
    [dataRowsCount, dataColumnsCount] = size(cloudData);
    if mod(dataRowsCount, rowsCount) ~= 0
        columnsCount = round(dataRowsCount / rowsCount) + 1;
    else
        columnsCount = dataRowsCount / rowsCount;
    end
    
    compressedData = [];
    dwtTransformedData = [];
    revisedSparsenesses = [];
    for i = 1 : size(cloudData, 2)
        extendedData = zeros(columnsCount * rowsCount, 1);
        extendedData(1:dataRowsCount, 1) = cloudData(:, i);

        matrix_data = reshape(extendedData, rowsCount, columnsCount);
        if i == 1
            waveletBasis = getWaveletBasis(rowsCount, xWaveletType, 8);
        elseif i == 2
            waveletBasis = getWaveletBasis(rowsCount, yWaveletType, 8); 
        else
            waveletBasis = getWaveletBasis(rowsCount, zWaveletType, 8); 
        end
        sparseMatrix = waveletBasis * matrix_data;
        
        [changedSparseMatrix, revisedSparseness] = getSparseMatrixWithSparseness(sparseMatrix, sparseness);
        row_data = reshape(changedSparseMatrix, columnsCount * rowsCount, 1);
        compressedData = [compressedData row_data];
        recoveredData = real(waveletBasis \ changedSparseMatrix);
        recoveredRowData = reshape(recoveredData, columnsCount * rowsCount, 1);
        dwtTransformedData = [dwtTransformedData recoveredRowData];

        revisedSparsenesses = [revisedSparsenesses revisedSparseness];
    end
end

