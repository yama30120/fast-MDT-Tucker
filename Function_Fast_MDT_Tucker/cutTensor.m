function [Y, dimY] = cutTensor(X, dimX, mode, idx)
    N = length(dimX);
    if N == 1
        Y = X(idx);
        dimY = length(Y);
    else
        perm = [mode, 1:mode-1, mode+1:N];
        Y = permute(X, perm);
        Y = reshape(Y, dimX(mode), []);
        Y = Y(idx, :);
        dimY = dimX;
        dimY(mode) = length(idx);
        Y = reshape(Y, dimY(perm));
        iperm = [2:mode, 1, mode+1:N];
        Y = permute(Y, iperm);
    end
end