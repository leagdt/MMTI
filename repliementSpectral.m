
% Exercice 4. Aliasing
clc; clear; close all;


% Effectuez une décimation simple (prendre un point sur 2, 4, 8…) sur différentes images.

function imResult = reduceImage(n, im)
  imResult = im(1:2^n:end, 1:2^n:end, :);
end

% Paramètres
N = 25;           % nombre de bandes
res = 512;        % taille de l'image
img = zeros(res); % initialisation

% Coordonnées
[x, y] = meshgrid(1:res, 1:res);

% Angle de chaque pixel par rapport au coin en haut à gauche
theta = atan2(y, x);

% Motif sinusoïdal pour une transition douce entre bandes
imDecimation = 0.5 + 0.5 * sin(theta * N); % valeurs entre 0 (noir) et 1 (blanc)

imDecimation2 = reduceImage(1, imDecimation);
imDecimation8 = reduceImage(3, imDecimation);
imDecimation16 = reduceImage(4, imDecimation);

% --- Affichage ---
figure('Name', 'Decimation simple','Position',[100 100 1200 400]);

subplot(1,3,1);
imshow(imDecimation, []);
title('Originale');

subplot(1,3,2);
imshow(imDecimation8, []);  % log pour mieux visualiser
colormap jet;
title('Decimation 1/8');

subplot(1,3,3);
imshow(imDecimation16, []);
title('Decimation 1/16');



% Quelle forme prend ce phénomène sur les images décimées et sur les transformées de Fourier ?

imDecimation_fft = fft2(imDecimation);

% Module et phase
mod_deci = abs(fftshift(imDecimation_fft));   % module recentré
phase_deci = angle(fftshift(imDecimation_fft));          % phase

% --- Affichage ---
figure('Name','FFT Decimation original','Position',[100 100 1200 400]);

subplot(1,3,1);
imshow(imDecimation, []);
title('Image originale');

subplot(1,3,2);
imshow(log(1+mod_deci), []);  % log pour mieux visualiser
colormap jet;
title('Module');

subplot(1,3,3);
imshow(phase_deci, []);
title('Phase');

imDecimation8_fft = fft2(imDecimation8);

% Module et phase
mod_deci8 = abs(fftshift(imDecimation8_fft));   % module recentré
phase_deci8 = angle(fftshift(imDecimation8_fft));          % phase


% --- Affichage ---
figure('Name','FFT Decimation 1/8 pixels','Position',[100 100 1200 400]);

subplot(1,3,1);
imshow(imDecimation8, []);
title('Image originale');

subplot(1,3,2);
imshow(log(1+mod_deci8), []);  % log pour mieux visualiser
colormap jet;
title('Module');

subplot(1,3,3);
imshow(phase_deci8, []);
title('Phase');


% Résultat plus bruité, manque de structure, désorganisée, repliement spectrale


%%% Exercice 5. Filtrage passe-bas


% Masque passe-bas circulaire
[N, M] = size(imDecimation);
rayon = 30;

[x, y] = meshgrid(1:M, 1:N);
cx = floor(M/2); cy = floor(N/2);
masque = sqrt((x-cx).^2 + (y-cy).^2) < rayon;

imDecimation_fftshift = fftshift(imDecimation_fft);

imDecimation_fft_filtre = imDecimation_fftshift.* masque;

figure(10)
imDecimation_filtre = real(ifft2(ifftshift(imDecimation_fft_filtre)));
imshow(imDecimation_filtre, []);
title('Image filtrée (passe-bas sur la TF)');

figure('Name','Image avec Filtre passe Bas','Position',[100 100 1500 400]);

subplot(1,4,1);
imshow(imDecimation, []);
title('Image originale');

subplot(1,4,2);
imshow(log(1+imDecimation_fft_filtre), []);  % log pour mieux visualiser
colormap jet;
title('Amplitude de l image filtré');

subplot(1,4,3);
imshow(imDecimation_filtre, []);
title('Image filtrer');

imDecimation8_filtre = reduceImage(3, imDecimation_filtre);
subplot(1,4,4);
imshow(imDecimation8_filtre, []);
title('Image filtrer et réduite');

% Apparition d’oscillations, plus particulièrement autour des discontinuités :
% phénomène de Gibbs


% Filtre Gaussien transition plus lisse
N = 512; % nombre de lignes
M = 512; % nombre de colonnes
sigma = 10; % écart-type du filtre (largeur du passe-bas, à ajuster selon le besoin)

[x, y] = meshgrid(1:M, 1:N);
cx = floor(M/2);
cy = floor(N/2);

% Calcul de la distance au centre de l'image
d2 = (x - cx).^2 + (y - cy).^2;

% Masque gaussien en 2D
mask_gauss = exp(-d2/(2*sigma^2));

imDecimation_fft_filtre2 = imDecimation_fftshift.* mask_gauss;

imDecimation_filtre2 = real(ifft2(ifftshift(imDecimation_fft_filtre2)));

figure('Name','Image avec Filtre Gaussien passe Bas','Position',[100 100 1200 400]);

subplot(1,4,1);
imshow(imDecimation, []);
title('Image originale');

subplot(1,4,2);
imshow(log(1+imDecimation_fft_filtre2), []);  % log pour mieux visualiser
colormap jet;
title('Amplitude de l image filtré');

subplot(1,4,3);
imshow(imDecimation_filtre2, []);
title('Image filtrer');

imDecimation8_filtre2 = reduceImage(3, imDecimation_filtre2);
subplot(1,4,4);
imshow(imDecimation8_filtre2, []);
title('Image filtrer et réduite');

% Il n'y a plus d'apparition d'oscillations

% Filtre de Butterworth


% Paramètres du filtre Butterworth 2D
n = 1;           % ordre du filtre (2, 4, ...). Plus grand => transition plus raide
D0 = 0.01;       % cutoff en cycles/pixel (ajuster). 0.02 correspond à ≈ 10 cycles sur une image de 512 (0.02*512 ≈ 10)

% Construire la grille de fréquences (normalisée en cycles/pixel, de -0.5 à +0.5)
[u, v] = meshgrid( (-N/2:(N/2-1))/N , (-N/2:(N/2-1))/N ); % u = axe x (cols), v = axe y (rows)
D = sqrt(u.^2 + v.^2);    % distance radiale en cycles/pixel

% Réponse en amplitude Butterworth passe-bas (2D)
H = 1 ./ ( 1 + (D./D0).^(2*n) );

% Appliquer le filtre dans le domaine fréquentiel
F = fftshift( imDecimation_fft );  % fftshift pour centrer DC
G = H .* F;
g = real(ifft2(ifftshift(G)));

% Affichage
figure('Name','Image avec Filtre Butterworth 2D','Position',[100 100 1200 400]);
subplot(1,4,1);
imshow(imDecimation); title('Originale');
subplot(1,4,2);
imagesc(log(1+abs(F))); axis image; title('Amplitude de l image filtré'); colorbar;
subplot(1,4,3);
imshow(g, []); title(sprintf('Après Butterworth 2D (D0=%.4f, n=%d)', D0, n));

% Optionnel : visualiser le filtre H
%figure;
%imagesc(fftshift(H)); axis image; colorbar;
%title('Filtre Butterworth 2D (centré)');

imDecimation8_filtre2_1 = reduceImage(3, g);
subplot(1,4,4);
imshow(imDecimation8_filtre2_1, []);
title('Image filtrer et réduite');



