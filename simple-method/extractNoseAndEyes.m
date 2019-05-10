function parts = extractNoseAndEyes(partsname,leye,reye,rotatedI)
% nose = extractNose(leye,reye,rotatedI);
% start from center of eye + 0.25eyeD
% end at eye+0.9eyeD
eyeD = norm([leye.x, leye.y]-[reye.x, reye.y]);

if (strcmpi(partsname,'nose'))
    xleft = round(leye.x);
    y1 = round(leye.y + 0.25*eyeD);
    y2 = round(leye.y + 0.9*eyeD);

    xright = round(reye.x);
    y3 = round(reye.y + 0.25*eyeD);
    y4 = round(reye.y + 0.9*eyeD);

else if (strcmpi(partsname,'eyes'))
    xleft = round(leye.x) - 0.2*eyeD;
    y1 = round(leye.y - 0.1*eyeD);
    y2 = round(leye.y + 0.1*eyeD);

    xright = round(reye.x)+ 0.2*eyeD;
    y3 = round(reye.y - 0.1*eyeD);
    y4 = round(reye.y + 0.1*eyeD);

    else
        error('Unknown parts');
    end
end

figure,
imshow(rotatedI);
hold on
plot(xleft, y1, '*');
plot(xleft, y2, '*');
plot(xright, y3, '*');
plot(xright, y4, '*');
hold off

parts = rotatedI(y1:y2,xleft:xright,:);
figure;
imshow(parts);
end

