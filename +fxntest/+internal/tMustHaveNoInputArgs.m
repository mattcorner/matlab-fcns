classdef tMustHaveNoInputArgs < matlab.unittest.TestCase
   
    methods (Test)
        
        function acceptsValidInput(testCase)
            fcn = @() disp();
            testCase.verifyWarningFree(@() fxn.internal.mustHaveNoInputArgs(fcn));
        end
        
        function rejectsInvalidInput(testCase)
            fcn = @(msg) disp(msg);
            testCase.verifyError(@() fxn.internal.mustHaveNoInputArgs(fcn), 'fxn:InvalidFunctionHandle');
        end
        
    end
    
end