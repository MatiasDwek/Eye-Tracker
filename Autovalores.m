function [pjder,pjizq,ojo,centro,radio,videoFrame]=Autovalores(cam)
    pjder=[]; pjizq=[];
    %Obtengo ojos
    while isempty(pjder) || isempty(pjizq)
        [ojo,centro,radio,videoFrame]=PupilFinder(cam);
        disp('Buscando Autovalores')
        rgbFrame=rgb2gray(videoFrame);
        pjder = detectMinEigenFeatures(rgbFrame, 'ROI', ojo(1,:));
        pjizq = detectMinEigenFeatures(rgbFrame, 'ROI', ojo(2,:));
    end
    
end