close all; clear; clc;
rng('default');
% waveletBasis = [WaveletTypes.HAAR WaveletTypes.DB2 WaveletTypes.COIF1 WaveletTypes.BIOR1_1 WaveletTypes.SYM2 WaveletTypes.RBIO1_1 WaveletTypes.FK4];
% measurementBasis = [MeasurementBasisTypes.FOURIER MeasurementBasisTypes.DCT MeasurementBasisTypes.TOEPLITZ MeasurementBasisTypes.BERNOULLI MeasurementBasisTypes.HADAMARD];
measurementBasis = MeasurementBasisTypes.FOURIER;
fileName = "Armadillo.ply";
clustersCount = 39;
samplingRatio = .4;
sparseness = .35;

ptCloud = pcread(fileName);
ptCloudData = ptCloud.Location;
rowsCount = 256;
[idx, centroid, sumDistances] = kmeans(ptCloudData, clustersCount);

xWaveletType = WaveletTypes.BIOR1_1;
yWaveletType = WaveletTypes.BIOR1_1;
zWaveletType = WaveletTypes.BIOR1_1;

partialOrigins = cell(1, clustersCount);
partialCompression = cell(1, clustersCount);
revisedSparsenesses = cell(1, clustersCount);
cloudData = cell(1, clustersCount);

for j = 1 : clustersCount
    clusteringIndices = find(idx == j);
    cloudData{j} = ptCloudData(clusteringIndices, :);
end

for f = 1:clustersCount
    clusteringData = cloudData{f};
    [partialCompression{f}, dwtTransformedData, revisedSparsenesses{f}] = getCompressedData(clusteringData, xWaveletType, yWaveletType, zWaveletType, rowsCount, sparseness);
    partialOrigins{f} = clusteringData;
end

%% calculate sensing/measurement matrix         compression
startTime = cputime;
[sensingData,randomMeasurementSequences, scaledSparsenesses] = getSensingData(partialCompression, revisedSparsenesses, samplingRatio, measurementBasis, rowsCount, rowsCount);

%% recover data by sensing/observation matrix
[recoveredData] = getRecoveredData(sensingData, scaledSparsenesses, randomMeasurementSequences, measurementBasis(1), xWaveletType, yWaveletType, zWaveletType, rowsCount);
endTime = cputime;
%% recover from wavelet
recoveredDataFromWavelet = getRecoveredDataFromWavelet(recoveredData, xWaveletType, yWaveletType, zWaveletType, rowsCount);

integrityData = [];
integrityOriginalCoveredData = [];
for f = 1 : clustersCount
    dataLength = size(cloudData{f}, 1);
    integrityData = [integrityData; recoveredDataFromWavelet{f}(1:dataLength, :)];
    integrityOriginalCoveredData = [integrityOriginalCoveredData; partialOrigins{f}(1:dataLength, :)];
end

rmse = rmse(integrityOriginalCoveredData, integrityData);
time = endTime - startTime;

%%
figure(1);
pcshow(integrityOriginalCoveredData);
colorbar;
xlabel('X');
ylabel('Y');
zlabel('Z');
figure(2);
pcshow(integrityData);
colorbar;
xlabel('X');
ylabel('Y');
zlabel('Z');