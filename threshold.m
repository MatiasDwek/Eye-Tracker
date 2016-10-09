function ci = threshold(data, rmin, rmax)
% Convertir la imagen a grayscale
diff_im = rgb2gray(data);
% Filtrar ruido
diff_im = medfilt2(diff_im, [3 3]);
try
diff_im = histeq(diff_im, round(length(diff_im)/4));
catch
end
% diff_im = (double(diff_im)/255) .^ .3;
% Pasar imagen de grayscale a binaria
diff_im = im2bw(diff_im,0.17);
%[centers,radii,metric] = imfindcircles(diff_im, [rmin rmax], 'ObjectPolarity', 'dark', 'Sensitivity', 1, 'EdgeThreshold',0.9);

if (round(rmin) > 1) && (round(rmax) > round(rmin))
    warning('OFF');
    try
        [centers, radii, ~] = imfindcircles(diff_im, [rmin rmax], 'ObjectPolarity', 'dark', 'Sensitivity', 1);
    catch
        ci = [];
        return
    end
    warning('ON');
    if ~isempty(centers)
%         if length(radii) > 1
%             if radii(2) < radii(1)
%                 ci(1) = centers(1,2);
%                 ci(2) = centers(1,1);
%                 ci(3) = radii(1);
%             else
%                 ci(1) = centers(2,2);
%                 ci(2) = centers(2,1);
%                 ci(3) = radii(2);
%             end
%         else
%             ci(1) = centers(1,2);
%             ci(2) = centers(1,1);
%             ci(3) = radii(1);
%         end
                 ci(1) = centers(1,2);
                 ci(2) = centers(1,1);
                 ci(3) = radii(1);
                 
                 
%                stricty = 0.1;
%                strictx = 0.4;
%                dim = size(data);
%                
%                polygony = [dim(1)*stricty dim(1)*(1-stricty)];
%                polygonx = [dim(2)*strictx dim(2)*(1-strictx)];
%                in = inpolygon(ci(2), ci(1), polygonx, polygony);
%                
%                 if ~in
%                    if (length(radii) > 1)
%                         ci(1) = centers(2,2);
%                         ci(2) = centers(2,1);
%                         ci(3) = radii(2);
%                    else 
%                        ci = [];
%                    end
%                 end
% 
%                yellow = uint8([255 255 0]);
%                shapeInserter = vision.ShapeInserter('Shape','Circles','BorderColor','Custom','CustomBorderColor',yellow);
%                circle = int32([round(ci(2)) round(ci(1)) round(ci(3))]); %  [x1 y1 radius1]
%                %RGB = repmat(data,[1,1,3]); % convert I to an RGB image
%                J = step(shapeInserter, data, circle);
%                imshow(J);
               
    else
        ci = [];
    end
else
    ci = [];
    
end

