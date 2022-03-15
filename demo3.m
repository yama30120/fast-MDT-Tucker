% demo code for Fast-MDT-Tucker (Proposed method)
% complete 90% random voxel missing video image.
% the code shows figures:
%   figure1: original video
%   figure2: missing mri
%   figure3: recovered mri
%   figure4: behavior of the cost function and ranks.

clear all;
close all;

functionPath = 'Function_Fast_MDT_Tucker';
addpath(functionPath);

% pre-processing
vidObj = VideoReader('shuttle.avi');
frames = read(vidObj, [1 115]);
frames = frames(1:2:end, 1:2:end, :, :); % down sample 

missingRate = 0.9; % 90% random missing
sc = 255;
Qms = randomMissing(size(frames), missingRate);
T = double(frames) / sc;
Tms = T .* Qms;
tau = [8, 8, 1, 8];

% main processing (completion)
tic;
[Xest, F, hist, histR] = completion_fast_mdt_tucker(Tms, Qms, tau);
computing_time = toc;


% plotting processing and write result images
outputDir = './result/video/';

figure(4);
subplot(2, 1, 1);
iter = 1:length(hist);
plot(iter, hist);
hold on;
increased = logical(sum(abs(diff(histR)), 2));
p2 = plot(iter(increased), hist(increased), 'rx');
hold off;
legend(p2, {'increased'});
xlabel('Iteration');
ylabel('Cost function');

subplot(2, 1, 2);
plot(histR);
legend({'1st mode rank', '2nd mode rank', '3rd mode rank', '4th mode rank'}, 'Location', 'northwest');
xlabel('Iteration');
ylabel('Rank');

fprintf('--------------------\n');
fprintf('computing time: %.4f (seconds)\n', computing_time);
fprintf('PSNR: %.2f\n', psnr(T(:), Xest(:)));
fprintf('SSIM: %.4f\n', mssim(T(:), Xest(:)));

%% random missing function
% input
%  dim: the dimension of output tensor Q (0:missing / 1:observed)
%  rate: rate of missing (0-1) e.g. rate=0.9 -> 90% random missing
% output
%  Q: mask tensor (0:missing / 1:observed), its size is 'dim'
function Q = randomMissing(dim, rate)
    N = prod(dim);
    Q = zeros(dim);
    Q(randperm(N, floor(N*(1-rate)))) = 1;
end

%% mean SSIM
% input T, X
% output mean SSIM of frames between T and X
function ret = mssim(T, X)
    N = size(T, 4);
    ret = 0;
    for frame = 1:N
        ret = ret + ssim(T(:,:,:,frame), X(:,:,:,frame));
    end
    ret = ret / N;
end