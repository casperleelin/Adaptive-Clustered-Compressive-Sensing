function [initializationParameter] = GetInitializationParameter(data, componentsCount, initializationType)
%GETINITIALIZATIONPARAMETER This function is used to getting the initial
%parameter with a specified InitializationType.
%   initializationParameter:    Return an initialized parameter.
%   initializationType: A specified initialization type.

switch(initializationType)
    case InitializationTypes.KMEANSPLUSPLUS
        initializationParameter = ClusterInitializationManager.GetInitializedParameterWithRandom(data, componentsCount);
    case InitializationTypes.RANDOMSAMPLE
        initializationParameter = ClusterInitializationManager.GetInitializedParameterWithRandom(data, componentsCount);
    otherwise
        error('There is not a such function!');
end
end

