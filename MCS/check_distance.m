function min_dist= check_distance(a, b, c)
    dist_a = abs(c - a);
    dist_b = abs(c - b);
    min_dist = min(dist_a, dist_b);