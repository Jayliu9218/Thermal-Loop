function [STATE,NUM_EQ] = CalcMass(STATE,SPLIT,REACTOR,ISEN,APPARATUS)
[STATE,nS,nA] = deal(UpdateTPSH(STATE),numel(STATE),numel(APPARATUS));
[COEFF,B] = deal(zeros(nS,nS),zeros(nS,1));

numS = 1;
for numA = 1:nA
    APPARATUS(numA).SPLIT = -1;
    if strcmp(APPARATUS(numA).NAME,'spliter')
        APPARATUS(numA).SPLIT = SPLIT(numS);
        numS = numS + 1;
    end
end

NUM_EQ = 0;
numMassEQ = 1;
for numA = 1:nA
    FROM = APPARATUS(numA).FROM;
    HEAD = APPARATUS(numA).HEAD;
    TEMPSPLIT = APPARATUS(numA).SPLIT;
    switch APPARATUS(numA).NAME
        case {'turbine','compressor'}
            COEFF(numMassEQ,FROM) = 1;
            COEFF(numMassEQ,HEAD) = -1;
            numMassEQ = numMassEQ + 1;
            NUM_EQ = NUM_EQ+1;
        case {'heater','exheater'}
            COEFF(numMassEQ,FROM) = 1;
            COEFF(numMassEQ,HEAD) = -1;
            numMassEQ = numMassEQ + 1;
        case 'reheater'
            COEFF(numMassEQ,FROM(1)) = 1;
            COEFF(numMassEQ,HEAD(1)) = -1;
            COEFF(numMassEQ + 1,FROM(2)) = 1;
            COEFF(numMassEQ + 1,HEAD(2)) = -1;
            numMassEQ = numMassEQ + 2;
            NUM_EQ = NUM_EQ+1;
        case 'spliter'
            COEFF(numMassEQ,FROM) = 1;
            COEFF(numMassEQ,HEAD(1)) = -1;
            COEFF(numMassEQ,HEAD(2)) = -1;
            COEFF(numMassEQ + 1,FROM) = -TEMPSPLIT;
            COEFF(numMassEQ + 1,HEAD(1)) = 1;
            numMassEQ = numMassEQ + 2;
            NUM_EQ = NUM_EQ+2;
        case 'mixer'
            COEFF(numMassEQ,HEAD) = 1;
            COEFF(numMassEQ,FROM(1)) = - 1;
            COEFF(numMassEQ,FROM(2)) = - 1;
            numMassEQ = numMassEQ + 1;
            NUM_EQ = NUM_EQ+2;
    end
end

STATE = SetAppCollect(STATE,APPARATUS,ISEN,0);
B(nS) = REACTOR(2);
COEFF(nS,APPARATUS(REACTOR(1)).FROM) = -STATE(APPARATUS(REACTOR(1)).FROM).H;
COEFF(nS,APPARATUS(REACTOR(1)).HEAD) =  STATE(APPARATUS(REACTOR(1)).HEAD).H;

MASS = COEFF\B;

for numS = 1:nS
    STATE(numS).M = MASS(numS);
end
end