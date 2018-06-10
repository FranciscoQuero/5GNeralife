function [ channel_uma, channel_umi, layout_uma, layout_umi ] = generate_channels( params )
%GENERATE_CHANNELS Summary of this function goes here
%   Detailed explanation goes here

los_uma = params.los_uma;
los_umi = params.los_umi;

prob_uma = [los_uma, 1-los_uma];
prob_umi = [los_umi, 1-los_umi];

scenarios_uma = {'3GPP_38.901_UMa_LOS', '3GPP_38.901_UMa_NLOS'};
scenarios_umi = {'3GPP_38.901_UMi_LOS', '3GPP_38.901_UMi_NLOS'};

%% Antennas
aMT = qd_arrayant('omni');
aBS = qd_arrayant ('multi', 8, 0.5 , 12 );
aBS.combine_pattern;
aBS_umi = aBS.copy;

%% Sim parameters of UMa
sim_param = qd_simulation_parameters;               % Set general simulation parameters
sim_param.center_frequency = params.freq_uma;   % Set center frequencies for the simulations

sim_param.use_absolute_delays = 0;
sim_param.use_spherical_waves = 1;                  
sim_param.use_geometric_polarization = 0;           % Disable QuaDRiGa polarization model and use 3GPP model
sim_param.show_progress_bars = 1;                   

%% Transmitters:
layout_uma = qd_layout.generate ('regular', params.number_of_uma, params.dist_between_uma, aBS);
layout_uma.simpar = sim_param;
layout_uma.tx_position(3,:) = 25;                                   % 25 m BS height
layout_uma.name = 'UMa';

layout_uma.no_rx = params.number_of_rx;                          % Number of users
layout_uma.randomize_rx_positions(params.dist_between_uma, 1.5, 1.5, 0);

layout_uma.rx_position(3,:) = 1.5;            % Set outdoor-users to 1.5 m height

layout_uma.set_scenario('3GPP_38.901_UMa',[],[],0,1-los_uma);
layout_uma.rx_array = aMT;                                     % MT antenna setting

sim_param.center_frequency = params.freq_umi;
layout_umi = qd_layout.generate ('regular', params.number_of_umi, params.dist_between_umi, aBS_umi);
layout_umi.simpar = sim_param;
layout_umi.tx_position(3,:) = 10;                                   % 10 m BS height
layout_umi.name = 'UMi';

layout_umi.no_rx = params.number_of_rx;                          % Number of users
layout_umi.randomize_rx_positions(params.dist_between_umi, 1.5, 1.5, 0);

layout_umi.rx_position(3,:) = 1.5;            % Set outdoor-users to 1.5 m height

layout_umi.set_scenario('3GPP_38.901_UMi',[],[],0,1-los_umi);
layout_umi.rx_array = aMT;                                     % MT antenna setting

%% Write all streets in one layout

for a = 1 : params.number_of_rx
    trk = qd_track('street', params.walked_distance, randi(360), 50, 87, 83, 10, 0.85);    % Street
    trk.initial_position = layout_uma.rx_position(:,a);                             % Strat-pos
    trk.name = layout_uma.rx_name{a};                                               % Unique name
    layout_uma.track(1,a) = trk.copy;                                                    % Assign to layout
    layout_uma.track(1,a).set_scenario( scenarios_uma, prob_uma, 10 ,30, 12 );
    layout_umi.track(1,a) = trk.copy;
    layout_umi.track(1,a).set_scenario( scenarios_umi, prob_umi, 10 ,30, 12 ); % Segments
end
% Generate ALL channels - this makes sure the correlations are correct
channel_uma = layout_uma.get_channels;
channel_umi = layout_umi.get_channels;


end

