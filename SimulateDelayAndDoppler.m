function [Delay, Doppler] = SimulateDelayAndDoppler(SimParams, MPCs, Tx, Rx)

    Delay = struct();
    Doppler = struct();


    mpc1 = cell2mat({MPCs.FirstOrder.Position}');
    mpc2 = cell2mat({MPCs.SecondOrder.Position}');
    mpc3 = cell2mat({MPCs.ThirdOrder.Position}');

    los_delay = zeros(length(SimParams.t), 1);
    los_doppler = zeros('like', los_delay);
    
    wb = waitbar(0,'Please wait...');
    
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
        
        
        % Select all MPCs that lie between the Rx and Tx at time t
        if TxPos(2) > Rx.Position(2)
            valid_scat1 = MPCs.FirstOrder((mpc1(:,2) <= TxPosY)  & (mpc1(:,2) >= RxPosY));
            valid_scat2 = MPCs.SecondOrder((mpc2(:,2) <= TxPosY) & (mpc2(:,2) >= RxPosY));
            valid_scat3 = MPCs.ThirdOrder((mpc3(:,2) <= TxPosY)  & (mpc3(:,2) >= RxPosY));
        else
            valid_scat1 = MPCs.FirstOrder((mpc1(:,2) >= TxPosY)  & (mpc1(:,2) <= RxPosY));
            valid_scat2 = MPCs.SecondOrder((mpc2(:,2) >= TxPosY) & (mpc2(:,2) <= RxPosY));
            valid_scat3 = MPCs.ThirdOrder((mpc3(:,2) >= TxPosY)  & (mpc3(:,2) <= RxPosY));
        end
        
        %%%%%%%%%%%%%%%%%%%%%
        % First order MPCs  %
        %%%%%%%%%%%%%%%%%%%%%
        delay1 = zeros(1, length(valid_scat1));
        doppler1 = zeros('like', delay1);
        for m = 1:length(valid_scat1)
            mpc = valid_scat1(m);
            mpc2rx = Rx.Position - mpc.Position;
            delay1(m) = Tx.Distance(mpc) + Rx.Distance(mpc);
            doppler1(m) = (total_velocity*mpc2rx')/(norm(total_velocity)*norm(mpc2rx))*max_doppler;
        end
        
        %%%%%%%%%%%%%%%%%%%%%
        % Second order MPCs %
        %%%%%%%%%%%%%%%%%%%%%
        delay2 = zeros(1,length(valid_scat2));
        doppler2 = zeros('like', delay2);
        if ~isempty(cell2mat({valid_scat2.Normal}'))
            rightWall = valid_scat2(all(cell2mat({valid_scat2.Normal}') == [-1, 0, 0], 2));
            leftWall  = valid_scat2(all(cell2mat({valid_scat2.Normal}') == [+1, 0, 0], 2));
            
            delay2 = zeros(1,length(rightWall)*length(leftWall));
            doppler2 = zeros('like', delay2);

            for m = 1:length(rightWall)
                for n = 1:length(leftWall)
                    rightMPC = rightWall(m);
                    leftMPC = leftWall(n);
                    idx = (m-1)*length(leftWall) + n;
                    delay2(idx) = Tx.Distance(rightMPC) + rightMPC.Distance(leftMPC) + leftMPC.Distance(Rx);
                    if Rx.Distance(leftMPC) < Rx.Distance(rightMPC)
                        mpc2rx = Rx.Position - leftMPC.Position;
                    else
                        mpc2rx = Rx.Position - rightMPC.Position;
                    end
                    doppler2(idx) = (total_velocity*mpc2rx')/(norm(total_velocity)*norm(mpc2rx))*max_doppler;
                end
            end
        end

        
        %%%%%%%%%%%%%%%%%%%%%
        % Third order MPCs %
        %%%%%%%%%%%%%%%%%%%%%
        delay3 = zeros(1,length(valid_scat3));
        doppler3 = zeros('like', delay3);
        if ~isempty(cell2mat({valid_scat3.Normal}'))
            rightWall = valid_scat3(all(cell2mat({valid_scat3.Normal}') == [-1, 0, 0], 2));
            leftWall  = valid_scat3(all(cell2mat({valid_scat3.Normal}') == [+1, 0, 0], 2));
            [delay3_1, doppler3_1] = ThirdOrderReflection(rightWall,  leftWall, Tx,  Rx);
            [delay3_2, doppler3_2] = ThirdOrderReflection(leftWall,  rightWall, Tx,  Rx);
            delay3 = [delay3_1, delay3_2];
            doppler3 = [doppler3_1, doppler3_2];
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %   Make sure the matrices grow as needed.
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if ti > 1
            if length(delay1) > length(Delay.FirstOrder(ti-1,:))
                Delay.FirstOrder(1:ti-1,length(delay1)) = 0;
                Doppler.FirstOrder(1:ti-1,length(doppler1)) = 0;
            elseif length(delay1) < length(Delay.FirstOrder(ti-1,:))
                delay1(length(Delay.FirstOrder(ti-1,:))) = 0;
                doppler1(length(Doppler.FirstOrder(ti-1,:))) = 0;
            end
            if length(delay2) > length(Delay.SecondOrder(ti-1,:))
                Delay.SecondOrder(1:ti-1,length(delay2)) = 0;
                Doppler.SecondOrder(1:ti-1,length(doppler2)) = 0;
            elseif length(delay2) < length(Delay.SecondOrder(ti-1,:))
                delay2(length(Delay.SecondOrder(ti-1,:))) = 0;
                doppler2(length(Doppler.SecondOrder(ti-1,:))) = 0;
            end
            if length(delay3) > length(Delay.ThirdOrder(ti-1,:))
                Delay.ThirdOrder(1:ti-1,length(delay3)) = 0;
                Doppler.ThirdOrder(1:ti-1,length(doppler3)) = 0;
            elseif length(delay3) < length(Delay.ThirdOrder(ti-1,:))
                delay3(length(Delay.ThirdOrder(ti-1,:))) = 0;
                doppler3(length(Doppler.ThirdOrder(ti-1,:))) = 0;
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %   Add results to structs
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Delay.LoS = los_delay;
        Delay.FirstOrder(ti,:)  = delay1;
        Delay.SecondOrder(ti,:) = delay2;
        Delay.ThirdOrder(ti,:) = delay3;

        Doppler.LoS = los_doppler';
        Doppler.FirstOrder(ti,:) = doppler1;
        Doppler.SecondOrder(ti,:) = doppler2;
        Doppler.ThirdOrder(ti,:) = doppler3;
        
        waitbar(ti / length(SimParams.t))

    end
    
    close(wb);

end

