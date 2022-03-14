function S = duplication_matrix_for_toeplitz_matrix(N)
% return duplication matrix S (N^2 x 2N-1) to make toeplitz_matrix (N x N)
% e.g. 
%   x = [1; 2; 3; 4; 5], N = 3
%   [1 5 4;
%    2 1 5;
%    3 2 1] = reshape(S * x, [N N])
    C = toeplitz(1:N, [1, 2*N-1:-1:N+1]);
    S = sparse(N^2, 2*N-1);
    i = (1:N^2)';
    j = C(:);
    idx = (j - 1).*N^2 + i;
    S(idx) = 1;
end