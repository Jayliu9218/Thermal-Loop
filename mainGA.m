tic;clc;clear;

nVar = 14;
nPop = 20;
nPc = 0.6;
nC = round(nPc*nPop / 2)*2;
MaxIt = 5E2;
mu = 0.02;
nPara = 10;

GA = funcGA;
xz.x = [];
xz.z = [];
template.xz = repmat(xz,nPara,1);
template.y = [];

Parent = repmat(template,nPop,1);

for i =1:nPop
    for j = 1:10
        Parent(i).xz(j).x = randi([0 1],nVar,1);
    end
    Parent(i).xz = GA.xTOz(Parent(i).xz,j);
    Parent(i).y = GA.FFSTATE(Parent(i).xz);
    disp(['INITIAL...',num2str(i),'/',num2str(nPop)])
end

disp('INITIAL DONE!')

for i = 1:MaxIt

    Offspring = repmat(template,nC,1);
    for j = 1:nC/2
        % Pick
        p1 = GA.PICK(Parent);
        p2 = GA.PICK(Parent);

        % Cross
        [cp1,cp2] = GA.CROSS(p1,p2,nVar,10);

        % Mutate
        cp1 = GA.MUTATE(cp1,mu);
        cp2 = GA.MUTATE(cp2,mu);

        cp1.xz = GA.xTOz(cp1.xz,i);
        cp2.xz = GA.xTOz(cp1.xz,i);

        cp1.y = GA.FFSTATE(cp1.xz);
        cp2.y = GA.FFSTATE(cp2.xz);

        Offspring(j) = cp1;
        Offspring(j + nC/2) = cp2;
        clear cp1 cp2
    end

    newPop = GA.SORT([Parent;Offspring]);

    Parent = newPop(1:nPop);
    disp(['STATE ETA ITER : ', ...
        num2str(Parent(1).xz(1).z) ,' ',...
        num2str(Parent(1).xz(2).z) ,' ',...
        num2str(Parent(1).xz(3).z) ,' ',...
        num2str(Parent(1).xz(4).z) ,' ',...
        num2str(Parent(1).xz(5).z) ,' ',...
        num2str(Parent(1).xz(6).z) ,' ',...
        num2str(Parent(1).xz(7).z) ,' ',...
        num2str(Parent(1).xz(8).z) ,' ',...
        num2str(Parent(1).xz(9).z) ,' ',...
        num2str(Parent(1).xz(10).z) ,' ',...
        num2str(Parent(1).y) ,' ',...
        num2str(i) ,' ',...
        ]);
end

disp('ITER DONE!')
clear i j template xz
toc;

