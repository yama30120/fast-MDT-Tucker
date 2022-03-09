function [X, F, histo, histoR] = completion_fast_mdt_tucker(T, Q, tau, param)
% function [X, F, histo, histoR] = completion_fast_mdt_tucker(T, Q, tau, param)
% low-rank tensor completion in embedded space with rank increment
% this function deals with N-th order tensor
%
% input:
%  T: missing (original) tensor
%  Q: mask tensor (0: missing / 1: not missing)
%  tau: delay window size (vector (1 x N))
%  param: (optional variable)
%    -- delta: convergence threthold of cost function ||Q .* (T - X)||_F^2 < delta
%              (default 1e-8)
%    -- incR: cell vector of lists of each mode ranks
%             e.g. incR{1} = [1, 2, ..., tau_1]
%             (default one by one, [1, 2, 3, 4, 5, ..., tau_1])
%    -- maxiter: maximum number of iterations estimating X
%                (default 10000)
%    -- inloop: number of iteration updating F_i in each iteration
%               (default 1)
%    -- tol: convergence threthold of difference to previous cost in each rank iteration
%            (default 1e-4)
%    -- verb: interval of logging cost and cost_diff. Not printing logs when verb=0
%             (default 1)
%
% output:
%  X: estimated tensor after completion
%  F: estimated each mode's factor tensor after completion
%  histo: history of the cost in each iteration
%  histoR history of the rank along the all odd modes in each iteration

    order   = length(tau);
    % check optional parameters
    if nargin == 3
        % default values
        delta   = 1e-8;
        maxiter = 10000;
        inloop  = 1;
        tol     = 1e-4;
        verb    = 1;
        incR    = cell(1, order);
        for n = 1:order
            incR{n} = 1:tau(n);
        end
    else
        if isfield(param,'delta'),   delta   = param.delta;   else, delta   = 1e-8;  end
        if isfield(param,'maxiter'), maxiter = param.maxiter; else, maxiter = 10000; end
        if isfield(param,'inloop'),  inloop  = param.inloop;  else, inloop  = 1;     end
        if isfield(param,'tol'),     tol     = param.tol;     else, tol     = 1e-4;  end
        if isfield(param,'verb'),    verb    = param.verb;    else, verb    = 1;     end
        if isfield(param,'incR')
            incR = param.incR;
        else
            incR    = cell(1, order);
            for n = 1:order
                incR{n} = 1:tau(n);
            end
        end
    end

    X = rand(size(T));
    F = cell(1, order);
    for n = 1:order
        F{n} = orth(randn(tau(n), incR{n}(1)));
    end
    
    [X, F, histo, histoR] = fast_mdt_tucker_rank_inc(T, Q, X, F, order, delta, incR, maxiter, inloop, tol, verb);
end