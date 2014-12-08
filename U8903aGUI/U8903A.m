function varargout = U8903A(varargin)
% U8903A MATLAB code for U8903A.fig
%      U8903A, by itself, creates a new U8903A or raises the existing
%      singleton*.
%
%      H = U8903A returns the handle to a new U8903A or the handle to
%      the existing singleton*.
%
%      U8903A('CALLBACK',hObject,~,handles,...) calls the local
%      function named CALLBACK in U8903A.M with the given input arguments.
%
%      U8903A('Property','Value',...) creates a new U8903A or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before U8903A_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to U8903A_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help U8903A

% Last Modified by GUIDE v2.5 07-Aug-2014 16:26:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
  'gui_Singleton',  gui_Singleton, ...
  'gui_OpeningFcn', @U8903A_OpeningFcn, ...
  'gui_OutputFcn',  @U8903A_OutputFcn, ...
  'gui_LayoutFcn',  [] , ...
  'gui_Callback',   []);
if nargin && ischar(varargin{1})
  gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
  [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
  gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before U8903A is made visible.
function U8903A_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% Choose default command line output for U8903A
handles.output = hObject;
handles.myInstrObj = [];

% Initialize
axes(handles.axes1);
cla reset;
set(gca,'box','on');
set(handles.ckSquare,'Value',0);
showAll(handles);
handles.c1 = [];	% The next several lines create some variables as placeholders.
handles.c2 = [];
handles.t = [];
handles.mag = [];
handles.phase = [];
handles.f = [];

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = U8903A_OutputFcn(~, ~, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% Get default command line output from handles structure
varargout{1} = handles.output;

% --- The next several functions execute during object creation, after setting all properties.
function txtFin_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'),...
    get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end

function txtFmin_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'),...
    get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end

function txtFmax_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'),...
    get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end

function txtNumF_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'),...
    get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end

function edFName_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end

function popTime_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'),...
    get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popTime.
function popTime_Callback(~, ~, ~)

% --- Executes on button press in pbDegug (normally, button is invisible).
function pbDegug_Callback(~, ~, handles)
disp(handles);

% --- Executes on button press in pbQuit.
function pbQuit_Callback(~, ~, handles)
disp(' '); disp('Quit U8903a');
delete(handles.figure1);

% --- Executes on button press in pbHelp - Go to web page.
function pbHelp_Callback(~, ~, ~)
web('http://www.swarthmore.edu/NatSci/echeeve1/Ref/U8903A/U8903A_Bode.html',...
  '-browser');

% --- Read in the frequency, and make sure it is between 10Hz and 100kHz
function txtFin_Callback(hObject, ~, ~) %#ok<*DEFNU>
inFreq = str2num(get(hObject,'String'));
if (inFreq < 10)
  set(hObject,'String','10');
elseif (inFreq>100000)
  set(hObject,'String','100000');
end

% --- Read in minimum frequency and make sure it is between 10 Hz
% and 10 kHz.  Also make sure minumum freq is less than maximum.
function txtFmin_Callback(hObject, ~, handles)
minF = str2num(get(hObject,'String'));
maxF = str2num(get(handles.txtFmax,'String'));
if (minF < 10)
  set(hObject,'String','10');
elseif (minF>100000)
  set(hObject,'String','100000');
end
if (minF > maxF)
  set(hObject,'String',num2str(maxF));
end

% --- Read in maximum frequency and make sure it is between 10 Hz
% and 10 kHz.  Also make sure maxumum freq is greater than minimum.
function txtFmax_Callback(hObject, ~, handles)
maxF = str2num(get(hObject,'String'));
minF = str2num(get(handles.txtFmin,'String'));
if (maxF < 10)
  set(hObject,'String','10');
elseif (maxF>100000)
  set(hObject,'String','100000');
end
if (minF > maxF)
  set(hObject,'String',num2str(minF));
end

% --- This function will print an error to the string, along with a link to the
% web page.  It then generates an error which kills the program.
function myError(eID, eString)
errorUrl=[', <a href=',...
  '"http://www.swarthmore.edu/NatSci/echeeve1/Ref/U8903A/U8903A_Bode.html#errors"',...
  '>see here</a>.'];
disp([eString errorUrl]);
error(eID);

% --- Read in number of points for freq domain measurement.
% Make sure value is an integer between 1 and 201
function txtNumF_Callback(hObject, ~, ~)
% Make sure n is an integer between 1 and 201.
n = str2num(get(hObject,'String'));
n = round(n);
n = min(n,201);
n = max(n,1);
set(hObject,'String',num2str(n));

% --- Executes on button press in ckSquare.
% If the "Square Wave" button changes state, delete the existing
% data and refresh the screen.
function ckSquare_Callback(hObject, ~, handles)
handles.t = [];  % Set time vector to null, signifying no measurement.
guidata(hObject,handles);   % Save to handles.
showAll(handles);           % Update display

% --- Executes when selected object is changed in uipanel1.
% Whenever anything changes in uipanel, update screen.  (So if we go
% from time domain to freq domain, data is erased from screen).
function uipanel1_SelectionChangeFcn(~, ~, handles)
showAll(handles);

% --- Waits until a U8903A action is complete.  Fails if no completion.
function waitUntilDone(myInstrObj,id)
try
  xx=0;
  while (xx==0),  % Stay in loop as long as '0' is not returned.
    fprintf(myInstrObj,'STATUS:OPERATION:CONDITION?');
    if (strfind(fscanf(myInstrObj),'0'))
      xx=1;
    end
  end
catch
  s=sprintf('waitUntilDone error: %g\n',id);
  myError('waitUntilDone',s);
end

% *********** Function Begin **************************************************
% --- Executes on button press in pbConnect - connect MATLAB to U8903A.
function pbConnect_Callback(hObject, ~, handles)
h=waitbar(0,'Connecting');			% Display a progress bar.
instrreset;  						% Reset instruments
waitbar(0.1,h);
% Find the U8903A analyzer, display error if there is a problem.
try
  myHWInfo = instrhwinfo('visa','agilent');
catch
  close(h);
  myError('pBConnect1','No visa and/or agilent devices found');
end
waitbar(0.3,h);
if isempty(myHWInfo.ObjectConstructorName)
  close(h);
  myError('pBConnect2','No agilent devices found');
end
if length(myHWInfo.ObjectConstructorName)>1
  close(h);
  myError('pBConnect3','More than one agilent device found');
end

% Get information about device (this assumes that there is only one),
% then create buffer large enough for time domain data, specify
% endianness of data, and try to open the connection.  If unsuccessful
% display error, else wait until command is finished to continue.
try
  myInstrObj = eval(myHWInfo.ObjectConstructorName{1});
  myInstrObj.InputBufferSize=131072;
  myInstrObj.ByteOrder = 'bigEndian';
  fopen(myInstrObj);
catch
  close(h);
  myError('pBConnect4','Unable to open instrument object');
end
waitUntilDone(myInstrObj,'pbConnect, 1');

% Try resetting the device.  Throw error if unsuccessful, otherwise
% wait unit command id finished.
waitbar(0.4,h);
try  % Step 1: Reset instrument to get into known state
  fprintf(myInstrObj,'*RST');
catch
  close(h);
  myError('pBConnect5','Unable to reset device');
end
waitUntilDone(myInstrObj,'pbConnect, 2');

% We are connected, so save the instrument object (myInstrObj)
% and refresh the display.
waitbar(0.8,h);
handles.myInstrObj = myInstrObj;
guidata(hObject,handles);  % Save handles
showAll(handles);  % Refresh the display.
close(h);


% *********** Function Begin **************************************************
% --- Executes on button press in pbSave - save data to disk
function pbSave_Callback(~, ~, handles)
if (get(handles.rbTime,'Value'))  % if time domain is active
  % First, get all necessary data.
  t = handles.t;  c1 = handles.c1;  c2 = handles.c2;  %#ok<NASGU>
  c1_mag = handles.c1_mag;  c2_mag = handles.c2_mag;  %#ok<NASGU>
  c1c2_phase = handles.c1c2_phase;   c1_freq = handles.c1_freq;  %#ok<NASGU>
  if (get(handles.ckSquare,'Value')),  % If square wave, save appropriate info
    uisave({'t','c1','c2','c1_freq'});
  else % If sine wave, save appropriate information.
    uisave({'t','c1','c2','c1_mag','c2_mag','c1c2_phase','c1_freq'});
  end
else % Save information associated with frequency response.
  f = handles.f; mag=10.^(handles.mag/20); phase=handles.phase; %#ok<NASGU>
  uisave({'f','mag','phase'});
end

% *********** Function Begin **************************************************
% --- Set the frequency of the U8903A.  See programming manual for info
function setFreq(myInstrObj,handles,f)

try  % Set analog generator 1 to 1 volt rms
  if (get(handles.ckSquare,'Value'))  % Set sin or square wave.
    fprintf(myInstrObj,'SOURCE:FUNCTION SQUARE, (@1)');
  else
    fprintf(myInstrObj,'SOURCE:FUNCTION SINE, (@1)');
  end
  
  % Set frequency, amplitude....
  fprintf(myInstrObj,'SOURCE:FREQUENCY %gHz, (@1)',f);
  fprintf(myInstrObj,'SOURCE:VOLTAGE 1Vrms, (@1)');
  fprintf(myInstrObj,'OUTPUT:IMPEDANCE IMP50, (@1)');
  fprintf(myInstrObj,'OUTPUT:STATE ON, (@1)');
catch
  myError('setFreq','Cannot initialize voltage freq/amp');
end
waitUntilDone(myInstrObj,'setFreq');  % Wait for commands to finish

% *********** Function Begin **************************************************
% --- Get magnitude and phase from the U8903A.  See programming manual for info
function [m, p] = getMagPhase(myInstrObj)
try  % Measure Analog input voltage 1 and 2
  fprintf(myInstrObj,'DISP:VIEW "Analog Analyzer", PAN2, CH2');
  fprintf(myInstrObj,'SENSE:FUNCTION2 VAC, (@1,2)');
  fprintf(myInstrObj,'INITIATE:ANALYZER (@1,2)');
  fprintf(myInstrObj,'FETCH? FUNC2, (@1,2)');
  x=fscanf(myInstrObj);
  m = str2num(x);
catch
  myError('getMagPhase1','Unable to measure amplitudes');
end
waitUntilDone(myInstrObj,'getMagPhase, 1');  % Wait for commands to finish

try  % Measure phase between channels 1 and 2, with channel 1 as reference
  fprintf(myInstrObj,'SENSE:FUNCTION2 PHASE, (@1)');
  fprintf(myInstrObj,'INITIATE:ANALYZER (@1,2)');
  fprintf(myInstrObj,'FETCH? FUNC2, (@1,2)');
  x=fscanf(myInstrObj);
  phases = str2num(x);
  p = phases(2);
catch
  myError('getMagPhase2','Unable to measure phase');
end
waitUntilDone(myInstrObj,'getMagPhase, 2');  % Wait for commands to finish


% *********** Function Begin **************************************************
% --- Gettime domain data from the U8903A.  See programming manual for info
% This function is long, but not very complex.
%
% The output variables c1 and c2 are voltage data from channels 1 and 2.
% The variable t is the time vector.
function [c1, c2, t] = getTimeData(myInstrObj,handles)
try
  % Depending on the acquisition time, choose the number of points.
  switch get(handles.popTime,'Value')
    case 1
      NPTS = 65536;
      tmax = 0.1;
    case 2
      NPTS = 32768;
      tmax = 0.2;
    case 3
      NPTS = 16384;
      tmax = 0.05;
    case 4
      NPTS = 4192;
      tmax = 0.01;
    case 5
      NPTS = 2048;
      tmax = 0.005;
    case 6
      NPTS = 512;
      tmax = 0.001;
    case 7
      NPTS = 256;
      tmax = 0.0005;
    otherwise
      myError('getTimeData1','Uh-oh!');
  end
  % SET BW=312.5 kHz, DT = 3.2 uS = 1/BW.  This is considered high bandwidth.
  fprintf(myInstrObj,'INPUT:BANDWIDTH HIGH');
  fprintf(myInstrObj,'SENS:WAV:POIN %d',NPTS);
  DT = 1 / 312.5E3;
  % nkeep is umber of points we will keep. to get close to acquisition time.
  nkeep = ceil(tmax/DT)+1;
catch
  myError('getTimeData2','Error setting bandwidth');
end

try  % Set analysis to time domain
  fprintf(myInstrObj,'DISP:ANAL:MODE TIME');
  fprintf(myInstrObj,'TRIGGER:GRAPH:SOURCE CH1');
  fprintf(myInstrObj,'INITIATE:GRAPH (@1,2)');
catch
  myError('getTimeData3','Error setting up collection');
end
waitUntilDone(myInstrObj,'getTimeData, 1');  % Wait for commands to finish

try % Try to get data from channel 1.
  fprintf(myInstrObj,'FETCH:ARRAY? (@1)');
  x=binblockread(myInstrObj,'float32');  % Get all channel 1 data
catch
  myError('getTimeData4','Error reading channel 1 data.');
end
c1 = x(1:nkeep);   % Keep only some of the points/
waitUntilDone(myInstrObj,'getTimeData, 2');  % Wait for commands to finish

try % Get data from channel 2.
  fprintf(myInstrObj,'FETCH:ARRAY? (@2)');
  x=binblockread(myInstrObj,'float32'); % Ditto for channel 2
catch
  myError('getTimeData45','Error reading channel 3 data.');
end
c2 = x(1:nkeep);
waitUntilDone(myInstrObj,'getTimeData, 4');  % Wait for commands to finish

t=(0:(nkeep-1))'*DT;  % Generate the time vector



% *********** Function Begin **************************************************
% --- This is one of the workhorses of this program.  It displays all of
% appropriate information for the GUI.  This includes not only the data (if
% it is available), but it also greys out boxes depending on the mode.
function showAll(handles)
% If there is no connection, do the following - making GUI mostly invisible.
if (isempty(handles.myInstrObj))
  set(handles.pbConnect,'Enable','on');
  set(handles.pbGet,'Visible','off');
  set(handles.pbSave,'Visible','off');
  set(handles.uipanel1,'Visible','off');
  set(handles.txtGraphLabel,'Visible','off');
  set(handles.txtGraphLabel2,'Visible','off');
  set(handles.axes1,'Visible','off');
  axes(handles.axes1);  cla;
  set(handles.txtTitle,'String',...
    'U8903A Data Collection GUI (Unconnected - hit connect!)');
  % If we are connected, make appropriate elements of the GUI visible.
else
  set(handles.pbConnect,'Enable','off');
  set(handles.pbGet,'visible','on');
  set(handles.pbSave,'visible','on');
  set(handles.uipanel1,'Visible','on');
  set(handles.txtGraphLabel,'Visible','on');
  set(handles.txtGraphLabel2,'Visible','on');
  set(handles.axes1,'Visible','on');
  set(handles.txtTitle,'String',...
    'U8903A Data Collection GUI      (Connected)');
  % If the time domain is the measurement mode, gray out everything
  % associated with the frequency domain measurement, and show
  % everything associated with the time domain measurement.
  % Also enable and grey out controls as necessary.
  if (get(handles.rbTime,'Value'))
    set(handles.txtFmin,'Enable','off');
    set(handles.txtFmax,'Enable','off');
    set(handles.txtNumF,'Enable','off');
    set(handles.txtFin,'Enable','on');
    set(handles.popTime,'Enable','on');
    set(handles.ckSquare,'Enable','on');
    % If no time domain data has been collected, don't show axes.
    % Also enable and grey out controls as necessary.
    if isempty(handles.t)
      set(handles.pbSave,'Enable','off');
      axes(handles.axes1);
      cla reset;
      set(handles.axes1,'Visible','off');
      
      set(handles.txtGraphLabel,'Visible','off');
      set(handles.txtGraphLabel2,'Visible','off');
      % If time domain data is available, display it.
      % Also enable and grey out controls as necessary.
    else
      set(handles.pbSave,'Enable','on');
      set(handles.axes1,'Visible','off');
      
      t = handles.t;  c1 = handles.c1;  c2 = handles.c2;
      m1 = handles.c1_mag;  m2 = handles.c2_mag;
      p = handles.c1c2_phase;   f = handles.c1_freq;
      
      % If the data is from a square wave signal, show appropriate info
      if (get(handles.ckSquare,'Value')),  % If square wave
        set(handles.txtGraphLabel,'String','');
        set(handles.txtGraphLabel2,'String',sprintf('Frequency = %g', f));
        % If data is from sine wave, show phase, magnitudes....
      else
        set(handles.txtGraphLabel,'String',...
          sprintf('Freq=%g Hz,  |Out|, |In| = %g, %g Vrms (%g, %g Vpeak).',...
          f,m1,m2,m1*sqrt(2),m2*sqrt(2)));
        set(handles.txtGraphLabel2,'String',...
          sprintf('|Out|/|In| = %g (%g dB),  Phase = %g degrees',...
          m2/m1,20*log10(m2/m1),p));
      end
      % Make the plot of the data.
      axes(handles.axes1);
      tms = t*1000;
      plot(tms,c1,tms,c2);
      xlabel('Time, mS'); ylabel('Volts'); legend('Input','Output');
      set(gca,'XLim',[0 max(tms)]);  grid on;
    end
    % If the freq domain is the measurement mode, gray out everything
    % associated with the time domain measurement, and show
    % everything associated with the freq domain measurement.
    % Also enable and grey out controls as necessary.
  else
    set(handles.txtFmin,'Enable','on');
    set(handles.txtFmax,'Enable','on');
    set(handles.txtNumF,'Enable','on');
    set(handles.txtFin,'Enable','off');
    set(handles.popTime,'Enable','off');
    set(handles.ckSquare,'Enable','off');
    set(handles.txtGraphLabel,'Visible','off');
    set(handles.txtGraphLabel2,'Visible','off');
    % If no freq domain data has been collected, don't show axes.
    % Also enable and grey out controls as necessary.
    if isempty(handles.f)
      set(handles.pbSave,'Enable','off');
      axes(handles.axes1);
      cla reset;
      set(handles.axes1,'Visible','off');
      % If data is available, plot it.
      % Also enable and grey out controls as necessary.
    else
      set(handles.pbSave,'Enable','on');
      set(handles.axes1,'Visible','on');
      f = handles.f; m=handles.mag; p=handles.phase;
      hAx = plotyy(f,m,f,p);
      xlabel('Frequency (Hz)'); legend('Mag (left scale)','Phase (right)');
      ylabel(hAx(1),'Mag (dB)');  ylabel(hAx(2),'Phase (^o)');
      set(hAx,'XLim',[min(f) max(f)]);
      set(hAx,'XScale','log');
      set(hAx,'XGrid','on');
    end
  end
end


% *********** Function Begin **************************************************
% --- This is one of the workhorses of this program.  It executes when the
% "Get Data" button is pushed.  It determines what data to collect, and then
% does it.
function pbGet_Callback(hObject, ~, handles)
myInstrObj = handles.myInstrObj;
h=waitbar(0,'Getting Data');
if (get(handles.rbTime,'Value'))  % if we are doing time domain.....
  f = str2num(get(handles.txtFin,'String'));  	% Get frequency from GUI
  setFreq(myInstrObj,handles,f);				% Set frequency of U8903A
  waitbar(0.2,h);
  [m, p] = getMagPhase(myInstrObj);				% Get mag and phase from U8903A
  waitbar(0.4,h);
  
  % Get time domain data from input and output channels.
  [c1, c2, t] = getTimeData(myInstrObj,handles);
  waitbar(0.9,h);
  
  % Store data for use elsewhere (i.e., plotting, saving...).
  handles.c1 = c1;
  handles.c2 = c2;
  handles.t = t;
  handles.c1_mag = m(1);
  handles.c2_mag = m(2);
  handles.c1c2_phase = p;
  handles.c1_freq = f;
  
else % if we are doing time domain.....
  % Get min, max and number of frequencies
  fmin = str2num(get(handles.txtFmin,'String'));%#ok<*ST2NM>
  fmax = str2num(get(handles.txtFmax,'String'));
  numF = str2num(get(handles.txtNumF,'String'));
  f = logspace(log10(fmin),log10(fmax),numF)'; 	% Generate frequencies
  m = zeros(size(f));							% Preallocate arrays
  p = zeros(size(f));
  set(handles.txtGraphLabel,'String','');		% Set data string to null
  set(handles.txtGraphLabel2,'String','');
  axes(handles.axes1);
  for i=1:length(f),						% For each frequency...
    setFreq(myInstrObj,handles,f(i));		% ...set freq of U8903A
    [mi, pi] = getMagPhase(myInstrObj);		% ...get data from U8903A
    m(i) = 20*log10(mi(2)/mi(1));  			% ...ratio of output over input (dB)
    p(i) = pi;								% ...phase
    
    waitbar(i/length(f));
    
    % Plot the current value with two axes (for mag and phase);
    hAx = plotyy(f(1:i),m(1:i),f(1:i),p(1:i));
    xlabel('Frequency (Hz)');
    legend('Mag (left scale)','Phase (right)');
    ylabel(hAx(1),'Mag (dB)');  ylabel(hAx(2),'Phase (^o)');
    set(hAx,'XLim',[min(f) max(f)]);
    set(hAx,'XScale','log');
  end
  
  % Store data for use elsewhere (i.e., plotting, saving...).
  handles.mag = m;
  handles.phase = p;
  handles.f = f;
end
close(h);
guidata(hObject,handles);  	% Save handles
showAll(handles);  			% Refresh display