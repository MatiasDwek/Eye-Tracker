function [visiblePoints,lost]=SeguirFrame(videoFrame,Tracker,oldPoints)
    lost=0;
    [points, isFound] = step(Tracker, videoFrame);
    backup=oldPoints;
    visiblePoints = points(isFound, :);
    oldInliers = oldPoints(isFound, :);
   
    if size(visiblePoints, 1) >= 2 %se necesitan mas de 2 puntos
        % Estimate the geometric transformation between the old points
        % and the new points and eliminate outliers
         [~, ~, visiblePoints] = estimateGeometricTransform(oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);
%         bboxPoints = transformPointsForward(xform, bbox2points(bbox));
%         bbox=boxojo(bboxPoints);
        setPoints(Tracker, visiblePoints);
    else
       lost=1;
       visiblePoints=backup;
    end
end