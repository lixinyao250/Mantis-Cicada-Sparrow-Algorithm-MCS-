function [last_fit,last_pos,curve]=MCS(Div,N,Max_iter,lb,ub,dim,fobj)
%Division of iterations
Max_iter_MC=Max_iter*Div;%Number of iterations of Mantis catching Cicada
Max_iter_CS=Max_iter*(1-Div);%Number of iterations of Sparrow catching Mantis

%Population size setting
manti_no=N;
cicada_no=10*manti_no;
sparrow_no=2;

%%population initialization
cicada_pos=initialization(cicada_no,dim,ub,lb);
manti_pos=initialization(manti_no,dim,ub,lb);

%%Ranking of adaptation
for i=1:size(manti_pos,1)
    manti_fit(i,1)=fobj(manti_pos(i,:));
end
[divien_manti_fit,divien_manti_ind]=sort(manti_fit);
for t=1:size(manti_pos,1)
    divien_manti_pos(t,:)=manti_pos(divien_manti_ind(t),:);
end
curve=ones(1,1);
% mantis catches the cicada
for o1=1:Max_iter_MC
    % softmax selects individuals
    soft_index_1=softmax_selection(divien_manti_fit);
    soft_index_2=softmax_selection(divien_manti_fit);
    %Random wandering of cicadas
    RA=walk_cicada(dim,lb,ub, divien_manti_pos(soft_index_1,:),o1,size(cicada_pos,1),curve,Max_iter);
    RB=walk_cicada(dim,lb,ub, divien_manti_pos(soft_index_2,:),o1,size(cicada_pos,1),curve,Max_iter);
    RC=walk_cicada(dim,lb,ub, divien_manti_pos(1,:),o1,size(cicada_pos,1),curve,Max_iter);
    cicada_pos= ((RA+RB+RC)/3);
    %Checking the boundaries
    cicada_pos=boundary_check(cicada_pos,lb,ub);
    %Calculating Adaptation
    for i=1:size(cicada_pos,1)
        cicada_fit(i,1)=fobj(cicada_pos(i,:));
    end
    all_pos_1=[divien_manti_pos;cicada_pos];
    all_fit_1=[divien_manti_fit;cicada_fit];
    [all_divien_manti_fit,all_divien_manti_ind]=sort(all_fit_1);
    for t=1:size(all_fit_1,1)
        all_divien_manti_pos(t,:)=all_pos_1(all_divien_manti_ind(t),:);%
    end
    divien_manti_pos=all_divien_manti_pos(1:manti_no,:);
    divien_manti_fit=all_divien_manti_fit(1:manti_no,:);

    %print
    each_fit1=divien_manti_fit(1);
    curve(o1,1)=divien_manti_fit(1);
    display(['At iteration ', num2str(o1), ' the best fitness is ', num2str(each_fit1)]);
end

%Sparrow population initialization
for i=1:sparrow_no
    divien_sparrow_pos= divien_manti_pos(1:sparrow_no,:);
    divien_sparrow_fit(i,1)=fobj(divien_sparrow_pos(i,:));
end
Best_pos=divien_sparrow_pos(1,:);
Best_fit=divien_manti_fit(1,1);
%the sparrow catches the praying mantis
for o2=1:Max_iter_CS
    %Random wandering of the mantis
    RD=walk_manti(dim,lb,ub, divien_sparrow_pos(1,:),o2,size(manti_pos,1),Max_iter_CS);
    RE=walk_manti(dim,lb,ub, divien_sparrow_pos(1,:),o2,size(manti_pos,1),Max_iter_CS);
    manti_pos=((RD*3)+RE)/4;
    %Checking the boundaries
    manti_pos=boundary_check(manti_pos,lb,ub);
    for i=1:size(manti_pos,1)
        manti_fit(i,1)=fobj(manti_pos(i,:));
    end
    all_pos_2=[divien_sparrow_pos;manti_pos;Best_pos];
    all_fit_2=[divien_sparrow_fit; manti_fit;Best_fit];
    [all_divien_sparrow_fit,all_divien_sparrow_ind]=sort(all_fit_2);
    for t=1:size(all_fit_2,1)
        all_divien_sparrow_pos(t,:)=all_pos_2(all_divien_sparrow_ind(t),:);
    end
    divien_sparrow_pos=all_divien_sparrow_pos(1:sparrow_no,:);
    divien_sparrow_fit=all_divien_sparrow_fit(1:sparrow_no,:);

    each_fit2=divien_sparrow_fit(1);
    curve(o1+o2,1)=divien_sparrow_fit(1);
    display(['At iteration ', num2str(o2+o1), ' the best fitness is ', num2str(each_fit2)]);
end
last_pos=divien_sparrow_pos(1,:);
last_fit=divien_sparrow_fit(1,1);