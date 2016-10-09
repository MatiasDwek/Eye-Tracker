function bbox=boxojo(puntos)
    minx=min(puntos(:,1)); 
    maxx=max(puntos(:,1));
    width=maxx-minx;
    miny=min(puntos(:,2)); 
    maxy=max(puntos(:,2));
    heigth=maxy-miny;
    bbox=ceil([minx,miny,width,heigth]);
end