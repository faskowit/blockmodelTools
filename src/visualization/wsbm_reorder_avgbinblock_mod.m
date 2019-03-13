function [newOrderInd] = wsbm_reorder_avgbinblock_mod(iMat,ca)

% get average block matrix
[~,~,~,avgBinBlockMat] = get_block_mat(iMat,ca) ;

% % reorder_mod on the block matrix
% newOrderInd = reorder_mod(binBlockMat,unique(ca)) ;

rng(123)
[~,newOrderInd] = reorder_matrix(avgBinBlockMat,'circ',0) ;
newOrderInd = newOrderInd' ;
