function [ alignedComMat ] = align_com_labeling(comMat) 
% align a N(numNodes)xM(numParitions) mat to the centroid labeling

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% identify the centroid

viDist = partition_distance(comMat) ;

viDistSum = sum(viDist) ;
[~,minDistInd] = min(viDistSum) ;

refCA = comMat(:,minDistInd) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% align to centroid

alignedComMat = zeros(size(comMat)) ;

for idx = 1:size(comMat,2)
   alignedComMat(:,idx) = hungarianMatch(refCA,comMat(:,idx),0) ; 
end
