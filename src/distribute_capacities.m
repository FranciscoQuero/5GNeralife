function [ capacity ] = distribute_capacities( capacity, pairing, number_of_bs )
%USER_COUNT Summary of this function goes here
%   Detailed explanation goes here

    dimensions = size(pairing);
    no_user_count = zeros( dimensions(1), number_of_bs,...
        dimensions(3) );
    
    for i = 1:dimensions(1)
        for j = 1:dimensions(3)
            for k = 1:dimensions(2)
                bs = pairing(i, k, j);
                no_user_count(i, bs, j) = no_user_count(i, bs, j) + 1;
            end
            
            for a = 1:number_of_bs
                [~, col, ~] = find(pairing(i,:,j) == a);
                capacity(i, col, j) = capacity(i, col, j)./no_user_count(i, a, j);
            end
            
        end
    end

end

