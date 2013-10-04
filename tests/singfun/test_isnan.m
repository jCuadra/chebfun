% Test file for singfun/isnan.m

function pass = test_isnan(pref)

% Get preferences.
if ( nargin < 1 )
    pref = singfun.pref;
end

% The order of the exponents:
a = 0.64;
b = -0.64;
c = 1.28;
d = -1.28;

% Pre-allocate pass matrix
pass = zeros(1, 2);

%%
% Check a few cases.

% fractional root at the left endpoint
f = singfun(@(x) (1 + x).^a.*exp(x), [a 0], {'root', 'none'}, [], [], pref);
pass(1) = ~isnan(f);

% fractional pole at the left endpoint
f = singfun(@(x) (1 + x).^d.*sin(x), [d 0], {'sing', 'none'}, [], [], pref);
pass(2) = ~isnan(f);

% fractional pole at the left endpoint
f = singfun(@(x) (1 + x).^d.*sin(x), [d 0], {'sing', 'none'}, [], [], pref);
g = NaN*f;
pass(3) = isnan(g);

end
