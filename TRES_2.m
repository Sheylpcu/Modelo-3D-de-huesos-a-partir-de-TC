%De prueba
close all
I = dicomread('./falange1/phalanx1-3.dcm');
figure(1);
imshow(I,[]);

[cortical,trabecular] = procesa_capa(I,1500,3300,0,150,160);

% figure(2);
% imshow(cortical,[]);

figure(3);
imshow(trabecular,[]);