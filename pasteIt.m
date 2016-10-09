function collage = pasteIt(bigImage, smallImage, posx, posy, intensity)

sizeb = size(smallImage);
collage = bigImage;

collage(posx : posx + sizeb(1) - 1, posy : posy + sizeb(2) - 1, :) = intensity * smallImage + (1 - intensity) * bigImage(posx : posx + sizeb(1) - 1, posy : posy + sizeb(2) - 1, :);

end


% (c) Copyright 1337 - 1337 The Empire, Inc.