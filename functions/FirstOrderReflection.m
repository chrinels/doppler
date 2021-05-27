function [delay,doppler] = FirstOrderReflection(mpcs,Tx,Rx)
%FIRSTORDERREFLECTION Summary of this function goes here
%   Detailed explanation goes here
        delay = zeros(1, length(mpcs));
        doppler = zeros('like', delay);
        for m = 1:length(mpcs)
            mpc = mpcs(m);
            mpc2rx = Rx.Position - mpc.Position;
            mpc2tx = Tx.Position - mpc.Position;
            delay(m) = Tx.Distance(mpc) + Rx.Distance(mpc);
            
            n_tmp = GetNormal(mpc2rx,mpc2tx);
            v_tmp = ImagePoint(n_tmp, Tx.Velocity);
            
            doppler(m) = (v_tmp-Rx.Velocity')'*mpc2rx'/(norm(v_tmp-Rx.Velocity')*norm(mpc2rx));
        end
end

