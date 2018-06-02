function fight(head, color)
    H = imread(head);
    S = imread('slogen.jpg');
    [a,b,~] = size(S);
    H = imresize(H, [a,b]);
    for i = 1:a
        for j = 1:b
            if S(i,j)~=0
                H(i,j,:) = [color];
            end
        end
    end
    imwrite(H, ['after_',head]);
    
