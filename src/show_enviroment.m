function [ ] = show_enviroment( l )
%SHOW_ENVIROMENT plot a detailed view of the enviroment, with the border lines of the cells.
%
% Description:
%   This functions helps to visualize a enviroment with two layouts, first
%   one (red) correspond to Macrocell layout. Second one is the layout of
%   Microcells, which is represented in green.
%
% Input:
%   l
%   a vector with two layouts
%
% 5Gneralife Copyright (C) 2018 Francisco Quero
% e-mail: fjqr@correo.ugr.es
%
% 5Gneralife is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published
% by the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.

    figure('position', [50 50 900 600])
    
    color = ['g', 'r'];
    
    parameter = [2, 1];
    
    for i = 1:2
        pos = l(i).tx_position';
        hold on
        visualize_layer(l(i),[],[], parameter(i), 0, i); % visualize layout
       % visualize_layer(l(i),[],[], 1, 0, i); % visualize layout
        hold on
        handel_prop = voronoi(pos(:,1),pos(:,2),'k');
        set(handel_prop(1),'Color',color(i)); % split lines
        aux=size(handel_prop,1);
        for j=2:aux
            set(handel_prop(j),'LineWidth',3, 'Color', color(i));
        end
        hold on
    end
    
    h = zeros(2, 1);
    h(1) = plot(NaN,NaN,'^r');
    h(2) = plot(NaN,NaN,'^g');
    legend(h, 'UMa BS position','UMi BS position');
    
    view(-33,48)
    hold off
end

