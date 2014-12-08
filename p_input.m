function x=p_input(p,s)
% Function p_input (short for "publish_input").  This function operates
% similar to MATLAB's "input" function.  The arguments are identical.
%
% This function mimics the behavior of MATLAB's "input" function, but is
% suitable for use in scripts to be published.  The "input" function does
% not work in a script being published.  When using the "p_input" function
% (with the same arguments as the "input" function) a dialog box appears
% for user input.  After input is complete "p_input" displays the input
% prompt as well as the user input; when the script is published this
% appears inline with the text.
%
% To learn about the arguments for the "input" function type "doc input" at
% the MATLAB prompt.
%
% This function is not useful if intermediate output from MATLAB is
% necessary because the "publish" feature displays no intermediate output.
% However, the prompt string could be changed to reflect the current
% program state.
%
% Written by Erik Cheever, Swarthmore College, June 2012.

% "es" is a string used in several places.  Initialize it here.
es='\n\nSee documentation for MATLAB ''input'' function (''doc input'').';

switch nargin,  % Check number of input arguments and act accordingly.
    
    case 1,
        % If there is only one input argument first make sure it is a string
        % (i.e., a character array).  If so, then open a dialog box using the
        % string as a prompt; convert the string to a number (with appropriate)
        % error checking; lastly, display the prompt and the user input.
        if isa(p,'char')        % Is p a string array?
            xin=inputdlg(p);    %   If so, get input from dialog box
            % Evaluate the input and check for errors.
            try
                x=evalin('base',char(xin));
            catch
                y=lasterror;
                error(y.identifier,...
                    [y.message '  Could not evaluate input.' ]);
            end
%             % The dialog box (followed by call to "evalin") will accept
%             % several numbers separated by spaces.  The "input" function
%             % only accepts a single number, so here we extract only the
%             % first number entered.
%             x=x(1);
        else                    % p was not a string, so throw an error.
            error('MATLAB:p_inputArg1',...
                ['Argument to ''p_input'' must be a string.' mes])
        end
        disp([p num2str(x)]);   % Display results as if "input" was used.
        
    case 2,
        % If there are two input arguments, the second argument must be the
        % characther 's' and the input is taken as a string.  Here we check
        % that the first argument (the variable "p") is a string, and then
        % check to make sure the second argument (the veriable "s") is the
        % character 's'.  If so, open a dialog box and get input string.
        if isa(p,'char')    % Is p (1st argument) a string array?
            if s=='s'       %   and is s (2nd argument) the character 's'?
                x=char(inputdlg(p));    % If so, get input
            else                        %   if not, throw an error.
                error('MATLAB:p_inputArg2',...
                    ['Second argument to ''p_input'' must be ''s''.'  es])
            end
        else                    % p was not a string, so throw an error.
            error('MATLAB:p_inputArg1',...
                ['First argument to ''p_input'' must be a string.'  es])
        end
        disp([p x]); % Display results as if "input" was used.
        
    otherwise,
        % Wrong number of arguments, throw an error
        error('MATLAB:p_inputNargs',...
            ['Function ''p_input'' must have either 1 or 2 arguments.' es])
end
