function [ pairing ] = distance_pairing( layout, snap )
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

