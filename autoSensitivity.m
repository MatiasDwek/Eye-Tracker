function k = autoSensitivity(videoFrame, ojo)
        number_attemps = 11; % where 1 - (11 - 1)/20, number_attempts < 21

        ojosuelto = imcrop(videoFrame, ojo);
        dim = size(ojosuelto);
        im_width = dim(2);
        im_length = dim(1);
        [ci_integro, ~] = thresh(ojosuelto,round(im_width/10),im_width); %ci:the parametrs[xc,yc,r]
        ci_matrix = zeros(number_attemps, 3);
        for n = 1:number_attemps
            ci = threshold(ojosuelto, 1, im_width, 1 - (n - 1)/ 20);
            if ~isempty(ci)
                if eyeposerror(ci(1), ci(2), ci(3), im_width, im_length) || (maxiterations > 10)
                    ci_matrix(n, 1) = ci(1);
                    ci_matrix(n, 2) = ci(2);
                end
            end
            ci_matrix(n, 3) = sqrt((ci_matrix(n, 1) - ci_integro(1))^2 + (ci_matrix(n, 2) - ci_integro(2))^2);
        end
        
        [~, n] = min(ci_matrix(:,3));
        k = 1 - (n - 1)/ 20;
        disp(k)
        ci_matrix(:, 3)
end