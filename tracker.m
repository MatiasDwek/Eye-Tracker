%Modos:
% 0: resalta la posici�n de la pupila con el color elejido
% 1: movimiento del c�rculo verde con las pupilas, si dimensi�n es 0 en eje
% xy, si es 1 solo en eje x.
%Sensitivity:
% La sensibilidad como la detalla el paper.

if ~exist('cam', 'var')
    cam = webcam();
end
GuiOjos(cam);