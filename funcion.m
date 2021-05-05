%En este script tenemos la funcón principal para segmentar el hueso
%cortical y el trabecular

function [ cortical, trabecular ] = funcion( datasheet,corticalmin,corticalmax,trabecularmin,trabecularmax,detalle)

[volOrigen,spatial,dim] = dicomreadVolume(datasheet); %leer el volumen del datasheet
volOrigen = squeeze(volOrigen);

% ViewPnl = uipanel(figure,'Title','4-D Dicom Volume Original');
% volshow(V,'Colormap',colormap,'Alphamap',alphamap,'Parent',ViewPnl);

%%
capas = size(volOrigen, 3); %Obtenemos el tamaño de las tres dimensiones de V
stlX = 256;
stlCapas = 199;
cortical = zeros(stlX,stlX,stlCapas); %Creamos un matriz 3D de ceros con el tamaño de V
trabecular = zeros(stlX,stlX,stlCapas); %Creamos un matriz 3D de ceros con el tamaño de V
for capa=1:capas    %Recorremos todas las capas del volumen
    [capaCortical, capaTrabecular] = procesa_capa(volOrigen(:,:,capa),corticalmin,corticalmax,trabecularmin,trabecularmax,detalle);
    cortical(:,:,capa+1) = capaCortical;
    trabecular(:,:,capa+1) = capaTrabecular;
end
%%
% figure(5);
% sliceViewer(volOrigen);