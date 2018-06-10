function [ capacity ] = compute_capacity_sinr( sinr, pairing, BW )
%COMPUTE_CAPACITY_SINR Summary of this function goes here
%   Detailed explanation goes here
    dimension = size(sinr);
    sinr_dist = zeros(dimension(1), dimension(3));

    for i = 1:dimension(1)
        for j = 1:dimension(3)
            sinr_dist(i,j) = sinr(i, pairing(1, i, j), j);
        end
    end
    sinr_dist(sinr_dist < 0) = 0;
    capacity(:,:) = BW*log2(1+sinr_dist);
end

