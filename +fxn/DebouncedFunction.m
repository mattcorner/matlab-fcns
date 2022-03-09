classdef (Sealed) DebouncedFunction < handle & ...
        matlab.mixin.internal.indexing.Paren & ...
        matlab.mixin.internal.Scalar & ...
        matlab.mixin.internal.indexing.DotNotOverloaded
    
    properties (SetAccess = private)
        % FUNCTION  MATLAB function_handle referenced.
        Function function_handle;
        Trailing (1, 1) logical
        Leading (1, 1) logical
    end
    
    properties (Dependent)
        % WAIT Milliseconds to wait before invoking the function since the
        % last time the debounced function was invoked.
        Wait (1, 1) double
    end
    
    properties (Access = private)
        Timer timer
    end
    
    methods
        
        function obj = DebouncedFunction(func, wait, nvPairs)
            arguments
                func function_handle
                wait (1, 1) double
                nvPairs.Leading (1, 1) logical = false;
                nvPairs.Trailing (1, 1) logical = true;
            end
            obj.Function = func;
            obj.Leading = nvPairs.Leading;
            obj.Trailing = nvPairs.Trailing;
            obj.Timer = timer("ExecutionMode", "singleShot", ...
                "TimerFcn", @obj.onTimer, ...
                "StartDelay", wait/1000);
        end
        
    end
    
    methods
        function set.Wait(obj, val)
            obj.Timer.StartDelay = val/1000;
        end
        function val = get.Wait(obj)
            val = obj.Timer.StartDelay*1000;
        end
    end
    
    methods
        function parenReference(obj)
            if obj.Leading && ~matlab.lang.OnOffSwitchState(obj.Timer.Running)
                obj.Function();
            end
            stop(obj.Timer);
            start(obj.Timer);
        end
        
        function wait(obj)
            wait(obj.Timer);
        end
        
        function flush(obj)
            if matlab.lang.OnOffSwitchState(obj.Timer.Running)
                stop(obj.Timer)
                obj.onTimer([], []);
            end
        end
        
        function cancel(obj)
            stop(obj.Timer)
        end
    end
    
    methods (Access = private)
       
        function onTimer(obj, ~, ~)
            if obj.Trailing
                obj.Function();
            end
        end
        
    end
    
end