function [basis] = getWaveletBasis(dimensions, waveletType, decompositionLevel)
%GET_WAVELET_BASIS This function is used to generate the wavelet basis
%   dimensions: the dimensions count.
%   waveletType: the type of the wavelet.
%   decompositionLevel: the level of the decompositions.
%   basis: return the wavelet basis.
waveletName = 'haar';
switch waveletType
    case WaveletTypes.HAAR
        waveletName = 'haar';
    case WaveletTypes.DB2
        waveletName = 'db2';
    case WaveletTypes.SYM2
        waveletName = 'sym2';
    case WaveletTypes.COIF1
        waveletName = 'coif1';
    case WaveletTypes.BIOR1_1
        waveletName = 'bior1.1';
    case WaveletTypes.RBIO1_1
        waveletName = 'rbio1.1';    
    case WaveletTypes.RBIO1_5
        waveletName = 'rbio1.5';
    case WaveletTypes.FK4
        waveletName = 'fk4';
    case WaveletTypes.FK6
        waveletName = 'fk6';    
    case WaveletTypes.FK14
        waveletName = 'fk14';
    case WaveletTypes.DB3
        waveletName = 'db3';
    case WaveletTypes.DB4
        waveletName = 'db4';
    case WaveletTypes.DB10
        waveletName = 'db10';
    case WaveletTypes.SYM7
        waveletName = 'sym7';    
    case WaveletTypes.BIOR2_4
        waveletName = 'bior2.4';
    case WaveletTypes.BIOR4_4
        waveletName = 'bior4.4';
    case WaveletTypes.SYM3
        waveletName = 'sym3';    
    case WaveletTypes.SYM11
        waveletName = 'sym11';
    otherwise
        waveletName = 'haar';
end
[LoD,HiD,LoR,HiR] = wfilters(waveletName);
old_dwt_mode = dwtmode('status','nodisp');
dwtmode('per');
basis = zeros(dimensions, dimensions);
for i = 1 : dimensions
    unit_vector = zeros(dimensions, 1);
    unit_vector(i) = 1;
    [coefficients, level] = wavedec(unit_vector, decompositionLevel, LoD, HiD);
    basis(:, i) = coefficients;
end

end

