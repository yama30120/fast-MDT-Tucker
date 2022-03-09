% [T, T_dim, T_mat] = tmult(X, A, n, X_dim)
% this function is caluculating mode-n procudt of X and A
%
% input:
% X: a tensor
% A: a matrix
% n: a mode
% X_dim: a dimension of X (e.g. [3 2 2] repTents tensor of 3 x 2 x 2)
%
% output:
% T: a tensor (X x_n A)
% T_dim: a dimension of T
% T_mat: matrix of not folding T
function [T, T_dim, T_mat] = tmult(X, A, n, X_dim)
    if ~ismatrix(A)
        error('A is not a matrix')
    end
    [J, In] = size(A);
    if size(X, n) ~= In
        error('dimension of X or A is invalid')
    end
    T_dim = X_dim;
    T_dim(n) = J;
    T_mat = A * unfold(X, n);
    T = fold(T_mat, n, T_dim);
end