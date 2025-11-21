clc; clear; close all;

imTigre = imread('lena_512.gif');
imTigre_gray = imTigre; % double(rgb2gray(imTigre));
fft_imTigre = fftshift(fft2(imTigre_gray));

% Zero-padding du spectre
[p, q] = size(fft_imTigre);
disp(['taille originale : ', num2str(p), ' et ', num2str(q)])
agrandis = 3;

fft_big = zeros(agrandis*p, agrandis*q);
bordP = floor((agrandis * p - p)/2.0);
bordQ = floor((agrandis * q - q)/2.0);
fft_big(bordP+1 : bordP+p, bordQ+1 : bordQ+q) = fft_imTigre;

% Reconstruction
fft_big = ifftshift(fft_big);
im_big = real(ifft2(fft_big));

figure('Name','Agrandissement','Position',[100 100 1200 800]);

subplot(1,4,1);
imshow(imTigre_gray, []);
title('Image originale');

subplot(1,4,2);
imshow(im_big, []);
title('Image Agrandi');

subplot(1,4,3);
imshow(log(1+abs(fftshift(fft_big))), []);  % log pour mieux visualiser
colormap jet;
title('Module');

subplot(1,4,4);
imshow(angle(fftshift(fft_big)), []);
title('Phase');
