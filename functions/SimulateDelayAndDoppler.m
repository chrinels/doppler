function [Delay, Doppler] = SimulateDelayAndDoppler(SimParams, MPCs, Tx, Rx, f)

    Delay = struct();
    Doppler = struct();


    mpc1 = cell2mat({MPCs.FirstOrder.Position}');
    mpc2 = cell2mat({MPCs.SecondOrder.Position}');
    mpc3 = cell2mat({MPCs.ThirdOrder.Position}');
        
    for ti = 1:length(SimParams.t)


        Tx.Position = Tx.Position + Tx.Velocity*SimParams.Ts;
        Rx.Position = Rx.Position + Rx.Velocity*SimParams.Ts;

        % Line-of-Sight
        los_delay = Rx.Distance(Tx);

        tx2rx = Rx.Position - Tx.Position;
        total_velocity = Tx.Velocity - Rx.Velocity;
        max_doppler = norm(total_velocity)/physconst('LightSpeed')*f;

        los_doppler = (total_velocity*tx2rx')/(norm(total_velocity)*norm(tx2rx))*max_doppler;

        maxPos = max(Rx.Position(2), Tx.Position(2));
        minPos = min(Rx.Position(2), Tx.Position(2));
        % Select all MPCs that lie between the Rx and Tx at time t
        valid_scat1 = MPCs.FirstOrder ( (mpc1(:,2) < maxPos) & (mpc1(:,2) > minPos));
        valid_scat2 = MPCs.SecondOrder( (mpc2(:,2) < maxPos) & (mpc2(:,2) > minPos));
        valid_scat3 = MPCs.ThirdOrder ( (mpc3(:,2) < maxPos) & (mpc3(:,2) > minPos));


        %%%%%%%%%%%%%%%%%%%%%
        % First order MPCs  %
        %%%%%%%%%%%%%%%%%%%%%
        [delay1,doppler1_scaling] = FirstOrderReflection(valid_scat1,Tx,Rx);
        doppler1 = doppler1_scaling*max_doppler;

        %%%%%%%%%%%%%%%%%%%%%
        % Second order MPCs %
        %%%%%%%%%%%%%%%%%%%%%
        [delay2, doppler2_scaling] = SecondOrderReflection(valid_scat2,Tx,Rx);
        doppler2 = doppler2_scaling*max_doppler;


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
            delay3 = [delay3_1', delay3_2'];
            doppler3 = [doppler3_1', doppler3_2']*max_doppler;
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %   Make sure the matrices grow as needed.
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if ti > 1
            currDelay = length(delay1);
            prevDelay = length(Delay.FirstOrder(ti-1,:));
            if currDelay > prevDelay
                Delay.FirstOrder(1:ti-1,currDelay)   = 0;
                Doppler.FirstOrder(1:ti-1,currDelay) = 0;
            elseif currDelay < prevDelay
                delay1  (length(Delay.FirstOrder(ti-1,:)))     = 0;
                doppler1(length(Doppler.FirstOrder(ti-1,:)))   = 0;
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
        Delay.LoS(ti,:) = los_delay;
        Delay.FirstOrder(ti,:)  = delay1;
        Delay.SecondOrder(ti,:) = delay2;
        Delay.ThirdOrder(ti,:) = delay3;

        Doppler.LoS(ti,:) = los_doppler;
        Doppler.FirstOrder(ti,:) = doppler1;
        Doppler.SecondOrder(ti,:) = doppler2;
        Doppler.ThirdOrder(ti,:) = doppler3;

    end

    

end

