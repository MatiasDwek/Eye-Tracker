function [ojo,centro,radio,videoFrame]=PupilFinder(cam)
    ojo=[];
    pupila1=[];pupila2=[];
    centro=zeros(2,2);
    while isempty(pupila1) || isempty(pupila2)
        videoFrame = snapshot(cam);
        imshow(videoFrame);
        ojo=encuentraojo(videoFrame);
        if ~isempty(ojo)
            disp('buscando pupilas')
            pupila1=encontramelapupila2(videoFrame,ojo(1,:),[]);
            pupila2=encontramelapupila2(videoFrame,ojo(2,:),[]);
        end
    end
    centro(1,:)=pupila1(1:2);
    centro(2,:)=pupila2(1:2);
    radio(1)=pupila1(3);
    radio(2)=pupila2(3);
end