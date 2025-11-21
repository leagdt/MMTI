% Exercice 3. Fourier – Image
clc; clear; close all;

N = 255;
d_init = 50;
theta_init = 0;

f = figure('Name','Pixels symétriques et IFFT','Position',[100,100,900,400]);

% Axes pour afficher l'image IFFT (angle)

ax1 = subplot(1,3,1);
h_img = imshow(zeros(N,N), []);
title(ax1,'IFFT de l’image');

% Axes pour afficher le spectre (points activés)
ax2 = subplot(1,3,2);
h_spec = imshow(zeros(N,N), []);
title(ax2,'Image "spectre"');

% Axes pour le mesh
ax3 = subplot(1,3,3);
h_mesh = mesh(ax3, zeros(N,N));
title(ax3,'IFFT de l image en 3D');

% --- Sliders pour d et theta ---
uicontrol('Style','text','Position',[50 20 100 20],'String','Distance d');
slider_d = uicontrol('Style','slider','Min',1,'Max',N/2,'Value',d_init,...
                     'Position',[150 20 200 20]);

uicontrol('Style','text','Position',[400 20 100 20],'String','Angle θ (°)');
slider_theta = uicontrol('Style','slider','Min',0,'Max',360,'Value',theta_init,...
                         'Position',[500 20 200 20]);

% --- Structure pour stocker handles ---
handles.N = N;
handles.h_img = h_img;
handles.h_spec = h_spec;
handles.h_mesh = h_mesh;
handles.ax3 = ax3;
handles.slider_d = slider_d;
handles.slider_theta = slider_theta;

% --- Callback anonyme ---
set(slider_d, 'Callback', @(src,event) update_image(handles, ax1));
set(slider_theta, 'Callback', @(src,event) update_image(handles, ax1));

% --- Fonction update_image ---
function update_image(handles, ax1)
    N = handles.N;

    % récupérer les valeurs des sliders
    d = get(handles.slider_d,'Value');
    theta = get(handles.slider_theta,'Value');
    theta_rad = theta * pi / 180;

    xc = N/2;
    yc = N/2;

    x1 = round(xc + d*cos(theta_rad));
    y1 = round(yc + d*sin(theta_rad));
    x2 = round(xc - d*cos(theta_rad));
    y2 = round(yc - d*sin(theta_rad));

    % créer l'image spectre
    img = zeros(N,N);
    img(y1,x1) = 1;
    img(y2,x2) = 1;
    img(127, 127) = 127;

    % Transformée de Fourier inverse
    iTF = ifft2(img);

    % Mise à jour des images
    set(handles.h_spec, 'CData', img);
    Z = abs(ifftshift(iTF));
    imshow(Z, [], 'Parent', ax1);
    title(ax1,'IFFT de l’image');

    % Mise à jour du mesh
    set(handles.h_mesh, 'ZData', Z, 'CData', Z);

    drawnow;
end

% --- Initialiser la figure ---
update_image(handles, ax1);

% On obtient un cosinus.


% Avec un secteur angulaire :
rows = 200;
cols = 300;

width = 40;
height = 10;

% --- Créer l'image rectangulaire ---
imgRect = zeros(rows, cols);
imgRect(100 - width:100+ width, 150-height:150+height) = 1;

% --- Transformée de Fourier inverse ---
iTFRect = ifft2(imgRect);

% --- Créer une figure avec 3 subplots ---
figure('Name','FFT et IFFT Rectangle','Position',[100 100 1200 400]);

% Image originale
subplot(1,3,1);
imshow(imgRect, []);
title('Image originale');

% Mesh 3D de l'amplitude
subplot(1,3,2);
mesh(abs(ifftshift(iTFRect)));
title('Amplitude IFFT (mesh)');
colormap jet; shading interp;

% Image de l'amplitude IFFT
subplot(1,3,3);
imshow(abs(ifftshift(iTFRect)), []);
title('Amplitude IFFT (image)');

% On obtient un sinus cardinal si le rectangle est vertical le sinus cardinal
% sera étiré horizontalement.


%Avec un disque :
N = 256;       % taille de l'image NxN
r = 5;        % rayon du disque

[x, y] = meshgrid(1:N, 1:N);
xc = N/2;
yc = N/2;

dist = sqrt((x - xc).^2 + (y - yc).^2);

imgDisque = zeros(N, N);
imgDisque(dist <= r) = 1;

