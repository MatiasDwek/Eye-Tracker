function ojo=encuentraojo(videoFrame)
    ojo=zeros(2,4);
    %Primero busco la cara frontal
    FaceDetector = vision.CascadeObjectDetector('FrontalFaceCART');   
    bbox = step(FaceDetector, videoFrame);
    
    if ~isempty(bbox) % Si no hay cara devuelvo error
        if length(bbox)>1
            [~,index]=max(bbox(:,4));%Busco la cara mas grande
            bbox=bbox(index,:);
        end
        %Recorto la cara
        
        for k=1:2 %Por cada ojo
            if k==1
                string='RightEye'; 
                EyeFrame=imcrop(videoFrame, [bbox(1,1),bbox(1,2),bbox(1,3)/2,bbox(1,4)/2]);
            else
                string='LeftEye';
                EyeFrame=imcrop(videoFrame, [bbox(1,1)+bbox(1,3)/2,bbox(1,2),bbox(1,3)/2,bbox(1,4)/2]);
            end
            
            EyesDetector = vision.CascadeObjectDetector(string);
            bboxojo = step(EyesDetector, EyeFrame);
            
            if ~isempty(bboxojo) %Encontro ojos?
                if length(bboxojo)>1 %Encontro mas de un ojo?
                    [~,index]=max(bboxojo(:,4));%Busco el ojo mas grande
                    bboxojo=bboxojo(index,:);
                end
                if k==1
                    ojo(k,:)=[bboxojo(1,1)+bbox(1,1),bboxojo(1,2)+bbox(1,2),bboxojo(1,3),bboxojo(1,4)];
                else
                    ojo(k,:)=[bboxojo(1,1)+bbox(1,1)+bbox(1,3)/2,bboxojo(1,2)+bbox(1,2),bboxojo(1,3),bboxojo(1,4)];
                end
            else
                ojo=[]; %No encontro ojos, necesito otra foto
                disp('no encuentra el ojo')
                break;
            end
        end
    else
       disp('no encontro la cara')
       ojo=[];
    end

end