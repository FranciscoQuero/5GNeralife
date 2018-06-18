function [ capacity ] = distribute_capacities( capacity, pairing, number_of_bs )
%DISTRIBUTE_CAPACITIES Distributes the total of the thorughput among all
%the Rx connected at the same BS in each snapshot
%
% Input:
%   capacity
%   A m-n-p matrix which contains the maximum throughput for each
%   pairing criteria (m), receiver (n) and snapshot (p).
%
%   pairing
%   A m-n-p matrix containing the pairing for each criteria (m), 
%   receiver (n) and snapshot (p).
%
%   number_of_bs
%   Total number of BS in the simulated layout
%
% Output:
%   capacity
%   A m-n-p matrix which contains the distributed maximum throughput for each
%   pairing criteria (m), receiver (n) and snapshot (p).
%
% 5Gneralife Copyright (C) 2018 Francisco Quero
% e-mail: fjqr@correo.ugr.es
%
% 5Gneralife is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published
% by the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.

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

