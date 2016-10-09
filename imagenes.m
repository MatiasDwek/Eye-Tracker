bigImage = imread('kernighan.jpg');
smallImage = imread('pollo.jpg');

sizeBigImage = size(bigImage);
sizeSmallImage = size(smallImage);

%warning: only use in case you want to trip
intensity = 1; %you should probably expect it to work exponentially so use
%a fancy logarithm you bloody rascal

% Scale is only performed on the x axis, so dimensions are kept. If you
%don't like don't use it dumbass
wantedSizex = 200;
scale = sizeSmallImage(1) / wantedSizex;

% Rotations is in degrees. The previous programmer coded it in gradians.
%He doesn't work here anymore.
angle = 45;
smallImage = imrotate(smallImage, angle);

smallImage = imresize(smallImage, 2);

% Here the positions are preset to the center but you can choose wathever
% you want, remember that pasteIt won't check for errors if you paste
% something outside bigImage
centerx = round(sizeBigImage(1) / 2);
centery = round(sizeBigImage(2) / 2);

processedImage = pasteIt(bigImage, smallImage, centerx, centery, intensity);

for n1 = 1:sizeBigImage(1)
    for n2 = 1:sizeBigImage(2)
        for n3 = 1:sizeBigImage(3)
            if processedImage(n1, n2, n3) == 0
                processedImage(n1, n2, n3) = bigImage(n1, n2, n3);
            end
        end
    end
end

imshow(processedImage)

