function mustHaveNoInputArgs(fcn) 
    if ~isa(fcn, 'function_handle') || ~ismember(nargin(fcn), [0 -1])
        eid = 'fxn:InvalidFunctionHandle';
        msg = 'Must be a function handle that takes no input arguments.';
        throwAsCaller(MException(eid, msg))
    end
end