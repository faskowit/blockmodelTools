function [ a ] = wsbm_gen_sym_rStruct(size)
% return the symmetic RStruct based on the size

a = triu(ones(size)) ;
b = (size * (size - 1) / 2 ) + size ;
a(~~a) = 1:b ;
a = a + triu(a,1)' ;