function [ motifStruct , motifsAll_k ] = wsbm_com_motifs(inData,comMat) 
% given raw data and an NxM matrices where N is nodes, and M is any number 
% of partitions of a community detection algo, return the community motif 
% pariticipation in an NxM matrix
% 
% note that each partition must have same number of coms, k

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% get the avgerage block matrix

nReps = size(comMat,2) ;
n = size(comMat,1) ;
k = length(unique(comMat(:,1))) ;
blMats = zeros([ k k nReps]);

for idx = 1:nReps
    
   [~,blMats(:,:,idx)] = get_block_mat(inData,comMat(:,idx)) ;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% get com motifs

motifsAll_k = zeros([k k nReps]) ;

motifStruct = struct() ;
motifStruct.assort = zeros([n nReps]) ;
motifStruct.corPer = zeros([n nReps]) ;
motifStruct.disort = zeros([n nReps]) ;
tmp = fieldnames(motifStruct) ;
motifStruct.varNames = tmp ;

for idx = 1:nReps
    disp(idx)

    tmpMotifMat = wsbm_offDiag_motif(blMats(:,:,idx)) ;
    motifsAll_k(:,:,idx) = tmpMotifMat ; 
    
    % for 1:3, assortative, cor-periph, dissassortative
    for commMotifInd = 1:3
    
        % map the motif participation to the nodes
        for kdx = 1:k

            % select nodes of k community
            tmpCommSelect = (kdx == comMat(:,idx)) ;
            
            % compute proportion that community participates in this
            % specific community motic
            tmpMotifVal = sum(tmpMotifMat(kdx,:) == commMotifInd) + ...
                sum(tmpMotifMat(:,kdx) == commMotifInd) ;
            
            % get proportion by dividing by total off-diag blocked consider
            motifStruct.(motifStruct.varNames{commMotifInd})(tmpCommSelect,idx) = ...
                tmpMotifVal / ((k-1)*2) ;

        end % loop through communities 
    end % loop through community motifs
end % loop through numReps community vecs

