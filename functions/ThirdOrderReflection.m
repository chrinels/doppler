function [delay,doppler] = ThirdOrderReflection(wall1,wall2, Tx, Rx)
%THIRDORDERREFLECTION Summary of this function goes here
%   Detailed explanation goes here
    
    b = length(wall1) * length(wall2);
    
    delay = zeros(b*b, 1);
    doppler = zeros(b*b, 1);
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
                                  
                        n1 = GetNormal(Tx.Position - mpc3_1.Position, mpc3_2.Position - mpc3_1.Position);
                        n2 = GetNormal(mpc3_3.Position - mpc3_2.Position, mpc3_1.Position - mpc3_2.Position);
                        n3 = GetNormal(Rx.Position - mpc3_3.Position, mpc3_2.Position - mpc3_3.Position);

                        vfirst = ImagePoint(n1, Tx.Velocity);
                        vsecond = ImagePoint(n2, vfirst);
                        vthird = ImagePoint(n3, vsecond);
                
                                  
                        mpc2rx = Rx.Position - mpc3_3.Position;
                        doppler(idx) = (vthird-Rx.Velocity')'*mpc2rx'/(norm(vthird-Rx.Velocity')*norm(mpc2rx));
                        idx = idx + 1;
                        
                    end
                end
            end
        end
    end
    
    delay = delay(1:idx-1);
    doppler = doppler(1:idx-1);
    
    
end

