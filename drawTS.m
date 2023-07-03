LIST = [
    2,1,1;
    1,3,1;
    3,4,0;
    4,5,1;
    2,5,0;
    5,6,1;
    6,7,1;
    7,8,0;
    8,9,1;
    9,6,0;
    8,10,0;
    10,11,1;
    11,12,1;
    12,9,0;
    10,13,0;
    13,14,1;
    14,15,1;
    15,16,1;
    16,17,1;
    17,1,1;
    ];


figure;

for numL = 1:numel(LIST(:,1))

    if LIST(numL,3) == 1
        tempT = linspace(Loop(LIST(numL,1)).T,Loop(LIST(numL,2)).T,1E2);
        tempS = zeros(1E2,1);
        for j = 1:1E2
            tempS(j) = refpropm('S','T',tempT(j),'P',Loop(LIST(numL,1)).P,'CO2');
        end
        plot(tempS,tempT);
        hold on
    else
        tempT = linspace(Loop(LIST(numL,1)).T,Loop(LIST(numL,2)).T,1E2);
        tempS = linspace(Loop(LIST(numL,1)).S,Loop(LIST(numL,2)).S,1E2);
        plot(tempS,tempT);
        hold on
    end

end

xlabel('S - J/(kg*K)')
ylabel('T - K')
title('Temperature & Entropy Map of the Thermal System')