function out = normest(f)

for j = 1:numel(f)
    out = 0;
    for k = 1:numel(f(j).funs);
        out = out + normest(f(j).funs{k});
    end
end

end