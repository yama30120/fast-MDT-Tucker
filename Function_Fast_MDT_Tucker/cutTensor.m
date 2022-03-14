function [Y, dimY] = cutTensor(X, dimX, mode, idx)
% input:
%  X: input tensor
%  dimX: dimension of X
%  mode: mode to index
%  idx: index in mode
% output:
%  Y: cut tensor by idx in the mode
%  dimY: dimension of Y
% e.g.
%  3rd order tensor (2 x 2 x 3)
%  X = reshape(1:12, [2 2 3])
%    = [1 3;  [5 7;  [ 9 11;
%       2 4],  6 8], [10 12]
%  cutTensor(X, [2 2 3], 3, [1 3]):
%  Y = [1 3;  [ 9 11;
%       2 4], [10 12]
%  dimY = [2 2 2]
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