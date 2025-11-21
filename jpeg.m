img = imread('paysage.jpg');

paysage1 = sprintf('image_%.2d.jpg',1); %(ou q est une qualité entre 1 et 100)
imwrite(img, paysage1, 'quality', 1)
info = imfinfo(sprintf('image_%.2d.jpg',1));  % remplace 'nom_fichier.jpg' par le nom réel
taille_octets = info.FileSize;
taille_bits = taille_octets * 8;
bpp = taille_bits / (size(img,1) * size(img,2));
disp(['1 : Nombre de bits par pixel : ', num2str(bpp)]);

paysage2 = sprintf('image_%.2d.jpg',2); %(ou q est une qualité entre 1 et 100)
imwrite(img, paysage2, 'quality', 2)
info = imfinfo(sprintf('image_%.2d.jpg',2));  % remplace 'nom_fichier.jpg' par le nom réel
taille_octets = info.FileSize;
taille_bits = taille_octets * 8;
bpp = taille_bits / (size(img,1) * size(img,2));
disp(['2 : Nombre de bits par pixel : ', num2str(bpp)]);

paysage5 = sprintf('image_%.2d.jpg',5); %(ou q est une qualité entre 1 et 100)
imwrite(img, paysage5, 'quality', 5)
info = imfinfo(sprintf('image_%.2d.jpg',5));  % remplace 'nom_fichier.jpg' par le nom réel
taille_octets = info.FileSize;
taille_bits = taille_octets * 8;
bpp = taille_bits / (size(img,1) * size(img,2));
disp(['5 : Nombre de bits par pixel : ', num2str(bpp)]);

paysage10 = sprintf('image_%.2d.jpg',10); %(ou q est une qualité entre 1 et 100)
imwrite(img, paysage10, 'quality', 10)
info = imfinfo(sprintf('image_%.2d.jpg',10));  % remplace 'nom_fichier.jpg' par le nom réel
taille_octets = info.FileSize;
taille_bits = taille_octets * 8;
bpp = taille_bits / (size(img,1) * size(img,2));
disp(['10 : Nombre de bits par pixel : ', num2str(bpp)]);

paysage25 = sprintf('image_%.2d.jpg',25); %(ou q est une qualité entre 1 et 100)
imwrite(img, paysage25, 'quality', 25)
info = imfinfo(sprintf('image_%.2d.jpg', 25));  % remplace 'nom_fichier.jpg' par le nom réel
taille_octets = info.FileSize;
taille_bits = taille_octets * 8;
bpp = taille_bits / (size(img,1) * size(img,2));
disp(['25 : Nombre de bits par pixel : ', num2str(bpp)]);

paysage50 = sprintf('image_%.2d.jpg',50); %(ou q est une qualité entre 1 et 100)
imwrite(img, paysage50, 'quality', 50)
info = imfinfo(sprintf('image_%.2d.jpg',50));  % remplace 'nom_fichier.jpg' par le nom réel
taille_octets = info.FileSize;
taille_bits = taille_octets * 8;
bpp = taille_bits / (size(img,1) * size(img,2));
disp(['50 : Nombre de bits par pixel : ', num2str(bpp)]);

paysage75 = sprintf('image_%.2d.jpg',75); %(ou q est une qualité entre 1 et 100)
imwrite(img, paysage75, 'quality', 75)
info = imfinfo(sprintf('image_%.2d.jpg',75));  % remplace 'nom_fichier.jpg' par le nom réel
taille_octets = info.FileSize;
taille_bits = taille_octets * 8;
bpp = taille_bits / (size(img,1) * size(img,2));
disp(['75 : Nombre de bits par pixel : ', num2str(bpp)]);