% --- Transformée de Fourier inverse ---
iTFDisque = ifft2(imgDisque);

% Affichage
% --- Créer une figure avec 3 subplots ---
figure('Name','FFT et IFFT Disque','Position',[100 100 1200 400]);

% Image originale
subplot(1,3,1);
imshow(imgDisque, []);
title('Image originale');

% Mesh 3D de l'amplitude
subplot(1,3,2);
mesh(abs(ifftshift(iTFDisque)));
title('Amplitude IFFT (mesh)');
colormap jet; shading interp;

% Image de l'amplitude IFFT
subplot(1,3,3);
imshow(abs(ifftshift(iTFDisque)), []);
title('Amplitude IFFT (image)');

% On obtient une sorte de sinus cardinal qui a tourner autour de l'axe Z



%Calculez le module et la phase de la transformée de Fourier d’une image.

imLena=imread('lena_512.gif');


% Si l'image est couleur, convertir en gris
if size(imLena,3) == 3
    imLena = rgb2gray(imLena);
end

% FFT 2D
lena_fft = fft2(double(imLena));

% Module et phase
mod_lena = abs(fftshift(lena_fft));   % module recentré
phase_lena = angle(fftshift(lena_fft));          % phase

% --- Affichage ---
figure('Name','FFT Lena','Position',[100 100 1200 400]);

subplot(1,3,1);
imshow(imLena, []);
title('Image originale');

subplot(1,3,2);
imshow(log(1+mod_lena), []);  % log pour mieux visualiser
colormap jet;
title('Module');

subplot(1,3,3);
imshow(phase_lena, []);
title('Phase');

% Modifiez la phase pour la rendre aléatoire et calculez la transformée inverse.
[N,M] = size(lena_fft);
phase_random = -pi + 2*pi*rand(N,M);

lena_fft_randomPhase = mod_lena .* exp(1i * phase_random);

lena_ifft_randomPhase = ifft2(lena_fft_randomPhase);

figure(5);
imshow(abs(ifftshift(lena_ifft_randomPhase)), []);
title('Amplitude IFFT de lena avec phase random');

% Ici on conserve le contraste mais on perd toutes les infos de localisations
% Donc l'image n'a plus rien avoir avec l'image de lena d'origine

% Essayez ensuite avec une phase constante puis un module constant.
phase_const = zeros(N, M);

lena_fft_cstPhase = mod_lena .* exp(1i * phase_const);

lena_ifft_cstPhase = ifft2(lena_fft_cstPhase);

figure(6);
imshow(abs(ifftshift(lena_ifft_cstPhase)), []);
title('Amplitude IFFT de lena avec phase constante');

% On obtient une image noir avec une concentration de blanc au centre de l'image.
% Cela est du au fait qu'on perd l'information de localisations et donc que toutes
% les fréquences sont centré, il n'y a pas de décalage de phase.

mod_const = ones(N, M);

lena_fft_cstMod = mod_const .* exp(1i * phase_lena);

lena_ifft_cstMod = ifft2(lena_fft_cstMod);

figure(7);
imshow(abs((lena_ifft_cstMod)), []);
title('Amplitude constant avec phase IFFT de lena');
% Ici on voit apparaître quelques contours mais on perd toute l'information sur
% l'intensité de la fréquence.


%%% Prenez deux images dont vous échangez la phase de la transformée de Fourier.

% --- Créer l'image rectangulaire ---
imgRect2 = zeros(512, 512);
w = 40;
h = 40;
imgRect2(100 - w:100+ w, 150-h:150+h) = 1;

imgRect_fft = fft2(imgRect2);

% Module et phase
mod_rect = abs(fftshift(imgRect_fft));   % module recentré
phase_rect = angle(fftshift(imgRect_fft));          % phase

melange_fft_image = mod_rect .* exp(1i * phase_lena);

melange_ifft_image = ifft2(melange_fft_image);

figure(8);
imshow(abs((melange_ifft_image)), []);
title('Module image rectangle et phase image lena');
% Perte de l'information le localisation du rectangle
% Conservation des contours de lena
% Conservation des amplitudes des fréquences du rectangle

melange_fft_image2 = mod_lena .* exp(1i * phase_rect);

melange_ifft_image2 = ifft2(melange_fft_image2);

figure(9);
imshow(abs((melange_ifft_image2)), []);
title('Module image lena et phase image rectangle');

% Conservation des contours du rectangle avec les intensités de lena


