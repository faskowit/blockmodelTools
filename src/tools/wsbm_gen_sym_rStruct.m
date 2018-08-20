function [ a ] = wsbm_gen_sym_rStruct(size)
% return the symmetic RStruct based on the size
%
% wsbm_gen_sym_rStruct(4)
% 
% ans =
% 
%      1     2     4     7
%      2     3     5     8
%      4     5     6     9
%      7     8     9    10

a = triu(ones(size)) ;
b = (size * (size - 1) / 2 ) + size ;
a(~~a) = 1:b ;
a = a + triu(a,1)' ;