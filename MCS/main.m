%%Food chain optimization algorithm （MCS)
%%by Yijun Geng (2022211008@stumail.dufe.edu.cn)
%%School of statistics , Dongbei university of finance and economy
clear 
clc
close all
Agents_no=100; %population size
Function_name='F20'; % objective function
Max_iter=500; %Maximum number of iterations
Division_ratio=0.7;%Percentage of two predation iterations
[lb,ub,dim,fobj]=Get_Functions_details(Function_name);
[Best_score,Best_pos,MCS_cg_curve]=MCS(Division_ratio,Agents_no,Max_iter,lb,ub,dim,fobj);

%Draw
figure
func_plot(Function_name);
title('Test function')
xlabel('x_1');
ylabel('x_2');
zlabel([Function_name,'( x_1 , x_2 )'])
grid off
%Curve
figure;
semilogy(MCS_cg_curve, '-');
title('constrained curve');
xlabel('Number of iterations');
ylabel('Fitness');
ylim([10e-200,1])
grid on;