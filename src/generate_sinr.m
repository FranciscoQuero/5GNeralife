function [ sinr, rx_power ] = generate_sinr( channel, layout, tx_power, No )
%GENERATE_SINR Summary of this function goes here
%   Detailed explanation goes here
    
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

