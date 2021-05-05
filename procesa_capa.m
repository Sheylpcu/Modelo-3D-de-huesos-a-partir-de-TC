function [capaCortical, capaTrabecular] = procesa_capa(capa,corticalmin,corticalmax,trabecularmin,trabecularmax,detalle)
[X, Y] = size(capa);

corticalAux = zeros(X,Y);
trabecularAux = corticalAux;

capaCortical = corticalAux(128:383,128:383);
capaTrabecular = trabecularAux(128:383,128:383);

% Trasladamos los valores que cumplen el rango del cortical
corticalAux(capa>corticalmin & capa<corticalmax) = capa(capa>corticalmin & capa<corticalmax);

% se = strel('disk',4);
% corticalAux = imdilate(corticalAux, se);

[V2label, n] = bwlabel(corticalAux);
% Si la imagen no tiene zonas de hueso cortical, se descarta la capa
if(n==0)
    return
end

% Extraemos las regiones de hueso cortical
reg = regionprops(V2label,'BoundingBox');
for region=1:n
    FilaDesde = round(reg(region).BoundingBox(2));
    FilaHasta = round(reg(region).BoundingBox(2)) + round(reg(region).BoundingBox(4));
    ColumnaDesde = round(reg(region).BoundingBox(1));
    ColumnaHasta = round(reg(region).BoundingBox(1)) + round(reg(region).BoundingBox(3));
    
    % Trasladamos los valores de hueso trabecular que este dentro de la
    % region del hueso cortical
    trabecularAux(FilaDesde:FilaHasta, ColumnaDesde:ColumnaHasta) = capa(FilaDesde:FilaHasta, ColumnaDesde:ColumnaHasta);
    % Eliminamos los valores que no estan dentro del rango del hueso
    % trabecular
    trabecularAux(capa<trabecularmin | capa>=trabecularmax) = 0;
end

[V2label, n] = bwlabel(trabecularAux,8);
reg = regionprops(V2label,'BoundingBox');
for region=1:n
    tamano_region = reg(region).BoundingBox(3) * reg(region).BoundingBox(4);
    % Si el tamano de la region es menor al detalle la borramos
    if(tamano_region < detalle)
        FilaDesde = round(reg(region).BoundingBox(2));
        FilaHasta = round(reg(region).BoundingBox(2)) + round(reg(region).BoundingBox(4));
        ColumnaDesde = round(reg(region).BoundingBox(1));
        ColumnaHasta = round(reg(region).BoundingBox(1)) + round(reg(region).BoundingBox(3));
        % Borramos la region
        trabecularAux(FilaDesde:FilaHasta, ColumnaDesde:ColumnaHasta) = 0;
    end
end

% trabecularAux = imdilate(trabecularAux, se);

%capa+1 para dejar una capa vacía por debajo, para que isosurface
%genere bien la superficie
capaCortical = corticalAux(128:383,128:383);% se obtiene la región central de 256X256 de tamaño
capaTrabecular = trabecularAux(128:383,128:383);
end

