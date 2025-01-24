function RE=walk_cicada(dim,lb,ub, pos,Current_iter,N,curve1,max_iter)
%Harmonization of border formats
if length(lb)~=1
    bounds=[ub',lb'];
else
    for i=1:dim
        ub_i(i,:)=ub;
        lb_i(i,:)=lb;
        bounds=[ub_i,lb_i];
    end
end
ave_pos=mean(abs(pos));
long_change=getMaxDigit(ave_pos);%Calculate the order of magnitude
for t=1:dim
    %Initial walk
    if Current_iter<=max_iter*0.02
        numbers = [20,30,40];
        for i = 1:N
            selected_number = numbers(randi(length(numbers)));
            step_length = (bounds(t,1) - bounds(t,2)) / selected_number;
            if rand < 0.5
                step_length = -step_length;
            end
            last_step_lengths(i,t) = step_length;
        end
    end
    %roam randomly
    if Current_iter>max_iter*0.02
        numbers = [20,30,40];
        for i = 1:N
            selected_number = numbers(randi(length(numbers)));
            step_length = (bounds(t,1) - bounds(t,2)) / selected_number;
            long_in=getMaxDigit( step_length);
            num =long_change/long_in;
            step_length=step_length*num/10;
            if rand < 0.5
                step_length = -step_length;
            end
            last_step_lengths(i,t) = step_length;
        end
    end
end

if   Current_iter<=max_iter*0.02
    for p=1:dim
        last_step_lengths(:,p) = cumsum(last_step_lengths(:,p));
    end
end

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
    if Current_iter<max_iter*0.02
        last=min(min_all,max_all);
    else
        last=  max_step_length;
    end
    RE(k,:)=new_pos.*(2*last)./(max_step_length-min_step_length);
end
%Cicada self-correction
matrix=zeros(N,1);
if Current_iter>max_iter*0.2
    if curve1(Current_iter-20)== curve1(Current_iter-1)
        for i=1:dim
        amendment=(bounds(i,1) - bounds(i,2))/5;
        matrix(:,i) = repmat(amendment, N, 1);
        end
    end
 RE=RE-matrix;
end
end