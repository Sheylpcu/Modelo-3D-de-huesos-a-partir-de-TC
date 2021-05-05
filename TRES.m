%Se realiza lo mismo que en el programa uno.m, pero con el volumen total
%del datasheet.

% collection = dicomCollection('./DICOMDIR');

%%
[V,spatial,dim] = dicomreadVolume('./humero'); %leer el volumen del datasheet
V = squeeze(V);


intensity = [0 20 40 120 220 1024]; %las distintas intensidades(valores,pixel,housfield) del conjunto
alpha = [0 0 0.15 0.3 0.38 0.5]; %la transparencia que aplica (0 completamente transparente - 1 completamente opaco)
color = ([0 0 0; 43 0 0; 103 37 20; 199 155 97; 216 213 201; 255 255 255])/ 255; %vector dematriz de 3x3 RGB para las intensidades
queryPoints = linspace(min(intensity),max(intensity),256);
alphamap = interp1(intensity,alpha,queryPoints)';
colormap = interp1(intensity,color,queryPoints);

% ViewPnl = uipanel(figure,'Title','4-D Dicom Volume Original');
% volshow(V,'Colormap',colormap,'Alphamap',alphamap,'Parent',ViewPnl);

%%
[X, Y, capas] = size(V); %Obtenemos el tamaño de las tres dimensiones de V
stlX = 256;
stlY = 256;
stlCapas = 199;
V2 = zeros(stlX,stlX,stlCapas); %Creamos un matriz 3D de ceros con el tamaño de V
V3 = zeros(stlX,stlX,stlCapas); %Creamos un matriz 3D de ceros con el tamaño de V
for capa=1:capas    %Recorremos todas las capas del volumen
    
    V2aux = zeros(X,Y);
    V3aux = V2aux;
    Vaux = V(:,:,capa);
    
    
    V2aux(Vaux>1500 & Vaux<3000) = Vaux(Vaux>1500 & Vaux<3000);
    se = strel('disk',4);
    V2aux = imdilate(V2aux, se);
    V2label = bwlabel(V2aux);
    %capa
    reg = regionprops(V2label,'BoundingBox');
    
    FilaDesde = round(reg.BoundingBox(1));
    FilaHasta = round(reg.BoundingBox(1)) + round(reg.BoundingBox(4));
    ColumnaDesde = round(reg.BoundingBox(1));
    ColumnaHasta = round(reg.BoundingBox(1)) + round(reg.BoundingBox(4));
    
    V3aux(FilaDesde:FilaHasta, ColumnaDesde:ColumnaHasta) = Vaux(FilaDesde:FilaHasta, ColumnaDesde:ColumnaHasta);
    %se = strel('disk',3);
    V3aux(Vaux<0 | Vaux>=150) = 0; %eliminamos lo que no tenga esos valores
    V3aux = imopen(V3aux,se);
    
    %capa+1 para dejar una capa vacía por debajo, para que isosurface
    %genere bien la superficie
    V2(:,:,capa+1) = V2aux(128:383,128:383);% se obtiene la región central de 256X256 de tamaño 
    V3(:,:,capa+1) = V3aux(128:383,128:383);
end

%%
%Representación
ViewPnl2 = uipanel(figure,'Title','4-D Dicom Volume Cortical');
volshow(V2,'Colormap',colormap,'Alphamap',alphamap,'Parent',ViewPnl2);

ViewPnl3 = uipanel(figure,'Title','4-D Dicom Volume Trabecular');
volshow(V3,'Colormap',colormap,'Alphamap',alphamap,'Parent',ViewPnl3);

%%
% figure(5);
%sliceViewer(V)
%volumeViewer(V);

%%
% %Exportar .stl
stlwrite('Cortical.stl',isosurface(~V2)); % isosurface Saca la capa externa del volumen incluyendo la zona interior
stlwrite('trabecular.stl',isosurface(~V3));


