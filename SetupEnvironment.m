W           = unifrnd(2.4, 3);      % Width [m]
H           = 100;                  % Height [m]
streetWidth = 15;                   % [m]

p1 = [-streetWidth/2 - W; 0; 0];        % Point wall 1 (lower left corner)
p2 = [+streetWidth/2; 0; 0];        % Point wall 2 (lower left corner)


A       = W * H;       % Rectangle area [m^2]
chi1    = 0.052;       % Density of 1st order scatterers [1/m^2]
chi2    = 0.045;       % Density of 2nd order scatterers [1/m^2]
chi3    = 0.03;        % Density of 3rd order scatterers [1/m^2]

n_leftWall  = [+1; 0; 0];   % Left Wall Normal vector
n_rightWall = [-1; 0; 0];   % Right Wall Normal vector