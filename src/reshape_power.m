function [ power_out ] = reshape_power( power_in )
%RESHAPE_POWER Selects the best power of the 3 sector of each BS in order
%to determine which is the received power in every Rx
% Input:
%   power_in
%   A 3m-n sized matrix that contains the received power for each BS (m),
%   at each Rx (n) in 3 sectors each BS
%
% Output:
%   power_out
%   A m-n sized matrix that contains the reshaped received power for each BS (m),
%   at each Rx (n)
%
% 5Gneralife Copyright (C) 2018 Francisco Quero
% e-mail: fjqr@correo.ugr.es
%
% 5Gneralife is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published
% by the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.

dimensions = size(power_in);
power_out = zeros( dimensions(1)/3, dimensions(2) );

    for i = 1:dimensions(2)
        count = 1;
        
        for j = 1:3:dimensions(1)
            power_out(count, i) = max( power_in(j:j+2, i) );
            count = count + 1;
        end
    end
    
end