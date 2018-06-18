function [ capacity ] = compute_capacity_sinr( sinr, pairing, BW )
%COMPUTE_CAPACITY_SINR Calculates the Capacity according to best SINR
%pairing by using the calculated SINR, the pairing matrix and assigned BW
%to each BS.
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
%
% 5Gneralife Copyright (C) 2018 Francisco Quero
% e-mail: fjqr@correo.ugr.es
%
% 5Gneralife is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published
% by the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.

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

