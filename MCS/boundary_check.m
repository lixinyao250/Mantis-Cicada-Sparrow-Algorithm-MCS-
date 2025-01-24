function corrected_pos = boundary_check(cicada_pos, lb, ub)
    [~, dim] = size(cicada_pos);
    if length(ub) == 1
        ub = repmat(ub, 1, dim);
    end
    if length(lb) == 1
        lb = repmat(lb, 1, dim);
    end
    if length(lb) ~= length(ub) || length(lb) ~= dim
        error('Upper and lower boundary dimensions must be the same');
    end
    Flag4ub = cicada_pos > ub;
    Flag4lb = cicada_pos < lb;
    corrected_pos = cicada_pos .* ~(Flag4ub | Flag4lb) + ub .* Flag4ub + lb .* Flag4lb;
end