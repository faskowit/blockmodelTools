function [ a , aFull ] = make_square(M)
% make square out of triu + diag vector 

b = length(M) ;
s = sqrt(2 * b + 0.25) - 0.5 ;
a = triu(ones(s),0) ;
a(~~a) = M' ;
aFull = a + triu(a,1)';