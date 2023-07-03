% 根据设备编号遍历设备，根据回路状态已有参数、设备的实际物理过程补充回路状态剩余参数
% 1.初始化，根据温度与压力值更新回路状态焓熵值
% 2.遍历设备，根据设备工质经过的物理过程补充剩余参数
% 3.更新焓熵值
% 4.结束

function STATE = SetAppCollect(STATE,APPARATUS,ISEN,JUDGE)
App = funcAppCollect;
STATE = UpdateTPSH(STATE);
for numA = 1:numel(APPARATUS)
    FROM = APPARATUS(numA).FROM;
    HEAD = APPARATUS(numA).HEAD;
    switch APPARATUS(numA).NAME
        case 'turbine'
            STATE = UpdateTPSH(STATE);
            STATE = App.turbine(STATE,FROM,HEAD,ISEN);
        case 'heater'
            STATE = App.heater(STATE,FROM,HEAD);
        case 'reheater'
            STATE = App.reheater(STATE,FROM,HEAD,JUDGE);
        case 'exheater'
            STATE = App.exheater(STATE,FROM,HEAD);
        case 'compressor'
            STATE = UpdateTPSH(STATE);
            STATE = App.compressor(STATE,FROM,HEAD,ISEN);
        case 'spliter'
            STATE = App.spliter(STATE,FROM,HEAD);
        case 'mixer'
            STATE = App.mixer(STATE,FROM,HEAD);
    end
end
STATE = UpdateTPSH(STATE);
end
