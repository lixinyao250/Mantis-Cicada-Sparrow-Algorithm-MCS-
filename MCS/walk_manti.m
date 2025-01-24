function RE=walk_manti(dim,lb,ub, pos,Current_iter,N,max_iter)
ave_pos=mean(abs(pos));
long_change=getMaxDigit(ave_pos);

a = 0.9;
k = 3;
x_values = linspace(0, 1, max_iter);
y_values = 1 - (1 - a) * exp(-k * (1 - x_values));

if length(lb)~=1
    bounds=[ub',lb'];
else
    for i=1:dim
        ub_i(i,:)=ub;
        lb_i(i,:)=lb;
        bounds=[ub_i,lb_i];
    end
end

for t=1:dim
    numbers = [20,30,40];
    for i = 1:N
        selected_number = numbers(randi(length(numbers)));
        step_length = (bounds(t,1) -bounds(t,2)) / selected_number;
        long_in=getMaxDigit( step_length);
        num =long_change/long_in;
        step_length=step_length*num/100;
        if rand < 0.5
            step_length = -step_length;
        end
        last_step_lengths(i,t) = step_length;
    end
end
last_step_lengths=last_step_lengths*y_values(Current_iter);
for k=1:N
    cumulative_sums_one=last_step_lengths(k,:);
    new_pos=cumulative_sums_one+pos(1,:);
    max_step_length = max(cumulative_sums_one);
    min_step_length = min(cumulative_sums_one);
    ub_1=mean(ub);
    lb_1=mean(lb);
    distance=check_distance(ub_1,lb_1,new_pos);
    max_distant=max(distance);
    min_distant=min(distance);
    max_all=ub_1-max_distant;
    min_all=min_distant-lb_1;
    last=  max_step_length;
    RE(k,:)=new_pos.*(2*last)./(max_step_length-min_step_length);
end
end