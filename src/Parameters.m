classdef Parameters
    %PARAMS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        freq_uma; % UMa Frequency in Hz
        freq_umi; % UMi Frequency in Hz
        number_of_uma; % Number of Macro-cells
        number_of_umi; % Number of Micro-cells
        dist_between_uma; % Distance between UMa cells center
        dist_between_umi; % Distance between UMi cells center
        number_of_rx; % Number of Mobile Terminals
        walked_distance; % Distance that Mobile Terminals will walk in meters
        tx_power_uma; % Transmit Power of UMa BS in dBm
        tx_power_umi; % Transmit Power of UMi BS in dBm 
        BW; % Asigned bandwidth to each BS in MHz
        No; % Noise in W/Hz
        los_uma; % LOS probability for UMa enviroment
        los_umi; % LOS probability for UMi enviroment
    end
    
    methods
        function obj = Parameters(a,b,c,d,e,f,g,h,i,j,k,l,m,n)
            obj.freq_uma = a;
            obj.freq_umi = b;
            obj.number_of_uma = c;
            obj.number_of_umi = d;
            obj.dist_between_uma = e;
            obj.dist_between_umi = f;
            obj.number_of_rx = g;
            obj.walked_distance = h;
            obj.tx_power_uma = i;
            obj.tx_power_umi = j;
            obj.BW = k;
            obj.No = l;            
            obj.los_uma = m;
            obj.los_umi = n;
        end
        function pow = get_lin_pow_uma(obj)
            pow = 10^(obj.tx_power_uma/10); % Power in W
        end
        function pow = get_lin_pow_umi(obj)
            pow = 10^(obj.tx_power_umi/10); % Power in W
        end
    end
    
end

