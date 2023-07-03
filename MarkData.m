% 1.initialize
% 2.coordinates of pipe data
% 3.coordinates of power data
% 4.coordinates of W/Q data

%%

clc;
img = imread('Loop-Cycle.png');
figure;
image(img);
axis image
set(gcf,'color','white');
grid off
set(gca,'xtick',[],'xticklabel',[])
set(gca,'ytick',[],'yticklabel',[])
% xticks(0:50:1800);
% yticks(0:50:900);

text(15,15,'T:K','Color','b')
text(15,35,'P:kPa','Color','b')
text(15,55,'M:kg/s','Color','b')
text(15,75,'H:J/kg','Color','b')
text(15,95,'power:MW','Color','b')
text(850,-30,'Data of the Loop','FontSize',20,'HorizontalAlignment','center')
text(1800,15,'Results : ','FontSize',15,'Color','r')
text(1800,50,'Power : ','FontSize',10,'Color','b')
text(-250,15,'Initial Parametes : ','FontSize',15)
text(-250,50,'SPLIT : ','FontSize',10)
text(-250,580,'STATE : ','FontSize',10)

%%

COORD = [
    150,595
    10,440
    540,365
    35,345
    115,95  % 5
    395,700
    685,515
    760,405
    875,10
    1010,520 % 10
    405,520
    670,365
    1065,10
    1200,420
    1195,0 % 15
    975,370
    645,695
    220,75
    470,180
    540,245 % 20
    220,515
    870,425
    360,85
    435,10
    1315,10  % 25
    1512,420
    1115,710
    335,180
    1595,220
    350,510 % 30
    380,355
    235,355
    1615,520
    1235,520
    760,695 % 35
    1700,170
    1425,495
    560,85
    ];

for i = 1:numel(ZULTRA(:,1))
%     switch i
%         case {2,31,18,21,12,24,15,14,36,37,30,38,7,8,35}
%             continue;
%     end
    text(COORD(i,1),COORD(i,2)+15,num2str(ZULTRA(i,1)),'HorizontalAlignment','center','FontSize',9);
    text(COORD(i,1),COORD(i,2)+30,num2str(ZULTRA(i,2)),'HorizontalAlignment','center','FontSize',9);
    text(COORD(i,1),COORD(i,2)+45,num2str(ZULTRA(i,5)),'HorizontalAlignment','center','FontSize',9);
    text(COORD(i,1),COORD(i,2)+60,num2str(ZULTRA(i,4)),'HorizontalAlignment','center','FontSize',9);
end

%%

TEMPX = -200;TEMPY = 50;
for i = 1:5
    text(TEMPX,TEMPY + i * 25,[num2str(i),' : ',num2str(ZULTRA(28+i,6))]);
end

TEMPX = -200;TEMPY = 580;
for i = 1:numel(ZULTRA(:,1))
    switch i
        case{4,6,8,9,26,28}
            TEMPY = TEMPY + 25;
            text(TEMPX,TEMPY,[num2str(i),' : ',num2str(ZULTRA(i,1)),' K']);
    end
end
TEMPX = -200;TEMPY = 730;
for i = 1:numel(ZULTRA(:,1))
    switch i
        case{8,13,25,33}
            TEMPY = TEMPY + 25;
            text(TEMPX,TEMPY,[num2str(i),' : ',num2str(ZULTRA(i,2)),' kPa']);
    end
end


%%

TEMPX = 1800;TEMPY = 50;
for i = 1:18
    text(TEMPX,TEMPY+i*25,[num2str(i),' : ',num2str(ZULTRA(i,6))],'Color','b');
end

TEMPX = 1800;TEMPY = 750;
text(TEMPX,TEMPY,['WQ\_IN : ',num2str(WQ_IN)],'Color','r');
text(TEMPX,TEMPY+25,['W\_IN : ',num2str(W_IN)],'Color','r');
text(TEMPX,TEMPY+50,['W\_OUT : ',num2str(W_OUT)],'Color','r');
text(TEMPX,TEMPY+75,['ETA : ',num2str(ETA),'%'],'Color','r');
