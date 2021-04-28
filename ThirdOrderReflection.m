function [delay,doppler] = ThirdOrderReflection(wall1,wall2, Tx, Rx)
%THIRDORDERREFLECTION Summary of this function goes here
%   Detailed explanation goes here

    total_velocity = Tx.Velocity - Rx.Velocity;
    max_doppler = norm(total_velocity)/physconst('LightSpeed')*Tx.Frequency;
    
    
    delay = 0;
    doppler = 0;
    idx = 1;
    for i = 1:length(wall1)
        mpc3_1 = wall1(i);
        
        for j = 1:length(wall2)
            mpc3_2 = wall2(j);
            
            if mpc3_1.Y() > mpc3_2.Y()
                
                for k = i+1:length(wall1)
                    mpc3_3 = wall1(k);
                    
                    if mpc3_2.Y() > mpc3_3.Y()
                        
                        delay(idx) = Tx.Distance(mpc3_1) + ...
                                      mpc3_1.Distance(mpc3_2) + ...
                                      mpc3_2.Distance(mpc3_3) + ...
                                      mpc3_3.Distance(Rx);
                        mpc2rx = Rx.Position - mpc3_3.Position;
                        doppler(idx) = (total_velocity*mpc2rx')/(norm(total_velocity)*norm(mpc2rx))*max_doppler;
                        idx = idx + 1;
                        
                    end
                end
            end
        end
    end
    
    
end

