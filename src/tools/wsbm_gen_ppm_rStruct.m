function [ a ] = wsbm_gen_ppm_rStruct(size)
% return the symmetic RStruct based on the size

a = ones(size) .* 2 ;
a(~~eye(size)) = 1 ;