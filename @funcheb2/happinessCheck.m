function  [ishappy, epslevel, cutoff] = ...
    happinessCheck(op, values, coeffs, vscale, pref)
%HAPPINESSCHECK Happiness test for a FUNCHEB2
%   [ISHAPPY, EPSLEVEL, CUTOFF] = HAPPINESSCHECK(OP, VALUES, COEFFS, VSCALE,
%   PREF) tests if the FUNCHEB2 with values VALUES and/or coefficients COEFFS
%   would be a 'happy' approximation (in the sense defined below) to the
%   function handle OP relative to VSCALE. If the approximation is happy, the
%   output ISHAPPY is logical TRUE, the happiness level is returned in EPSLEVEL,
%   and CUTOFF indicates the degree to which the coefficients COEFFS may be
%   truncated.
%
%   Alternative definitions of happiness can be chosen by setting the
%   FUNCHEB2.PREF.happinessCheck field. This field may be one of the built in
%   checks: 'CLASSIC', 'STRICT', 'LOOSE', or a function handle pointing the a
%   function with the template [ISHAPPY, EPSLEVEL, CUTOFF] = @(VALUES, COEFFS,
%   VSCALE, PREF). The built in check are:
%      CLASSIC: Chooses an EPSLEVEL based upon the length on the 'tail' and a
%               finite difference gradient approximation.
%      STRICT : The tail _must_ be below that specified by PREF.funcheb2.eps.
%      LOOSE  : To be specified.
%   Further details of these happiness checks are given in their corresponding
%   m-files.
%
%   Regardless of the happiness definition, HAPPINESSCHECK also performs a
%   SAMPLETEST unless pref.funcheb2.sampleTest == false or OP is empty.
%
% See also classicCheck.m, looseCheck.m, strictCheck.m, sampleTest.m.

% Copyright 2013 by The University of Oxford and The Chebfun Developers. 
% See http://www.chebfun.org/ for Chebfun information.

% Make sure we have a vscale:
if ( nargin < 4 || isempty(vscale) )
    vscale = max(abs(values));
end

% Make sure we have coefficients:
if ( isempty(coeffs) )
    coeffs = funcheb2.chebpoly(values);
end

% What does happiness mean to you?
if ( strcmpi(pref.funcheb2.happinessCheck, 'classic') )
    % Use the default happiness check procedure from Chebfun V4.
    
    % Check the coefficients are happy:
    [cutoff, epslevel] = funcheb2.classicCheck(values, coeffs, vscale, pref);
    % Happiness here means that the length of the coeffs is decreased:
    if ( cutoff < size(values, 1) || cutoff == 1)
        ishappy = true;  % Yay! :)
    else
        ishappy = false; % Boo. :(
    end
    
elseif ( strcmpi(pref.funcheb2.happinessCheck, 'strict') )
    % Use the 'strict' happiness check:
    [ishappy, epslevel, cutoff] = ...
        funcheb2.strictCheck(values, coeffs, vscale, pref);
    
elseif ( strcmpi(pref.funcheb2.happinessCheck, 'loose') )
    % Use the 'loose' happiness check:
    [ishappy, epslevel, cutoff] = ...
        funcheb2.looseCheck(values, coeffs, vscale, pref);
    
else
    % Call a user-defined happiness check:
    [ishappy, epslevel, cutoff] = ...
        pref.funcheb2.happinessCheck(values, coeffs, vscale, pref);
    
end

% Check also that sampleTest is happy:
if ( ishappy && ~isempty(op) && ~isnumeric(op) && pref.funcheb2.sampletest )
    ishappy = funcheb2.sampleTest(op, values, vscale, epslevel, pref);
    if ( ~ishappy )
        % It wasn't. Revert cutoff. :(
        cutoff = size(values, 1);
    end
end

end