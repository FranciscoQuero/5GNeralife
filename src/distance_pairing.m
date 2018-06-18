function [ pairing ] = distance_pairing( layout, snap )
%DISTANCE_PAIRING Decides which is the best BS to pairing according to the
%nearest one
%
% Input:
%   layout
%   A qd_layout QuaDRiGa object which contains each Rx and Bs in order to
%   pair them
%
%   snap
%   Number of snapshots that contains the trajectory of every Rx
%
% Output:
%   pairing
%   A m-n matrix containing the pairing for each receiver (m) and snapshot (n).
%
% 5Gneralife Copyright (C) 2018 Francisco Quero
% e-mail: fjqr@correo.ugr.es
%
% 5Gneralife is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published
% by the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.

    no_rx = layout.no_rx;
    no_tx = layout.no_tx;
    
    pairing = zeros(no_rx, snap);
    
    distances = zeros(no_rx, snap, no_tx);
    
    for i = 1:snap
        for j = 1:no_rx
            for k = 1:no_tx
                pos_rx = layout.track(j).positions(:,i) + layout.track(j).initial_position(:);
                pos_tx = layout.tx_position(:,k);
                distances(j,i,k) = sqrt(sum((pos_rx-pos_tx).^2));
            end
        end
    end
    
    for i = 1:snap
        for j = 1:no_rx
            [~, indice] = min(distances(j,i,:));
            pairing(j,i) = indice;
        end
    end
end

