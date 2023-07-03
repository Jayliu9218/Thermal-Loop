% 通过回路状态与设备编号名称计算设备功率、回路效率
% 1.初始化功率表、功与吸热量
% 2.遍历设备，工质与设备交换能量表示为：(h_in - h_out) *m_in 将给工质供热的换热器换热能量计入吸热量
% 3.计算效率
% 4.结束

function [POWER,W_OUT,W_IN,WQ_IN,ETA] = CalcETA(STATE,APPARATUS,TRANS)

POWER = zeros(numel(APPARATUS),1);
[W_OUT,W_IN,WQ_IN] = deal(0);

for i = 1:numel(APPARATUS)
    POWER(i) = STATE(APPARATUS(i).FROM(1)).M * (STATE(APPARATUS(i).FROM(1)).H - STATE(APPARATUS(i).HEAD(1)).H) / TRANS;
    switch APPARATUS(i).NAME
        case 'compressor'
            W_IN = W_IN + POWER(i);
        case 'turbine'
            W_OUT = W_OUT + POWER(i);
        case 'heater'
            WQ_IN = WQ_IN + POWER(i);
        case 'exheater'
            if POWER(i) < 0
                WQ_IN = WQ_IN + POWER(i);
            end
    end
end

W_IN = -W_IN;
WQ_IN = -WQ_IN;
ETA = (W_OUT - W_IN)/WQ_IN*100;

end