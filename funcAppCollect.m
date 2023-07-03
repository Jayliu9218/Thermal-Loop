% 定义设备过程：等压，等熵……

function App = funcAppCollect
App.heater = @heater;
App.exheater = @exheater;
App.compressor = @compressor;
App.turbine = @turbine;
App.mixer = @mixer;
App.spliter = @spliter;
App.reheater = @reheater;
end


function STATE = heater(STATE,HEAD,FROM)
if  STATE(FROM).P
    STATE(HEAD).P = STATE(FROM).P;
elseif  STATE(HEAD).P
    STATE(FROM).P = STATE(HEAD).P;
end
end


function STATE = exheater(STATE,HEAD,FROM)
if  STATE(FROM).P
    STATE(HEAD).P = STATE(FROM).P;
elseif  STATE(HEAD).P
    STATE(FROM).P = STATE(HEAD).P;
end
end


function STATE = compressor(STATE,FROM,HEAD,ISEN)
if STATE(FROM).S
    STATE(HEAD).S = STATE(FROM).S / ISEN;
elseif STATE(HEAD).S
    STATE(FROM).S = STATE(HEAD).S * ISEN;
end
end


function STATE = turbine(STATE,FROM,HEAD,ISEN)
if STATE(FROM).S
    STATE(HEAD).S = STATE(FROM).S / ISEN;
elseif STATE(HEAD).S
    STATE(FROM).S = STATE(HEAD).S * ISEN;
end
end


function STATE = mixer(STATE,FROM,HEAD)
PLIST = [STATE(FROM(1)).P;STATE(FROM(2)).P;STATE(HEAD).P];
notEmpty = find(PLIST);
try
    [STATE(FROM(1)).P,STATE(FROM(2)).P,STATE(HEAD).P] = deal(PLIST(notEmpty(1)));
catch
    ...
end
TLIST = [STATE(FROM(1)).T;STATE(FROM(2)).T;STATE(HEAD).T];
notEmpty = find(TLIST);
try
    [STATE(FROM(1)).T,STATE(FROM(2)).T,STATE(HEAD).T] = deal(TLIST(notEmpty(1)));
catch
    ...
end
end


function STATE = spliter(STATE,FROM,HEAD)
PList = [STATE(HEAD(1)).P;STATE(HEAD(2)).P;STATE(FROM).P];
notEmpty = find(PList);
try
    [STATE(HEAD(1)).P,STATE(HEAD(2)).P,STATE(FROM).P] = deal(PList(notEmpty(1)));
catch
    ...
end

TList = [STATE(HEAD(1)).T;STATE(HEAD(2)).T;STATE(FROM).T];
notEmpty = find(TList);
try
[STATE(HEAD(1)).T,STATE(HEAD(2)).T,STATE(FROM).T] = deal(TList(notEmpty(1)));
catch
    ...
end
end


function STATE = reheater(STATE,FROM,HEAD,JUDGE)
if  STATE(FROM(1)).P
    STATE(HEAD(1)).P = STATE(FROM(1)).P;
elseif  STATE(HEAD(1)).P
    STATE(FROM(1)).P = STATE(HEAD(1)).P;
end
if  STATE(FROM(2)).P
    STATE(HEAD(2)).P = STATE(FROM(2)).P;
elseif  STATE(HEAD(2)).P
    STATE(FROM(2)).P = STATE(HEAD(2)).P;
end

if JUDGE && (STATE(FROM(1)).M == 0 || STATE(FROM(2)).M == 0)
    [STATE(FROM(1)).H,STATE(HEAD(1)).H] = deal(max([STATE(FROM(1)).H;STATE(HEAD(1)).H]));
    [STATE(FROM(2)).H,STATE(HEAD(2)).H] = deal(max([STATE(FROM(2)).H;STATE(HEAD(2)).H]));
    return;
end

HList = [STATE(FROM(1)).H;STATE(FROM(2)).H;STATE(HEAD(1)).H;STATE(HEAD(2)).H];
MList = [STATE(FROM(1)).M;STATE(FROM(2)).M;STATE(HEAD(1)).M;STATE(HEAD(2)).M];
AList = [FROM(1);FROM(2);HEAD(1);HEAD(2)];
if sum(HList>0) == 3
    Unknown = find(~HList);
    % in case of T : head2 > from1
    STATE(HEAD(2)).T = min([STATE(HEAD(2)).T;STATE(FROM(1)).T]);
    STATE = UpdateTPSH(STATE);
    HList = [STATE(FROM(1)).H;STATE(FROM(2)).H;STATE(HEAD(1)).H;STATE(HEAD(2)).H];

    if Unknown<=2
        STATE(AList(Unknown)).H = (MList(3)*HList(3)+MList(4)*HList(4)-MList(3-Unknown)*HList(3-Unknown))/MList(Unknown);
    else
        STATE(AList(Unknown)).H = (MList(1)*HList(1)+MList(2)*HList(2)-MList(7-Unknown)*HList(7-Unknown))/MList(Unknown);
    end

    try
        STATE(AList(Unknown)).T = refpropm('T','H',STATE(AList(Unknown)).H,'P',STATE(AList(Unknown)).P,'CO2');
        STATE(AList(Unknown)).T = min([STATE(FROM(1)).T;STATE(AList(Unknown)).T]);
    catch
        STATE(AList(Unknown)).T = STATE(FROM(1)).T;
    end
    STATE(AList(Unknown)).H = refpropm('H','T',STATE(AList(Unknown)).T,'P',STATE(AList(Unknown)).P,'CO2');
end

end