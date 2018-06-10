function [ ] = show_data(  criteria, type, data, rx_id, pairing, hold_on, input )
%SHOW_DATA Summary of this function goes here
%   Detailed explanation goes here
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
    %data_for_plotting = zeros(1:len);
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