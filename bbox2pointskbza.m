function points=bbox2pointskbza(bbox)
%     bsize=size(bbox);
%     bsize=bsize(1,1);
%     for i=1:bsize
         points(1,1)=bbox(1,1);
         points(1,2)=bbox(1,2);
         points(2,1)=bbox(1,1)+bbox(1,3);
         points(2,2)=bbox(1,2);
         points(3,1)=bbox(1,1);
         points(3,2)=bbox(1,2)+bbox(1,4);
         points(4,1)=bbox(1,1)+bbox(1,3);
         points(4,2)=bbox(1,2)+bbox(1,4);
    
%     end


end