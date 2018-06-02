function ga(targetname)
clc
   %%initial
   show_number = [1 5 50 100 500 1000 1500 2000 2500 3000 3500 4000 4500 4800 4900 5000 6000 8000 10000 12000 15000];
   target = imresize(imread([targetname,'.jpg']),[256,256]);
   imwrite(uint8(target),[targetname,'_target.jpg']);
   total_amount = 40;
   best_amount = 8;
   target_accuracy = 0.99;
   generation_number = 15000;
   Pc = 0.7;
   Pcn = 0.3;
   Pm = 0.001;
   population = char(randi([48,49],7200,total_amount));
   optimal_gene = char(zeros(7200,1));
   optimal_fitness = 0;
   %%count fitness
   fitness_arr = zeros(1,total_amount);
   for generation_counter=1:generation_number
       for i=1:total_amount
           fitness_arr(i) = fitness(population(:,i),target);
           if (fitness_arr(i)>optimal_fitness)
               optimal_fitness = fitness_arr(i);
               optimal_gene = population(:,i);
           end
       end
       if (optimal_fitness>target_accuracy)
           break;
       end
       %%begin to kill
       %%top 10 pass immediately
       [~,index] = sort(fitness_arr);
       index = index(total_amount-best_amount+1:end);
       best_gene = population(:,index);
       %%kill by P
       fitness_arr = cumsum(fitness_arr/sum(fitness_arr));
       survive_idx = discretize(rand(1,total_amount),[0,fitness_arr]);
       next_gene = population(:,survive_idx);
       next_gene = next_gene(:,randperm(total_amount));
       %%crossover
       cross_idx = rand(1,total_amount/2)>Pc;
       cross_idx_in = rand(900,total_amount/2)<Pcn;
       cross_idx_in = repelem(cross_idx_in,8,1);
       cross_idx_in(:,cross_idx) = 0;
       cross_diff_idx = zeros(7200:total_amount);
       cross_diff_idx(:,1:2:total_amount) = cross_idx_in;
       cross_diff_idx(:,2:2:total_amount) = -cross_idx_in;
%        X = repelem([1:total_amount],7200,1);
%        X = X + cross_diff_idx;
%        temp = zeros(7200,total_amount);
%        for xx = 1:7200
%           for yy = 1:total_amount
%               temp(xx,yy) = next_gene(xx,X(xx,yy));
%           end
%        end
%        next_gene = [temp(1:7200,best_amount+2:end),best_gene];


    [X,Y] = meshgrid(1:total_amount,1:7200);
    new_gene_index = sub2ind([7200,total_amount],Y,X+cross_diff_idx);
    next_gene = next_gene(new_gene_index);
    next_gene = [next_gene(1:7200,best_amount+1:end),best_gene];

       %%change suddendly
       change_idx = rand(7200,total_amount)<Pm;
       population = char(xor(change_idx,next_gene-48)+48);
       %%show
       disp(['generation__',num2str(generation_counter),': ',num2str(optimal_fitness)]);
       pic_out = draw(optimal_gene);
       imshow(uint8(pic_out));
       if any(generation_counter==show_number)
           imwrite(uint8(pic_out),[targetname,'_generation__',num2str(generation_counter),'.jpg'])
   
       end
   end
end


    function same_digree = fitness(gene,target)
        [W,L,~] = size(target);
        diff = W*L*256*3;
        cur_pic = draw(gene);
        same_digree = 1 - sum(sum(sum(abs(cur_pic-double(target)))/diff));
    end

    function cur_pic = draw(gene)
        W = 256;
        L = 256;
        point = reshape(bin2dec(reshape(gene(1:4800),600,8))+1,100,6);
        color = reshape(bin2dec(reshape(gene(4801:7200),300,8)),100,3);
        cur_pic = insertShape(ones(W,L,3)*255, 'FilledPolygon', point, 'Color', color, 'Opacity', 0.6);
    end