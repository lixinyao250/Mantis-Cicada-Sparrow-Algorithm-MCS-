function chosen_index = softmax_selection(data)
    T = 15;
    data_range = max(data) - min(data);
    if data_range == 0
        prob_distribution = ones(size(data)) / length(data);
    else
        data = (data - min(data)) / data_range;
        neg_data = -data;
        max_neg_data = max(neg_data / T);
        exp_data = exp(neg_data / T - max_neg_data);
        if any(isnan(exp_data)) || any(isinf(exp_data)) || all(exp_data == 0)
            error('Adjustment temperature parameter T');
        end
        prob_distribution = exp_data / sum(exp_data);
    end
    r = rand;
    cumulative_prob = cumsum(prob_distribution);
    chosen_index = find(r <= cumulative_prob, 1);
end
