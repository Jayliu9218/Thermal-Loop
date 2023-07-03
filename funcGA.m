% defination of GA func

function GA = funcGA
GA.PICK = @PICK;
GA.CROSS = @CROSS;
GA.MUTATE = @MUTATE;
GA.SORT = @SORT;
GA.FFSPLIT = @FFSPLIT;
GA.FFSTATE = @FFSTATE;
GA.FFALL = @FFALL;
GA.xTOz = @xTOz;
GA.FFZ = @FFZ;
GA.tempxTOz = @tempxTOz;
end


function p = PICK(Parent)
n = randperm(numel(Parent));
p1 = Parent(n(1));
p2 = Parent(n(2));
if p1.y > p2.y
    p = p1;
else
    p = p2;
end
end


function p = MUTATE(p,mu)
for j = 1:numel(p.xz)
    for i = 1:numel(p.xz(j).x)
        if rand < mu
            p.xz(j).x(i) = ~p.xz(j).x(i);
        end
    end
end
end


function [cp1,cp2] = CROSS(p1,p2,nVar,n)
for i = 1:n
    cp1.xz(i).x = [p1.xz(i).x(1:nVar/2);p2.xz(i).x(nVar/2+1:end)];
    cp2.xz(i).x = [p2.xz(i).x(1:nVar/2);p1.xz(i).x(nVar/2+1:end)];
end
end


function newPop = SORT(newPop)
for k = 1:numel(newPop)
    for m = 1:k
        if newPop(m).y < newPop(k).y
            temp = newPop(m);
            newPop(m) = newPop(k);
            newPop(k) = temp;
        end
    end
end
end


function xz = xTOz(xz,~,~)
nx=numel(xz(1).x);
nxz = numel(xz);
z=zeros(nxz,1);

for i = 1 : nxz
    z(i) = 0;
    for k = 1:nx
        z(i) = z(i) + xz(i).x(k)*2^(k-1);
    end
end

if nargin == 1
    for i = 1:nxz
        xz(i).z = z(i)/(pow2(nx)-1);
    end
    return;
end

if nargin == 3
    for i = 11:nxz
        xz(i).z = z(i)/(pow2(nx)-1);
    end
end

for i = 1:10
    switch i
        case 1
            RANGE = linspace(305,395,pow2(nx));
        case 2
            RANGE = linspace(500,700,pow2(nx));
        case 3
            RANGE = linspace(900,1400,pow2(nx));
        case 4
            RANGE = linspace(500,800,pow2(nx));
        case 5
            RANGE = linspace(500,700,pow2(nx));
        case 6
            RANGE = linspace(1.8e4,2.5e4,pow2(nx));
        case 7
            RANGE = linspace(1.3e4,2.2e4,pow2(nx));
        case 8
            RANGE = linspace(1.0e4,1.8e4,pow2(nx));
        case 9
            RANGE = linspace(0.75e4,1.5e4,pow2(nx));
        otherwise
            RANGE = linspace(600,820,pow2(nx));
    end
    xz(i).z = RANGE(z(i) + 1);
end

A = randi([5 20]);
B = randi([1E3 2E3]);

for i = randperm(10)
    switch i
        case 1
            TEMP = refpropm('T','P',xz(9).z,'S',refpropm('S','T',xz(2).z,'P',xz(6).z,'CO2'),'CO2');
            if xz(i).z >= TEMP
                xz(i).z = TEMP - A;
            end
            xz(i).z = max(305,xz(i).z);
        case 2
            if xz(i).z >= xz(10).z
                xz(i).z = xz(10).z - A;
            end
            if xz(i).z <= xz(5).z
                xz(i).z = xz(5).z + A;
            end
        case 3
            if xz(i).z <= xz(10).z
                xz(i).z = xz(10).z + A;
            end
        case 4
            TEMP = refpropm('T','P',xz(8).z,'S',refpropm('S','T',xz(3).z,'P',xz(6).z,'CO2')/(0.995*0.995),'CO2');
            if xz(i).z >= TEMP
                xz(i).z = TEMP  - A;
            end
        case 5
            if xz(i).z >= xz(2).z
                xz(i).z = xz(2).z  - A;
            end
        case 6
            if xz(i).z <= xz(7).z
                xz(i).z = xz(7).z + B;
            end
        case 7
            if xz(i).z >= xz(6).z
                xz(i).z = xz(6).z  - B;
            end
            if xz(i).z <= xz(8).z
                xz(i).z = xz(8).z  + B;
            end
        case 8
            if xz(i).z >= xz(7).z
                xz(i).z = xz(7).z  - B;
            end
            if xz(i).z <= xz(9).z
                xz(i).z = xz(9).z  + B;
            end
        case 9
            if xz(i).z >= xz(8).z
                xz(i).z = xz(8).z  - B;
            end
        otherwise
            if xz(i).z <= xz(2).z
                xz(i).z = xz(2).z + A;
            end
            if xz(i).z >= xz(3).z
                xz(i).z = xz(3).z - A;
            end
    end
end

end


function ETA = FFSPLIT(xz)
load Cycle_APPARATUS.mat APPARATUS
[REACTOR,ISEN] = deal([10;100E6],0.995);
SPLIT = zeros(5,1);
for i = 1:5
    SPLIT(i) = xz(i).z;
