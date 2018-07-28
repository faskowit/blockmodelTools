function [ a ] = wsbm_gen_modppm_rStruct(size)
% return the symmetic RStruct based on the size

a = eye(size) ;
a(~~a) = 1:size ;
a(a==0) = size + 1;
a(~~triu(ones(size),1)) = size + 2 ;   



