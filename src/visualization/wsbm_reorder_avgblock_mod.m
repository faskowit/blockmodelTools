function [newOrderInd] = wsbm_reorder_avgblock_mod(iMat,ca)

% get average block matrix
[~,~,avgBlockMat] = get_block_mat(iMat,ca) ;

% % reorder_mod on the block matrix
% newOrderInd = reorder_mod(avgBlockMat,unique(ca)) ;

rng(123)
[~,newOrderInd] = reorder_matrix(avgBlockMat,'circ',0) ;
newOrderInd = newOrderInd' ;
