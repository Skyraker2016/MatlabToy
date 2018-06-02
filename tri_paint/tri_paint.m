
function tri_paint( target_name, point_num, choice_num)
    target = imread(target_name);
    [a,b,~] = size(target);
    %%
    line = edge(im2bw(rgb2gray(target)));
    lineP = 0.1;
%%
    choice = ones(choice_num, a, b, 3);
    %choice_fitness = zeros(choice_num,1);
    group = zeros(choice_num, point_num, 2);
    for i = 1 : choice_num
        line_cur = (rand(a,b)<lineP) & line;
        [line_group_x,line_group_y] = find(line_cur==1);
        last_num = size(line_group_x);
        while (last_num(1)>point_num/2)
            lineP = lineP*0.8;
            line_cur = (rand(a,b)<lineP) & line;
            [line_group_x,line_group_y] = find(line_cur==1);
            last_num = size(line_group_x);
        end
        group(i,1:point_num-last_num(1),1) = randi([1,a],1,point_num-last_num(1));
        group(i,1:point_num-last_num(1),2) = randi([1,b],1,point_num-last_num(1));
        group(i,point_num-last_num(1)+1:end,:) = [line_group_x, line_group_y];
        temp = zeros(point_num,2);
        temp(:,:) = group(i,:,:);
        tri = delaunay(temp);
        tri_point = temp(tri,:);
        tri_num = size(tri,1);
        tri_num = tri_num(1);
        tri_point = [tri_point(1:tri_num,:), tri_point(tri_num+1:tri_num*2,:),tri_point(tri_num*2+1:tri_num*3,:)];
        tri_color = zeros(tri_num,3);
        for tri_counter = 1:tri_num
            pic_temp = target;
            BW = roipoly(target,tri_point(tri_counter,1:2:6),tri_point(tri_counter,2:2:6));
            BWWW = false(a,b,3);
            BWWW(:,:,1) = ~BW;
            BWWW(:,:,2) = ~BW;
            BWWW(:,:,3) = ~BW;
            pic_temp(BWWW) = 1;
            area = sum(sum(BW));
            if (area == 0)
                tri_color(tri_counter,:) = [1 1 1];
            else
                tri_color(tri_counter,:) = [(sum(sum(pic_temp(:,:,1)))-(a*b-area))/area, (sum(sum(pic_temp(:,:,2)))-(a*b-area))/area, (sum(sum(pic_temp(:,:,3)))-(a*b-area))/area];
            end
        end
        %%
        temp = zeros(a,b,3);
        temp(:,:,:) = choice(i,:,:,:);
        temp = insertShape(temp,'FilledPolygon',tri_point,'Color',tri_color,'Opacity',0.9);
        imwrite(uint8(temp),[num2str(i),'_',target_name]);
        disp([target_name,'_',num2str(i)]);
        imshow(uint8(temp));
    end
end