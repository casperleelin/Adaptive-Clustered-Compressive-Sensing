function [recoveredData] = getSingleRecoveredData(sensingData, scaledSparseness, randomMeasurementSequence, measurementBasisType, rowsCount)
%GET_SINGLE_RECOVERED_DATA This function is used to generating a single
%recovered data.
%   recoveredData: return a recovered data.
%   sensingData: sensing data.
%   randomMeasurementSequence: a random measurement sequencies.
%   measurementBasisType: a specific measurement basis type
%   rows_count: rows count.

dataLength = length(sensingData);
recoveredData = cell(1, dataLength);

for i = 1 : dataLength
    measurementMatrix = randomMeasurementSequence{i};
    columnsCount = size(sensingData{i}, 2);
%     if i == 1
        [solves,history] = getNorm1SolvesBP(measurementMatrix, sensingData{i}, 1.0, 1.0);
%         cvx_begin;
%             variable solves(rowsCount, columnsCount);
%             minimize(norm(solves, 1));
%             subject to
%             double(sensingData{i}) == measurementMatrix * solves;
%         cvx_end;
%     elseif i == 2
%         solves = CompressiveSamplingMatchPersuit(measurementMatrix, sensingData{i}, scaledSparseness{i});
%         solves = RegularOthogonalMatchPersuit(measurementMatrix, sensingData{i}, scaledSparseness{i});
%     else
%         solves = OrthogonalMatchPersuit(measurementMatrix, sensingData{i}, scaledSparseness{i});
%     end
    recoveredData{i} = solves;
end
end

