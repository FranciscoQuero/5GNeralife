function [ power_out ] = reshape_power( power_in )
%RESHAPE_POWER Summary of this function goes here
%   Detailed explanation goes here

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