function [ ] = show_data(  criteria, type, data, rx_id, pairing, hold_on, input )
%SHOW_DATA Plots the selected data with automatic legends and axis, with
%the possibility of plotting in the same previous figure
% Input:
%   criteria
%   The pairing criteria of the desired data. It can be 'SINR' or
%   'Distance'. By default, Distance is selected.
%
%   type
%   String which contains macro- or micro-cell for user information
%
%   data
%   String which contains the data that it will be plotted. It can be
%   'SINR', 'Power', 'Pairing' and 'Capacity'
%
%   rx_id
%   Index of the selected Rx
%
%   pairing
%   Pairing matrix of the simulation
%
%   hold_on
%   Index that is false if a new Figure is needed
%
%   input
%   Data matrix which contains data that will be represented.
%
% 5Gneralife Copyright (C) 2018 Francisco Quero
% e-mail: fjqr@correo.ugr.es
%
% 5Gneralife is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published
% by the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.

    len = length( input(1,1,:) );
    dist = 1:len;
    
    switch data
        case 'SINR'
            index_data = 1;
        case 'Power'
            index_data = 2;
        case 'Pairing'
            index_data = 3;
        case 'Capacity'
            index_data = 4;
    end

    if strcmp(criteria, 'SINR')
        crit = 1;
    else
        crit = 2;
    end
    
    %% Ploting
    title_gen = ['of the Rx' num2str(rx_id,'%02d')];
    
    if hold_on == 0
        figure;
    else
        hold all
    end
    
    display_name = ['Repr. of ' data ' ' title_gen ' at ' type...
        ' layer paired by ' criteria];
    
    switch index_data
        case 1
            for i = 1:len
                paired = pairing(crit, rx_id, i);
                data_for_plotting(i) = input(rx_id, paired, i);
            end
            plot( dist, data_for_plotting, 'DisplayName', display_name )
            title(['SINR ' title_gen ' in the ' type ' layer'])
            ylabel('SINR [dB]')
        case 2
            for i = 1:len
                paired = pairing(crit, rx_id, i);
                data_for_plotting(i) = input(rx_id, paired, i);
            end
            data_for_plotting = 10*log10(data_for_plotting);
            
            plot( dist, data_for_plotting, 'DisplayName', display_name )
            title(['Received Power ' title_gen ' in the ' type ' layer'])
            ylabel('Power [dBm]')
        case 3
            for i = 1:len
                data_for_plotting(i) = pairing(crit, rx_id, i);
            end
            plot( dist, data_for_plotting, 'DisplayName', display_name )
            title(['Pairing evolution ' title_gen ' in the ' type ' layer'])
            ylabel('Number of the associated BS')
            maximum = max(data_for_plotting);
            ylim([0.9 maximum(1)+0.3])
        case 4
            for i = 1:len
                data_for_plotting(i) = input(crit, rx_id, i);
            end
            plot( dist, data_for_plotting, 'DisplayName', display_name )
            title(['Capacity ' title_gen ' in the ' type ' layer'])
            ylabel('Capacity [MBit / second]')
    end
    xlim([0,len])
    xlabel('Walked distance [m]')
    legend('-DynamicLegend');
    
    if hold_on
        hold off
    end
end