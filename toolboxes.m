function flag = toolboxes(reqToolBoxes)

% Check if we have 'Computer Vision System Toolbox' and 'Image Processing Toolbox' 
% ver:  returns product information to the structure array, product_info.
productInfo = ver; 
itemNo = size(productInfo,2);

flag = zeros(1,length(reqToolBoxes));

for m = 1:length(reqToolBoxes)
    for n = 1:itemNo
        if (strcmpi(productInfo(1,n).Name, reqToolBoxes(1,m)))
            flag(1,m) = 1;
        end
    end
end

flag = prod(flag);

%             
% for i=1:i(2)
%  for j=1:reqSize
%   if( strcmpi(info(1,i).Name,requireToolBoxes{1,j}) )
%    flg(1,j)=1;
%   end
%  end
% end
% ret = prod(flg);
