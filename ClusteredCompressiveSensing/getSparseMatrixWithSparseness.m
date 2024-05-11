function [sparseData, revisedSparseness] = getSparseMatrixWithSparseness(sourceMatrix, sparseness)
%GETSPARSEMATRIXBYSPARSENESS Get the sparse matrix from specific sparseness.
%   sparseData sparse data
%   revisedSparseness: recrected sparseness.
%   sourceMatrix:Source matrix data.
%   sparseness: the percent of zeros number.
[rowsCount, columnsCount] = size(sourceMatrix);
absoluteValues = abs(sourceMatrix);
maxValue = max(absoluteValues, [], 'all');
currentValue = min(absoluteValues, [], 'all');

while currentValue < maxValue
    changedSparseMatrix = sourceMatrix;
    sparseIndex = abs(changedSparseMatrix) < currentValue;
    [rowIndices, columnIndices] = find(sparseIndex == 1);
    for i = 1:length(rowIndices)
        changedSparseMatrix(rowIndices(i), columnIndices(i)) = 0;
    end
    
    currentSparseness = (1 - length(find(changedSparseMatrix == 0)) / (rowsCount * columnsCount));
    currentValue = currentValue + .005;
    if currentSparseness <= sparseness
        revisedSparseness = currentSparseness;
        sparseData = changedSparseMatrix;
        break;
    end
end
end

