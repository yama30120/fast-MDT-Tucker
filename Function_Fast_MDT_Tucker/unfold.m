% Xn = unfold(X, n)
% this function is mode-n matricization(unfolding) of X
%
% input:
% X: a tensor
% n: a mode, first dimension of the result matrix
%
% output:
% Xn: a matrix unfolding a tensor X of mode-n
function Xn = unfold(X, n)
    N = ndims(X);
    perm = [n, 1:n-1, n+1:N];
    Xn = reshape(permute(X, perm), size(X, n), []);
end