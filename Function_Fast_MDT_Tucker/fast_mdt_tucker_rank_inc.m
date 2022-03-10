function [X, F, histo, histoR] = fast_mdt_tucker_rank_inc(T,Q,X,F,order,delta,incR,maxiter,inloop,tol,verb)
% function [X, F, histo, histoR] = fast_mdt_tucker_rank_inc(T,Q,X,F,order,delta,incR,maxiter,inloop,tol,verb)
% low-rank tensor completion in embedded space with rank increment
% this function deals with N-th order tensor
%
% input:
%  T: missing (original) tensor
%  Q: mask tensor (0: missing / 1: not missing)
%  X: initial estimated tensor (same size of T and Q)
%     e.g. X = rand(size(T))
%  F: cell of factor matrixs, (those size are tau_i x R_(2*i-1) i = 1, ..., N)
%              tau_i is size of delay embedding window
%              R_i is rank of the mode i
%  order: order of tensor T, Q, and X
%  delta: convergence threthold of cost function ||Q .* (T - X)||_F^2 < delta
%  incR: cell vector of lists of each mode ranks
%        e.g. incR{1} = [1, 2, ..., tau_1]
%  maxiter: maximum number of iterations updating X
%  inloop: number of iteration updating F_i in each iteration
%  tol: convergence threthold of difference to previous cost in each rank iteration
%  verb: interval of logging cost and cost_diff
%
% output:
%  X: estimated tensor after completion
%  F: estimated each mode's factor tensor after completion
%  histo: history of cost in each iteration
%  histoR history of rank increment in each iteration
    
    if order == 1
        order = 2;
        F{2} = 1;
        incR{2} = 1;
    end
    dimT = ones(1, order);
    for n = 1:order
        dimT(n) = size(T, n);
    end
    tau = ones(order, 1);
    for n = 1:order
        [tau(n), ~] = size(F{n});
    end
    
    ridx = ones(1, order); % rank increment index array
    
    C = cell(order, 1);
    for n = 1:order
        C{n} = duplication_matrix_for_toeplitz_matrix(tau(n));
    end
    
    % to simplify updating F_n * F_n^T
    FFt = cell(order, 1);
    for n = 1:order
        FFt{n} = F{n} * F{n}.';
    end
    
    % to record history of cost and rank
    histo = zeros(maxiter, 1);
    histoR = zeros(maxiter, order);
    
    obj1 = norm(T(Q(:)==1) - X(Q(:)==1))^2 / sum(Q(:));
    for iter = 1:maxiter
        % Z = Q.*T + Qc.*X;
        Z = T;
        Z(Q(:)~=1) = X(Q(:)~=1);

        % update F1, F2,..., Fn
        Zfft = ifftn(Z);
        Zs = real(fftn(abs(Zfft).^2));
        dimZs = dimT;
        for n = 1:order
            [Zs, dimZs] = cutTensor(Zs, dimZs, n, [1:tau(n), (dimT(n) - tau(n) + 2):dimT(n)]);
        end
        for iter2 = 1:inloop
            % update Fn
            for n = 1:order
                tmp = Zs;
                dimTmp = tau.' * 2 - 1;
                for m = 1:order
                    if m == n, continue; end
                    [tmp, dimTmp, ~] = tmult(tmp, full(FFt{m}(:).'*C{m}), m, dimTmp);
                end
                HHt = reshape(C{n} * tmp(:), tau(n), tau(n));
                [F{n}, ~, ~] = svds(HHt, incR{n}(ridx(n)));
                FFt{n} = F{n} * F{n}.';
            end
        end
        
        % update X
        % X <- H^(-1)[H[Z] x^{odd} {FF^T}]
        kronF = 1;
        for n = 1:order
            tmp = fft([F{n}; zeros(dimT(n)-tau(n), incR{n}(ridx(n)))]);
            tmp = sum(abs(tmp).^2, 2);
            kronF = kron(tmp, kronF);
        end
        kronF = reshape(kronF, dimT);
        X = real(fftn(kronF .* Zfft)) / prod(tau);

        obj2 = norm(T(Q(:)==1) - X(Q(:)==1))^2 / sum(Q(:));
        
        histo(iter) = obj2;
        for n = 1:order
            histoR(iter, n) = incR{n}(ridx(n));
        end

        % show process
        if mod(iter,verb) == 0
            fprintf('iter %d:: cost = %e :: cost_diff = %e :: R=[',iter,obj2,abs(obj2-obj1));
            for n = 1:order
                fprintf('%d ',histoR(iter, n));
            end
            fprintf('] \n');
        end
        
        % rank increment
        if iter > 3 && abs(obj2 - obj1) < tol
            % compute each residual
            residual = zeros(order, 1);
            Z = Q .* (T - X);
            Zfft = ifftn(Z);
            Zs = real(fftn(abs(Zfft).^2));
            dimZs = dimT;
            for n = 1:order
                [Zs, dimZs] = cutTensor(Zs, dimZs, n, [1:tau(n), dimT(n):-1:(dimT(n)-tau(n)+2)]);
            end
            for n = 1:order
                tmp = Zs;
                dimTmp = tau.' * 2 - 1;
                for m = 1:order
                    if m == n, continue; end
                    [tmp, dimTmp, ~] = tmult(tmp, full(FFt{m}(:).'*C{m}), m, dimTmp);
                end
                residual(n) = tmp(1) * tau(n);
            end
            
            % to select a mode that is most likely to reduce cost when increasing the mode's rank
            [~, maxid] = max(residual);
            ridx(maxid) = min(ridx(maxid)+1, length(incR{maxid}));
        end
        
        obj1 = obj2;
        
        if obj2 < delta
            break;
        end
    end
    
    % to erase unnecessary space of history array
    histo = histo(1:iter);
    histoR = histoR(1:iter, :);
end