end
load Cycle_STATE.mat STATE
STATE = CalcLoop(STATE,SPLIT,REACTOR,ISEN,APPARATUS);
[~,~,~,~,ETA] = CalcETA(STATE,APPARATUS,1E6);
end


function ETA = FFSTATE(xz)
load Cycle_APPARATUS.mat APPARATUS
load Cycle_STATE.mat STATE
[REACTOR,ISEN] = deal([10;100E6],0.995);
SPLIT = [0.5;0.5;0.5;0.5;0.5];
STATE(4).T = xz(1).z;
STATE(6).T = xz(2).z;
STATE(9).T = xz(3).z;
STATE(26).T = xz(4).z;
STATE(28).T = xz(5).z;
STATE(8).P = xz(6).z;
STATE(13).P = xz(7).z;
STATE(25).P = xz(8).z;
STATE(33).P = xz(9).z;
STATE(8).T = xz(10).z;
ORIGIN = STATE;

Tset = STATE(8).T;
STATE = CalcLoop(STATE,SPLIT,REACTOR,ISEN,APPARATUS);
Tcal = STATE(8).T;

while abs(Tset - Tcal) > 1e-2
    STATE = ORIGIN;

    STATE(8).T = (Tset+19*Tcal)/20;
    Tset = STATE(8).T;
    STATE = CalcLoop(STATE,SPLIT,REACTOR,ISEN,APPARATUS);
    Tcal = STATE(8).T;
end
[~,~,~,~,ETA] = CalcETA(STATE,APPARATUS,1E6);
end


function ETA = FFALL(xz)
load Cycle_APPARATUS.mat APPARATUS
load Cycle_STATE.mat STATE
[REACTOR,ISEN] = deal([10;100E6],0.995);

STATE(4).T = xz(1).z;
STATE(6).T = xz(2).z;
STATE(9).T = xz(3).z;
STATE(26).T = xz(4).z;
STATE(28).T = xz(5).z;
STATE(8).P = xz(6).z;
STATE(13).P = xz(7).z;
STATE(25).P = xz(8).z;
STATE(33).P = xz(9).z;
STATE(8).T = xz(10).z;
ORIGIN = STATE;

SPLIT = zeros(5,1);
for i = 1:5
    SPLIT(i) = xz(i+10).z;
end

Tset = STATE(8).T;
STATE = CalcLoop(STATE,SPLIT,REACTOR,ISEN,APPARATUS);
Tcal = STATE(8).T;

while abs(Tset - Tcal) > 1
    STATE = ORIGIN;

    STATE(8).T = (Tset+19*Tcal)/20;
    Tset = STATE(8).T;
    STATE = CalcLoop(STATE,SPLIT,REACTOR,ISEN,APPARATUS);
    Tcal = STATE(8).T;
end

[~,~,~,~,ETA] = CalcETA(STATE,APPARATUS,1E6);
end



function ETA = FFZ(xz)
load z_APPARATUS.mat APPARATUS
load z_STATE.mat STATE
load z_Data.mat Data

[REACTOR,ISEN,TRANS,SPLIT] = deal(Data(1,1:2),Data(1,3),Data(1,4),Data(:,5));

STATE(3).T = xz(1).z;
STATE(5).T = xz(2).z;
STATE(9).T = xz(3).z;
STATE(12).T = xz(4).z;
STATE(13).T = xz(5).z;
STATE(18).T = xz(6).z;
STATE(5).P = xz(7).z;
STATE(12).P = xz(8).z;
STATE(16).P = xz(9).z;
STATE(18).P = xz(10).z;
STATE(19).P = xz(11).z;
STATE(23).P = xz(12).z;

SPLIT = zeros(2,1);
for i = 1:2
    SPLIT(i) = xz(i+12).z;
end

STATE = CalcLoop(STATE,SPLIT,REACTOR,ISEN,APPARATUS);

[~,~,~,~,ETA] = CalcETA(STATE,APPARATUS,TRANS);
end


function xz = tempxTOz(xz,~,~)
nx=numel(xz(1).x);
nxz = numel(xz);
z=zeros(nxz,1);

for i = 1 : nxz
    z(i) = 0;
    for k = 1:nx
        z(i) = z(i) + xz(i).x(k)*2^(k-1);
    end
end

if nargin == 1
    for i = 1:nxz
        xz(i).z = z(i)/(pow2(nx)-1);
    end
    return;
end

if nargin == 3
    for i = 13:nxz
        xz(i).z = z(i)/(pow2(nx)-1);
    end
end

for i = 1:12
    switch i
        case 1
            RANGE = linspace(305,330,pow2(nx));
        case 2
            RANGE = linspace(340,380,pow2(nx));
        case 3
            RANGE = linspace(700,800,pow2(nx));
        case 4
            RANGE = linspace(390,450,pow2(nx));
        case {5,6}
            RANGE = linspace(900,1200,pow2(nx));
        case 7
            RANGE = linspace(1.4e4,1.8e4,pow2(nx));
        case 8
            RANGE = linspace(2.0e4,2.5e4,pow2(nx));
        case {9,11}
            RANGE = linspace(1.3e4,1.6e4,pow2(nx));
        case 10
            RANGE = linspace(1.0e4,1.2e4,pow2(nx));
        case 12
            RANGE = linspace(0.75e4,0.95e4,pow2(nx));
    end
    xz(i).z = RANGE(z(i) + 1);
end
xz(6).z = xz(5).z;
xz(11).z = xz(9).z;
end

