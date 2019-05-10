function newGl = colorTemp(gl,kColorT)
% newGl = colorTemp(ExtractedI,kColorT);
newGl = gl;
newGl(:,:,1) = newGl(:,:,1).*(kColorT(1));
newGl(:,:,2) = newGl(:,:,2).*(kColorT(2));
newGl(:,:,3) = newGl(:,:,3).*(kColorT(3));
newGl = uint8(newGl);
figure,
imshow(gl);
figure,
imshow(newGl);
end

