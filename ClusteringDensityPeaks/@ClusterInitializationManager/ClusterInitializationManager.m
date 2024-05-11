classdef ClusterInitializationManager
    %CLUSTERINITIALIZATIONMANAGER This class provides some initial methods in
    %cluster process.
    
    methods(Static)
        initializationParameter = GetInitializationParameter(data, componentsCount, initializationType);
    end

    methods(Access = private, Static)
        initializationParameter = GetInitializedParameterWithRandom(data, componentsCount);
        randomRowIndices = GetRandomSample(dataCount, componentsCount);
    end
end

