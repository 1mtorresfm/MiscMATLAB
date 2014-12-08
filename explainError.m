function explainError
%explainError  Show a web page that explains why the last error occured.
%   When Matlab reports an error, the error message is often quite obscure.
%    This script opens a web page that gives common reasons for the
%    particular error message.

l=lasterror;  % Get last error info in a structure
if isempty(l),
    disp('There have been no errors');
else
    % u1 = base url
    u1='http://www.swarthmore.edu/NatSci/echeeve1/Ref/MatlabErr/';
    u2=urlencode(l.identifier);     % Error identifier
    u3=urlencode(l.message);        % Error message
    u=[u1 '?id=' u2 '&msg=' u3];    % Form URL
    web(u,'-browser');              % Open web page
end
   
end

