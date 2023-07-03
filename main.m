% 1.设置基本参数
% 2.计算回路状态与校正
% 3.总结数据
% 4.复位

clc;clear;

disp('Loading initial data...');tic;
load Cycle_APPARATUS.mat APPARATUS
try
    load Cycle_Data.mat
catch
    disp('no Cycle_Data file')
    REACTOR = [10;100E6];
    ISEN = 1;
    TRANS = 1E6;
    SPLIT = ones(nueml(APPARATUS),1);
end
load Cycle_STATE.mat STATE
disp('Loading finished.');toc;

disp('Calculating the loop...');tic;
STATE = CalcLoop(STATE,SPLIT,REACTOR,ISEN,APPARATUS);
disp('Calculating finished.');toc;

[POWER,W_OUT,W_IN,WQ_IN,ETA] = CalcETA(STATE,APPARATUS,1E6);
ZULTRA = [[STATE.T]',[STATE.P]',[STATE.S]',[STATE.H]',[STATE.M]',[POWER;SPLIT;WQ_IN;W_IN;W_OUT;0;ETA]];

save Cycle_Data.mat REACTOR ISEN TRANS SPLIT
disp('DONE ! ');

