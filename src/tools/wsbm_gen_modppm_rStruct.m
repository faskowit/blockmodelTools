function [ a ] = wsbm_gen_modppm_rStruct(size)
% return the symmetic RStruct based on the size
%
% wsbm_gen_modppm_rStruct(4)
% 
% ans =
% 
%      1     6     6     6
%      5     2     6     6
%      5     5     3     6
%      5     5     5     4

a = eye(size) ;
a(~~a) = 1:size ;
a(a==0) = size + 1;
a(~~triu(ones(size),1)) = size + 2 ;   



