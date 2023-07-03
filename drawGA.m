%% SPLIT

TEMP = max(unnamed(:,6));
figure;
for i = 1:5
    plot(unnamed(:,7),unnamed(:,i),'LineWidth',2);
    hold on
end
plot(unnamed(:,7),unnamed(:,6)/TEMP,'LineWidth',2);

legend('SPLIT1','SPLIT2','SPLIT3','SPLIT4','SPLIT5','ETA(Nomal)');
xlabel('iter times');
title(['Optimization of ETA by GA on SPLIT , max ETA : ',num2str(TEMP),'%'])
grid;

%% STATE

TEMP = max(unnamed(:,11));
figure;
for i = [1,2,3,4,5,10]
    plot(unnamed(:,12),unnamed(:,i),'LineWidth',2);
    hold on
end
% plot(unnamed(:,12),unnamed(:,11)/TEMP,'LineWidth',2);

legend('STATE1','STATE2','STATE3','STATE4','STATE5','STATE10')
% legend('STATE6','STATE7','STATE8','STATE9')
xlabel('iter times');
title(['Optimization of ETA by GA on STATE , max ETA : ',num2str(TEMP),'%'])
grid;

%%

