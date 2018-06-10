function [ capacity ] = compute_capacity_distance( sinr, pairing, BW )
%COMPUTE_CAPACITY_DISTANCE Calculates the Capacity according to nearest BS
%pairing by using the calculated SINR, the pairing matrix and assigned BW
%to each BS.
% Calling object:
%   Single object
%
% Input:
%   sinr
%   A m-n-p matrix containing the sinr for each pairing criteria (m), 
%   receiver (n) and snapshot (p).
%
%   pairing
%   A m-n-p matrix containing the pairing for each criteria (m), 
%   receiver (n) and snapshot (p).
%
%   BW
%   Pre-asigned bandwidth for each BS in MHZ.
%
% Output:
%   capacity
%   A m-n matrix which contains the calculated maximum throughput for each
%   receiver (m) and snapshot (n).

    dimension = size(sinr);
    sinr_dist = zeros(dimension(1), dimension(3));

%   Capacity (maximum throughput) is calculated by 
%   the spectral utilization formula simplification. Firstly, it calculates
%   the best BS to associate in order to take its SINR. Once all SINR are
%   collected, Throughput is calculated by applying the formula.
    
    for i = 1:dimension(1)
        for j = 1:dimension(3)
            sinr_dist(i,j) = sinr(i, pairing(2, i, j), j);
        end
    end
    sinr_dist(sinr_dist < 0) = 0;
    capacity(:,:) = BW*log2(1+sinr_dist);
    
end

