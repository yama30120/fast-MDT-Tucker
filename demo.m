% demo code for Fast-MDT-Tucker (Proposed method)
% complete 90% random voxel missing airplane image.
% the code shows two figures:
%   figure1: three images (original, missing, and completed)
%   figure2: behavior of the cost function and ranks.

clear all;
close all;

function_path = 'Function_Fast_MDT_Tucker';
addpath(function_path);

% pre-process
% X0 is original data
% Q is mask data. 0 or 1
% Xms is missing data. X0 .* Q
load('./data/airplane_90_missing.mat');
% load('./data/airplane_95_missing.mat');

sc = 255;
T = double(X0) / sc;
Tms = double(Xms) / sc;
Qms = Q;
tau = [32, 32, 1];

% main process (completion)
tic;
[Xest, F, hist, histR] = completion_fast_mdt_tucker(Tms, Qms, tau);
computing_time = toc;

% plotting process

figure(1);
subplot(1, 3, 1);
imshow(uint8(T*sc));
title('Original');

subplot(1, 3, 2);
imshow(uint8(Tms*sc));
title('Missing');

subplot(1, 3, 3);
imshow(uint8(Xest*sc));
title('Completed');

figure(2);
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
legend({'1st mode rank', '3rd mode rank'}, 'Location', 'northwest');
xlabel('Iteration');
ylabel('Rank (odd modes)');

fprintf('--------------------\n');
fprintf('computing time: %.4f (seconds)\n', computing_time);
fprintf('PSNR: %.2f\n', psnr(T, Xest));
fprintf('SSIM: %.4f\n', ssim(T, Xest));

% rmpath(function_path);