function PlotScatterers(fh, scatterers, color)

    sc = cell2mat({scatterers.Position}');

    figure(fh)
    hold on
    scatter(sc(:,1), sc(:,2), 'filled', 'MarkerFaceColor',color)

    xlim([-20, 20])
    ylim([-5, 205])

end

