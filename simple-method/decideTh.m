function Th = decideTh(varI)
% Decide the binarizing threshold of an image

varI = round(varI/1000);
switch (varI)
    case 0
        Th = 0.85
    case 1
        Th = 0.8;
    case 2
        Th = 0.7;
    case 3
        Th = 0.6;
    case 4
        Th = 0.55;
    case 5
        Th = 0.15;
    otherwise
        Th = 0.15;
end

end

