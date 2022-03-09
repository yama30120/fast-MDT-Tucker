function S = duplication_matrix_for_toeplitz_matrix(N)
    C = toeplitz(1:N, [1, 2*N-1:-1:N+1]);
    S = sparse(N^2, 2*N-1);
    i = (1:N^2)';
    j = C(:);
    idx = (j - 1).*N^2 + i;
    S(idx) = 1;
end