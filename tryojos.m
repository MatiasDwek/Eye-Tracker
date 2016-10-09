figure(1)
ojo=[];
while isempty(ojo)
    videoFrame = snapshot(cam);
    imshow(videoFrame)
    ojo=encuentraojo(videoFrame);
end

    videoFrame = insertShape(videoFrame, 'Rectangle', ojo(1,:),'Color',[1,0,0]);
    videoFrame = insertShape(videoFrame, 'Rectangle', ojo(2,:),'Color',[0,0,1]);
imshow(videoFrame)