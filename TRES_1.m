%%
close all
intensity = [0 20 40 120 220 1024]; %las distintas intensidades(valores,pixel,housfield) del conjunto
alpha = [0 0 0.15 0.3 0.38 0.5]; %la transparencia que aplica (0 completamente transparente - 1 completamente opaco)
color = ([0 0 0; 43 0 0; 103 37 20; 199 155 97; 216 213 201; 255 255 255])/ 255; %vector dematriz de 3x3 RGB para las intensidades
queryPoints = linspace(min(intensity),max(intensity),256);
alphamap = interp1(intensity,alpha,queryPoints)';
colormap = interp1(intensity,color,queryPoints);

[V2, V3]=funcion('./humero2',1500,3300,0,150,160);
%%
%Representación
ViewPnl2 = uipanel(figure,'Title','4-D Dicom Volume Cortical');
volshow(V2,'Colormap',colormap,'Alphamap',alphamap,'Parent',ViewPnl2);

ViewPnl3 = uipanel(figure,'Title','4-D Dicom Volume Trabecular');
volshow(V3,'Colormap',colormap,'Alphamap',alphamap,'Parent',ViewPnl3);

%%
% figure(5);
% sliceViewer(V3);
% volumeViewer(V);1580

%%
%Exportar .stl
stlwrite('Cortical.stl',isosurface(~V2)); % isosurface Saca la capa externa del volumen incluyendo la zona interior
stlwrite('trabecular.stl',isosurface(~V3));


