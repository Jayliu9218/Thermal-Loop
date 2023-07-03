% 根据管道已知状态参量补充剩余参量

function STATE = UpdateTPSH(STATE)
for i = 1:numel(STATE)
    TEMP = [STATE(i).T;STATE(i).P;STATE(i).S;STATE(i).H];
    if sum(TEMP>0) == 2
        if STATE(i).T && STATE(i).P
            if ~STATE(i).H
                STATE(i).H = refpropm('H','T',STATE(i).T,'P',STATE(i).P,'CO2');
            end
            if ~STATE(i).S
                STATE(i).S = refpropm('S','T',STATE(i).T,'P',STATE(i).P,'CO2');
            end
            return;
        end

        if STATE(i).P && STATE(i).H
            if ~STATE(i).T
                STATE(i).T = refpropm('T','P',STATE(i).P,'H',STATE(i).H,'CO2');
            end
            if ~STATE(i).S
                STATE(i).S = refpropm('S','P',STATE(i).P,'H',STATE(i).H,'CO2');
            end
            return;
        end

        if STATE(i).P && STATE(i).S
            if ~STATE(i).T
                STATE(i).T = refpropm('T','P',STATE(i).P,'S',STATE(i).S,'CO2');
            end
            if ~STATE(i).H
                STATE(i).H = refpropm('H','P',STATE(i).P,'S',STATE(i).S,'CO2');
            end
            return;
        end
    end

    if sum(TEMP>0) == 3
        if STATE(i).P && STATE(i).S
            if ~STATE(i).T
                STATE(i).T = refpropm('T','P',STATE(i).P,'S',STATE(i).S,'CO2');
            end
            if ~STATE(i).H
                STATE(i).H = refpropm('H','T',STATE(i).T,'P',STATE(i).P,'CO2');
            end
            return;
        end

        if STATE(i).P && STATE(i).T
            if ~STATE(i).S
                STATE(i).S = refpropm('S','T',STATE(i).T,'P',STATE(i).P,'CO2');
            end
            if ~STATE(i).H
                STATE(i).H = refpropm('H','P',STATE(i).P,'T',STATE(i).T,'CO2');
            end
        end
    end
    
end