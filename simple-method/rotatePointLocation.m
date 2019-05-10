function outPt = rotatePointLocation(inPt,center,m)
% Calculate the location of a point after rotation
% inPt: a struct for storing the info of pt
% m: degree
x = inPt.x - center.x;
y = inPt.y - center.y;
outPt.x = x*cosd(m)+y*sind(m)+center.x;
outPt.y = -x*sind(m)+y*cosd(m)+center.y;
end

