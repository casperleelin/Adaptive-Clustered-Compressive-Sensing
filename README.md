# Adaptive CCS: Adaptive Clustered Compressive Sensing
This repository provides the adaptive clustered compressive sensing algorithm. The MEMS-based (Micro Electronical Mechanical System) LiDAR provides precise point cloud datasets for rock fragment surfaces. However, there is more vibrational noise in the MEMS-based LiDAR signals, which cannot guarantee that the reconstructed point cloud data is not distorted with a high compression ratio. Many studies illustrate that wavelet-based clustered compressive sensing can improve reconstruction precision. Conveniently, the k-means clustering algorithm is employed to obtain clusters. However, estimating meaningful k-value (i.e., the number of clusters) is challenging. An excessive quantity of clusters is not necessary for dense point clouds, as this leads to elevated consumption of memory and CPU resources. For sparser point clouds, fewer clusters lead to more distortions, and excessive clusters lead to more voids in reconstructed point clouds. This study proposes a local clustering method to determine the number of clusters closer to the actual number based on the observation distances GMM (Gaussian Mixture Model) and density peaks.

This algorithm consists of two fundational algorithms: One is the automatic k-value determination algorithm based on observation distances GMM and density peaks. The other is clustered compressive sensing algorithm based on ADMM-BP.

## 1. Automatic k-value determination algorithm
The source codes of this algorithm is located at "ClusteringDensityPeaks" folder. Firstly, we iteratively calculate the PDF of observation distances, which the iterative maximum number of components is set to 100. The optimal GMM (Gaussian Mixed Model) is determined by the minimum AIC value. Secondly, the density peaks algorithm is employed to find out potential cluster centers. Finally, a second-order difference algorithm remove all redundant cluster centers. Fig 1 shows the PDF of the optimal GMM in Winequality-White dataset of KEEL repository (https://sci2s.ugr.es/keel/category.php?cat=clas). Fig 2 Shows decision graphs based on density peaks.
<img src="https://github.com/casperleelin/Adaptive-Clustered-Compressive-Sensing/blob/master/figure13.png" border="0" width="300"/>

Fig 1. The PDF of the optimal GMM based on observation distances.

<img src="https://github.com/casperleelin/Adaptive-Clustered-Compressive-Sensing/blob/master/figure14.png" border="0" width="600"/>

Fig 2. Decision graphs of density peaks.

You can run directly "TestOnWinequalityWhite.m" to obtain the number of clusters in Winequality-White dataset as shown in Fig 1 and Fig 2.

“TestOnStanfordPointClouds.m” represent a experiment on the Stanford 3D repository.

"TestOnRockFragmentSurfacePointClouds.m" is an example for our rock fragment surfaces point cloud.

## 2. Clustered compressive sensing algorithm
The source codes of this algorithm is located at "ClusteredCompressiveSensing" folder. This algorithm implement the clustered compressive sensing based on ADMM-BP algorithm. Fig 3 shows the distortion of reconstructed Armadillo point cloud with various number of clusters.

<img src="https://github.com/casperleelin/Adaptive-Clustered-Compressive-Sensing/blob/master/fig19.png" border="0" width="600"/>

Fig 3. Reconstructed Armadillo Point Cloud. (A) Reconstructed point cloud using non-clustered compressive sensing. (B) Reconstructed point cloud using ours. (C)
Reconstructed point cloud using GMM CCS. (D) Reconstructed point cloud using Sli-based CCS. (E) Reconstructed point cloud using CH-based CCS. (F) Reconstructed point cloud using DB-based CCS.
