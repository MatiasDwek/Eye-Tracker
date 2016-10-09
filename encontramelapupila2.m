function pupila = encontramelapupila2(videoFrame, ojo,radiusEstimate)
%         ojo(1,1)=ojo(1,1)+ojo(1,3)/3;
%         ojo(1,3)=ojo(1,3)/3;
        ojosuelto = imcrop(videoFrame, ojo);
        dim = size(ojosuelto);
        im_width = dim(2);
        im_length = dim(1);
        %[ci,~] = thresh(ojosuelto,round(im_width/10),im_width); %ci:the parametrs[xc,yc,r]
        if isempty(radiusEstimate)
            ci = round(threshold(ojosuelto, ceil(im_length/6), round(im_width/4)));
        else
            ci = round(threshold(ojosuelto,floor(radiusEstimate*0.8),ceil(radiusEstimate*1.2)));
        end
        if ~isempty(ci) 
            if ci(3)>im_length/8
                centerx = ci(1);
                centery = ci(2);
                radius = ci(3);
             pupila(:,1) = ojo(:,1)+centery; %x1
             pupila(:,2) = ojo(:,2)+centerx; %y1
             pupila(:,3)= round(radius); %width
            else
                disp('pupila muy chica')
                pupila = [];
            end
        else
            disp('no encontró la pupila')
            pupila = [];
        end
end