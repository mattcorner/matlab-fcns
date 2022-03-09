function throttledFcn = throttle(fcn, wait, nvPairs)
%THROTTLE Creates a throttled function that only invokes fcn at most once 
%per every wait milliseconds. The throttled function comes with a cancel
%method to cancel delayed fcn invocations, a flush method to immediately
%invoke them, and a wait method to block the command prompt until all
%invocations are complete.
%
%   throttledFcn = THROTTLE(fcn)
%
%   throttledFcn = THROTTLE(fcn, wait)
%
%   throttledFcn = THROTTLE(fcn, wait, Name, Value)
%
%   Examples
%   --------
%   How much time does it take to compute sum(A.' .* B, 1), where A is
%   12000-by-400 and B is 400-by-12000?
%
%       A = rand(12000, 400);
%       B = rand(400, 12000);
%       f = @() sum(A.' .* B, 1);
%       timeit(f)
%
%   How much time does it take to call svd with three output arguments?
%
%       X = [1 2; 3 4; 5 6; 7 8];
%       f = @() svd(X);
%       timeit(f, 3)
%
%   See also DEBOUNCE

%   Copyright 2022 Matthew Corner
%
%   For detailed discussion on MATLAB Performance Measurement:
%   http://www.mathworks.com/matlabcentral/fileexchange/18510-matlab-performance-measurement

arguments
    fcn (1, 1) function_handle {fxn.internal.mustHaveNoInputArgs}
    wait (1, 1) double {mustBeInteger} = 100
    nvPairs.Leading (1, 1) logical
    nvPairs.Trailing (1, 1) logical
end
args = namedargs2cell(nvPairs);
throttledFcn = fxn.ThrottledFunction(fcn, wait, args{:});
end