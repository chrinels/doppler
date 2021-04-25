function PlotScatterers(fh, scatterers, color)

    figure(fh)
    hold on
    scatter(scatterers(:,1), scatterers(:,2), 'filled', 'MarkerFaceColor',color)

    xlim([-50, 50])
    ylim([-5, 105])

end

