function pop = initialization(pop_size,dimension,ub,lb)
if length(lb)~=1
    bounds=[ub',lb'];
else
    for i=1:dimension
        ub_i(i,:)=ub;
        lb_i(i,:)=lb;
        bounds=[ub_i,lb_i];
    end
end

p = zeros(pop_size,dimension);
prime_number_min = dimension*2 +3;

while 1
    if isprime(prime_number_min)==1
        break;
    else
        prime_number_min = prime_number_min + 1;
    end
end

for i = 1:pop_size
    for j = 1:dimension
        r = mod(2*cos(2*pi*j/prime_number_min)*i,1);
        p(i,j) = bounds(j,1)+r*(bounds(j,2)-bounds(j,1));%Equation (5) in the thesis
    end
end
pop = p;
end
