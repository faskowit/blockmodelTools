function [newOrderInd] = wsbm_reorder_block_mod(iMat,ca)

% get average block matrix
[~,avgblMat] = get_block_mat(iMat,ca) ;

% reorder_mod on the block matrix
newOrderInd = reorder_mod(avgblMat,unique(ca)) ;
%newOrderInd = flipud(newOrderInd) ;
