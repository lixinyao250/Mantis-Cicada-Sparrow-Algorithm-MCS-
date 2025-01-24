function max_digit = getMaxDigit(x)
x = abs(x);
if x ~= 0
    if x >= 1
        max_digit = 10^floor(log10(x));
    else
        max_digit = 10^floor(log10(x));
    end
else
    max_digit = 0.1;
end
end


