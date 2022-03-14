function X = fold(Xn, n, Xdims)
% X = fold(Xn, n, Xdims)
% this function is converting an unfolding matrix into an original tensor
%
% input:
%  Xn: a mode-n matricized tensor X
%  n: a mode when matricized
%  Xdims: array of dimensions of original tensor X
%
% output:
% X: a tensor folding Xn of mode n
% N is tensor order of X

    N = length(Xdims);
    
    X = ipermute(reshape(Xn, [Xdims(n), Xdims(1:n-1), Xdims(n+1:N)]), [n, 1:n-1, n+1:N]);
end