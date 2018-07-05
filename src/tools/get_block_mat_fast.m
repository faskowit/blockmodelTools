function [weiBM,avgWeiBM,binBM,avgBinBM,sizesMat] = get_block_mat(CIJ,ca)
% given an adjacency matrix + community affiliations, return a block matrix
%
% inputs: 
%           CIJ:        adjacency matrix
%           ca:         community affiliation vector
%
%           NOTE: this function will treat NaNs as zeros
%
% returns: 
%           weiBM:      sum of weights block matrix
%           avgWeiBM:   average weighted block matrix
%           binBM:      sum of binary weights block matrix
%           avgBinBM:   average binary block matrix
%           stdWeiBM:   std weights block matrix 
%           sizesMat:   number of edges per block (incl. NaN edges)
%
% Josh Faskowtiz IU

% make ca column vec
if ~iscolumn(ca)
   ca = ca'; 
end

% number coms
nBlocks = length(unique(ca));

% number nodes per block
blockSizes = histcounts(sort(ca));

sizesMat = bsxfun(@times,...
    (bsxfun(@times,ones(nBlocks),blockSizes)),...
    blockSizes');

W = CIJ ;

% get rid of nans
W(isnan(W)) = 0 ;

C = dummyvar(ca) ;
C = C' ;
% C2 = bsxfun(@eq,ca,unique(ca)');
B = C*W*C' ;
Bcounts = C*(W>0)*C' ;

% weight block matrix
weiBM = B ;
% for the on the diagonal, we should not double count connections
% edit-> user should do this outside func
weiBM(~~eye(nBlocks)) = weiBM(~~eye(nBlocks)) ./ 2 ;

% avg weight block matrix
avgWeiBM = B ;
avgWeiBM = avgWeiBM ./ sizesMat ;

% weight block matrix
binBM = Bcounts ;
% for the on the diagonal, we should not double count connections
% edit-> user should do this outside func
% binBM(~~eye(nBlocks)) = binBM(~~eye(nBlocks)) ./ 2 ;

% avg weight block matrix
avgBinBM = Bcounts ;
avgBinBM = avgBinBM ./ sizesMat ;
