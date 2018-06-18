function [ sinr, rx_power ] = generate_sinr( channel, layout, tx_power, No )
%GENERATE_SINR Calculates SINR for the Rx elements of one layout by using
%their channel coefficients, as well as Rx power.
%
% Input:
%   channel
%   A QuaDRiGa qd_channel object that contains the channel coefficients of 
%   the layout 
%
%   layout
%   A QuaDRiGa qd_layout object that contains the layout
%
%   tx_power
%   The transmit power of every BS, in Watts
%
%   No
%   The spectral power density of the termical noise
%
% Output:
%   sinr
%   A m-n-p matrix containing the sinr for each pairing criteria (m), 
%   receiver (n) and snapshot (p).
%
%   rx_power
%   A m-n-p sized matrix that contains the received power for each Rx (m),
%   each BS (n) at each snapshot (p)
%
% 5Gneralife Copyright (C) 2018 Francisco Quero
% e-mail: fjqr@correo.ugr.es
%
% 5Gneralife is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published
% by the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
    
    number_of_rx = layout.no_rx;
    no_snap_per_track = channel(1,1).no_snap;
    rx_aux = zeros(number_of_rx, layout.no_tx*3 , no_snap_per_track);
    no_sectors_per_bs = 3;
    
    for a = 1 : number_of_rx
        power = zeros( layout.no_tx*3 , no_snap_per_track );
        for builder = 1 : layout.no_tx
            power_calc = abs(channel(a,builder).coeff).^2;
            power_calc = sum( power_calc, no_sectors_per_bs );
            power_calc = reshape( power_calc, no_sectors_per_bs, no_snap_per_track );         % 3 sectors per BS

            index = (builder-1)*no_sectors_per_bs+1 : builder*no_sectors_per_bs;
            power(index,:) = power_calc * tx_power;
        end

        rx_aux(a, :, :) = power;
    end

    rx_power = zeros(number_of_rx, layout.no_tx, no_snap_per_track);
    sinr = zeros(number_of_rx, layout.no_tx, no_snap_per_track);
    for i = 1:number_of_rx
        aux = rx_aux(i,:,:);
        aux = reshape(aux, [layout.no_tx*3, no_snap_per_track]);
        current_rx_pow = reshape_power(aux);

        for j = 1:layout.no_tx
            for k = 1:no_snap_per_track
                sinr(i,j,k) = current_rx_pow(j,k) / ...
                    (sum(current_rx_pow(:, k)) + No - current_rx_pow(j,k));
            end
        end

        sinr(i,:,:) = 10*log10(sinr(i,:,:));
        rx_power(i, :, :) = current_rx_pow;
    end

end

