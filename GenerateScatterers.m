% leftWall_1 - Left wall 1st order scatterers
% leftWall_2 - Left wall 2nd order scatterers
% leftWall_3 - Left wall 3rd order scatterers
% rightWall_1 - Right wall 1st order scatterers
% rightWall_2 - Right wall 2nd order scatterers
% rightWall_3 - Right wall 3rd order scatterers

rng(1); leftWall_1 = [  unifrnd(p1(1), p1(1)+W, [round(A*chi1), 1]), ...    % x-coordinates
                        unifrnd(p1(2), p1(2)+H, [round(A*chi1), 1])];       % y-coordinates
                    
rng(2); leftWall_2 = [  unifrnd(p1(1), p1(1)+W, [round(A*chi2), 1]), ...    % x-coordinates
                        unifrnd(p1(2), p1(2)+H, [round(A*chi2), 1])];       % y-coordinates
                    
rng(3); leftWall_3 = [  unifrnd(p1(1), p1(1)+W, [round(A*chi3), 1]), ...    % x-coordinates
                        unifrnd(p1(2), p1(2)+H, [round(A*chi3), 1])];       % y-coordinates

rng(4); rightWall_1 = [ unifrnd(p2(1), p2(1)+W, [round(A*chi1), 1]), ...
                        unifrnd(p2(2), p2(2)+H, [round(A*chi1), 1])];
                    
rng(5); rightWall_2 = [ unifrnd(p2(1), p2(1)+W, [round(A*chi2), 1]), ...
                        unifrnd(p2(2), p2(2)+H, [round(A*chi2), 1])];
                    
rng(6); rightWall_3 = [ unifrnd(p2(1), p2(1)+W, [round(A*chi3), 1]), ...
                        unifrnd(p2(2), p2(2)+H, [round(A*chi3), 1])];

                    
% Wall, just scatterers not distinguishing order
leftWall    = [leftWall_1; leftWall_2; leftWall_3];
rightWall   = [rightWall_1; rightWall_2; rightWall_3];

clear leftWall_1 leftWall_2 leftWall_3
clear rightWall_1 rightWall_2 rightWall_3