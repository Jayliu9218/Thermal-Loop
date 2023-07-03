% 计算回路主程序
% 1.根据分流系数计算总质量流量、质量流量分布
% 2.遍历设备，根据设备过程补充参数
% 注：请勿将分流器或热源设置在设备列表最后一位

function STATE = CalcLoop(STATE,SPLIT,REACTOR,ISEN,APPARATUS)

[STATE,NUM_EQ] = CalcMass(STATE,SPLIT,REACTOR,ISEN,APPARATUS);

for num_eq = 1:NUM_EQ
    STATE = SetAppCollect(STATE,APPARATUS,ISEN,1);
end