% DESCRIPTION
% This script generates a typical 5G enviroment which combines macrocells
% and microcells with a defined amount of users which travel around the map. 
% Received power is calculated in each snapshot of the user track in order 
% to evaluate the power evolution. Likewise, all BS of the same layout are in
% interfere themselves, so, the sinr and capacity of the channel is also
% calculated in every snapshot. At the end of the script, the map is
% visualized and the receiver power from Tx1 UMa is represented in a
% different figure.
%
% This file is based on QuaDRiGa (http://quadriga-channel-model.de/).
%
% Francisco Quero de la Rosa
% e-mail: fjqr@correo.ugr.es
%
% University of Granada
%
% This project is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published
% by the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This project is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
%
% You should have received a copy of the GNU Lesser General Public License
% along with QuaDRiGa. If not, see <http://www.gnu.org/licenses/>. 

clear;
close all;

addpath(genpath(pwd));

obj = simulator;
waitfor(obj.UIFigure);
clear obj;

load parameters.mat;
delete parameters.mat;

tic

% params = Parameters(freq_uma, freq_umi, number_of_uma, number_of_umi, ...
%     dist_between_uma, dist_between_umi, number_of_rx, walked_distance,
%     ... tx_power_uma, tx_power_umi, BW, No);

[ channel_uma, channel_umi, layout_uma, layout_umi ] = generate_channels( params );

[ sinr_uma, rx_power_uma ] = generate_sinr( channel_uma, layout_uma, params.get_lin_pow_uma, params.No );
[ sinr_umi, rx_power_umi ] = generate_sinr( channel_umi, layout_umi, params.get_lin_pow_uma, params.No );

no_snap = channel_uma(1,1).no_snap;

clear channel_uma channel_umi;

pairing_uma = zeros(2, params.number_of_rx, no_snap);
pairing_umi = zeros(2, params.number_of_rx, no_snap);

%% Pairing

for j = 1:no_snap
    for i = 1:params.number_of_rx
        [~, pairing_uma(1,i,j)] = max( sinr_uma(i,:,j) );
        [~, pairing_umi(1,i,j)] = max( sinr_umi(i,:,j) );
    end
end

pairing_uma(2,:,:) = distance_pairing(layout_uma, no_snap);
pairing_umi(2,:,:) = distance_pairing(layout_umi, no_snap);

%% Compute capacity
% Capacity in the case of pairing by the better sinr:
capacity_uma(1,:,:) = compute_capacity_sinr(sinr_uma, pairing_uma, params.BW);
capacity_umi(1,:,:) = compute_capacity_sinr(sinr_umi, pairing_umi, params.BW);

% Capacity in the case of pairing by the nearest BS:
capacity_uma(2,:,:) = compute_capacity_distance(sinr_uma, pairing_uma, params.BW);
capacity_umi(2,:,:) = compute_capacity_distance(sinr_umi, pairing_umi, params.BW);

%% Recuento

[ capacity_uma ] = distribute_capacities( capacity_uma, pairing_uma, params.number_of_uma );
[ capacity_umi ] = distribute_capacities( capacity_umi, pairing_umi, params.number_of_umi );

%% Distribute capacities

clear params pairing_criteria no_snap i j;
save('output', 'layout_uma', 'layout_umi', 'sinr_uma', 'capacity_uma', ...
    'sinr_umi', 'capacity_umi', 'pairing_uma', 'pairing_umi', ...
    'rx_power_uma', 'rx_power_umi');

toc

visualization_panel;