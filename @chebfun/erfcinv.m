function F = erfcinv(F, pref)
%ERFCINV   Inverse complementary error function of a CHEBFUN.
%   X = ERFCINV(Y) is the inverse of the complementary error function for the
%   CHEBFUN Y. It satisfies Y = ERFC(X) for 2 >= Y >= 0 and -Inf <= X <= Inf.
%
% See also ERF, ERFC, ERFCX, ERFINV.

% Copyright 2013 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org for Chebfun information.

% Input must be real:
if ( ~isreal(F) )
    error('CHEBFUN:erfcinv:notreal', 'Input must be real.');
end

% Obtain preferences:
if ( nargin == 1 )
    pref = chebpref();
end

% Loop over the columns of F:
for k = 1:numel(F)
    % Call the compose method:
    F(k) = compose(F(k), @erfcinv, pref);
end

end
