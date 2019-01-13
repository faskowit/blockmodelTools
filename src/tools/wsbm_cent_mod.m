function [ centralModel, viMat, ind ] = wsbm_cent_mod( modelsCellArray )
% function for iterating over a stuct to find the central model, in terms
% of community labels, mu.  Have the option of providing a prior too
% edited this to also take in cell array of models
%
% if inputting a matrix, it should be numNodes x numRepetitions

if iscell(modelsCellArray)
    caMat = cell2mat(cellfun(@(x)wsbm_community_assign(x)', ...
                modelsCellArray,'UniformOutput',0))' ;
elseif ismatrix(modelsCellArray)
    caMat = modelsCellArray ;
else
    error('need either cell array or matrix input')
end
        
viMat = partition_distance(caMat) ;

viDist = sum(viMat,2) ;
[~,minIdx] = min(viDist) ;

if iscell(modelsCellArray)
    centralModel = modelsCellArray{minIdx} ;
else
    centralModel = modelsCellArray(:,minIdx);     
end

ind = minIdx ;

