function [delay,doppler] = SecondOrderReflection(mpcs,Tx,Rx)


    delay = zeros(1,length(mpcs));
    doppler = zeros('like', delay);
    
    if ~isempty(cell2mat({mpcs.Normal}'))
        rightWall = mpcs(all(cell2mat({mpcs.Normal}') == [-1, 0, 0], 2));
        leftWall  = mpcs(all(cell2mat({mpcs.Normal}') == [+1, 0, 0], 2));

        delay = zeros(1,length(rightWall)*length(leftWall));
        doppler = zeros('like', delay);
               

        for m = 1:length(rightWall)
            for n = 1:length(leftWall)
                rightMPC = rightWall(m);
                leftMPC = leftWall(n);
                idx = (m-1)*length(leftWall) + n;
                delay(idx) = Tx.Distance(rightMPC) + rightMPC.Distance(leftMPC) + leftMPC.Distance(Rx);
                if Rx.Distance(leftMPC) < Rx.Distance(rightMPC)
                    firstmpc = rightMPC;
                    secondmpc = leftMPC;
                else
                    firstmpc = leftMPC;
                    secondmpc = rightMPC;
                end
                
                n1 = GetNormal(secondmpc.Position - firstmpc.Position, Tx.Position - firstmpc.Position); 
                n2 = GetNormal(Rx.Position - secondmpc.Position, firstmpc.Position - secondmpc.Position);
                vfirst = ImagePoint(n1, Tx.Velocity);
                vsecond = ImagePoint(n2, vfirst);
                
                mpc2rx = Rx.Position - secondmpc.Position;
                doppler(idx) = (vsecond-Rx.Velocity')'*mpc2rx'/(norm(vsecond-Rx.Velocity')*norm(mpc2rx));
            end
        end
    end

end

