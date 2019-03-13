function [newOrderInd] = wsbm_reorder_block_mod(iMat,ca)

% get average block matrix
blockMat = get_block_mat(iMat,ca) ;

% % reorder_mod on the block matrix
% newOrderInd = reorder_mod(blockMat,unique(ca)) ;

rng(123)
[~,newOrderInd] = reorder_matrix(blockMat,'circ',0) ;
newOrderInd = newOrderInd' ;

