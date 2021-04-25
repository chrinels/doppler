function PlotScatterers(fh, leftWall_1,leftWall_2,leftWall_3, rightWall_1, rightWall_2, rightWall_3)

    figure(fh)
    hold on
    scatter(leftWall_1(:,1), leftWall_1(:,2), 'filled', 'MarkerFaceColor',[0 0.4470 0.7410]) %[0 0.4470 0.7410]
    scatter(leftWall_2(:,1), leftWall_2(:,2), 'filled', 'MarkerFaceColor',[0.8500 0.3250 0.0980]) %[0.8500 0.3250 0.0980] 
    scatter(leftWall_3(:,1), leftWall_3(:,2), 'filled', 'MarkerFaceColor',[0.9290 0.6940 0.1250]) %[0.9290 0.6940 0.1250]
    scatter(rightWall_1(:,1), rightWall_1(:,2), 'filled', 'MarkerFaceColor',[0 0.4470 0.7410])%[0 0.4470 0.7410]
    scatter(rightWall_2(:,1), rightWall_2(:,2), 'filled', 'MarkerFaceColor',[0.8500 0.3250 0.0980])%[0.8500 0.3250 0.0980]
    scatter(rightWall_3(:,1), rightWall_3(:,2), 'filled', 'MarkerFaceColor',[0.9290 0.6940 0.1250])%[0.9290 0.6940 0.1250]

    xlim([-100, 100])
    ylim([-5, 105])

end

