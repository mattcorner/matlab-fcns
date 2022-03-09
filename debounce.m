function debouncedFcn = debounce(fcn, wait, nvPairs)
arguments
    fcn (1, 1) function_handle {fxn.internal.mustHaveNoInputArgs}
    wait (1, 1) double {mustBeInteger} = 100
    nvPairs.Leading (1, 1) logical
    nvPairs.Trailing (1, 1) logical
end
args = namedargs2cell(nvPairs);
debouncedFcn = fxn.DebouncedFunction(fcn, wait, args{:});
end