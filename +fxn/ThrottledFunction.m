classdef (Sealed) ThrottledFunction < handle & ...
        matlab.mixin.internal.indexing.Paren & ...
        matlab.mixin.internal.Scalar & ...
        matlab.mixin.internal.indexing.DotNotOverloaded
    
    properties (SetAccess = private)
        % FUNCTION  MATLAB function_handle referenced.
        Function function_handle;
        Trailing (1, 1) logical
        Leading (1, 1) logical
        IsRunning = false
    end
    
    properties (Dependent)
        % WAIT Milliseconds to wait before invoking the function since the
        % last time the debounced function was invoked.
        Wait (1, 1) double
    end
    
    properties (Access = private)
        Timer timer
        LastUUID
    end
    
    methods
        
        function obj = ThrottledFunction(func, wait, nvPairs)
            arguments
                func function_handle
                wait (1, 1) double
                nvPairs.Leading (1, 1) logical = false;
                nvPairs.Trailing (1, 1) logical = true;
            end
            obj.Function = func;
            obj.Leading = nvPairs.Leading;
            obj.Trailing = nvPairs.Trailing;
            obj.Timer = timer("ExecutionMode", "fixedDelay", ...
                "TimerFcn", @obj.onTimer, ...
                "StartDelay", wait/1000, ...
                "Period", wait/1000);
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
            if isempty(obj.Timer.UserData) && obj.Leading
                obj.Function();
            end
            obj.Timer.UserData = matlab.lang.internal.uuid();
            if ~obj.IsRunning
                obj.IsRunning = true;
                start(obj.Timer);
            end
        end
        
        function wait(obj)
            waitfor(obj, 'IsRunning', false);
        end
        
        function flush(obj)
            if matlab.lang.OnOffSwitchState(obj.Timer.Running)
                stop(obj.Timer)
                obj.IsRunning = false;
            end
        end
        
        function cancel(obj)
            stop(obj.Timer)
            obj.IsRunning = false;
        end
    end
    
    methods (Access = private)
       
        function onTimer(obj, ~, ~)
            if isempty(obj.Timer.UserData) || ~isequal(obj.Timer.UserData, obj.LastUUID)
                obj.LastUUID = obj.Timer.UserData;
                obj.Function();
            elseif isequal(obj.Timer.UserData, obj.LastUUID)
                if obj.Trailing
                    obj.Function();
                end
                stop(obj.Timer);
                obj.IsRunning = false;
            end
        end
        
    end
    
end