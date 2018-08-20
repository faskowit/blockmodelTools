function [ a ] = wsbm_gen_sym_oneBlockDiag_rStruct(size)
% return the symmetic RStruct based on the size
%
% wsbm_gen_sym_oneBlockDiag_rStruct(4)
% 
% ans =
% 
%      1     2     3     5
%      2     1     4     6
%      3     4     1     7
%      5     6     7     1

a = triu(ones(size),1) ;
b = (size * (size - 1) / 2 ) + 1 ;
a(~~a) = 2:b ;
a = a + eye(size) ;
a = a + triu(a,1)' ;