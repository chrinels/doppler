function [Delay, Doppler] = Simulate(EnvParams,SimParams, MPCs, Tx, Rx)

    Delay = struct();
    Doppler = struct();


    mpc1 = cell2mat({MPCs.FirstOrder.Position}');
    mpc2 = cell2mat({MPCs.SecondOrder.Position}');
    mpc3 = cell2mat({MPCs.ThirdOrder.Position}');

    los_delay = zeros(length(SimParams.t), 1);
    los_doppler = zeros('like', los_delay);
    
    for ti = 1:length(SimParams.t)
        
        TxPos = Tx.Position + Tx.Velocity*SimParams.Ts;
        RxPos = Rx.Position + Rx.Velocity*SimParams.Ts;
        
        Tx.Position = TxPos;
        Rx.Position = RxPos;
        
        TxPosY = TxPos(2);
        RxPosY = RxPos(2);
        
        % Line-of-Sight
        los_delay(ti) = Rx.Distance(Tx)/physconst('LightSpeed');
        
        tx2rx = Rx.Position - Tx.Position;
        total_velocity = Tx.Velocity - Rx.Velocity;
        max_doppler = norm(total_velocity)/physconst('LightSpeed')*Tx.Frequency;
        
        los_doppler(ti) = (total_velocity*tx2rx')/(norm(total_velocity)*norm(tx2rx))*max_doppler;
        
        
        % Select all MPCs that lie between the Rx and Tx at time t.
        if TxPos(2) > Rx.Position(2)
            valid_scat1 = MPCs.FirstOrder((mpc1(:,2) <= TxPosY)  & (mpc1(:,2) >= RxPosY));
            valid_scat2 = MPCs.SecondOrder((mpc2(:,2) <= TxPosY) & (mpc2(:,2) >= RxPosY));
%             valid_scat3 = MPCs.ThirdOrder((mpc3(:,2) <= TxPosY)  & (mpc3(:,2) >= RxPosY));
        else
            valid_scat1 = MPCs.FirstOrder((mpc1(:,2) >= TxPosY)  & (mpc1(:,2) <= RxPosY));
            valid_scat2 = MPCs.SecondOrder((mpc2(:,2) >= TxPosY) & (mpc2(:,2) <= RxPosY));
%             valid_scat3 = MPCs.ThirdOrder((mpc3(:,2) >= TxPosY)  & (mpc3(:,2) <= RxPosY));
        end
        % First order MPCs
        delay1 = zeros(1, length(valid_scat1));
        for m = 1:length(valid_scat1)
            delay1(m) = Tx.Distance(valid_scat1(m)) + Rx.Distance(valid_scat1(m));
        end
        
        % Second order MPCs
        if isempty(cell2mat({valid_scat2.Normal}'))
            delay2 = 0;
        else
            rightWall = valid_scat2(all(cell2mat({valid_scat2.Normal}') == [-1, 0, 0], 2));
            leftWall  = valid_scat2(all(cell2mat({valid_scat2.Normal}') == [+1, 0, 0], 2));
            delay2 = zeros(1,length(rightWall)*length(leftWall));
            for m = 1:length(rightWall)
                for n = 1:length(leftWall)
                    rightMPC = rightWall(m);
                    leftMPC = leftWall(n);
                    idx = (m-1)*length(leftWall) + n;
                    delay2(idx) = Tx.Distance(rightMPC) + rightMPC.Distance(leftMPC) + leftMPC.Distance(Rx);
                end
            end
        end

        if ti > 1
            if length(delay1) > length(Delay.FirstOrder(ti-1,:))
                Delay.FirstOrder(1:ti-1,length(delay1)) = 0;
            elseif length(delay1) < length(Delay.FirstOrder(ti-1,:))
                delay1(length(Delay.FirstOrder(ti-1,:))) = 0;
            end
            if length(delay2) > length(Delay.SecondOrder(ti-1,:))
                Delay.SecondOrder(1:ti-1,length(delay2)) = 0;
            elseif length(delay2) < length(Delay.SecondOrder(ti-1,:))
                delay2(length(Delay.SecondOrder(ti-1,:))) = 0;
            end
        end
        Delay.LoS = los_delay/physconst('LightSpeed');
        Delay.FirstOrder(ti,:) = delay1;
        Delay.SecondOrder(ti,:) = delay2;
    %     Delay.ThirdOrder(ti,:) = delay3/physconst('LightSpeed');

        Doppler.LoS = los_doppler;

    end
    

end

