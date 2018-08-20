function [ a ] = wsbm_gen_ppm_rStruct(size)
% return the symmetic RStruct based on the size
%
% wsbm_gen_ppm_rStruct(5)
% 
% ans =
% 
%      1     2     2     2     2
%      2     1     2     2     2
%      2     2     1     2     2
%      2     2     2     1     2
%      2     2     2     2     1


a = ones(size) .* 2 ;
a(~~eye(size)) = 1 ;