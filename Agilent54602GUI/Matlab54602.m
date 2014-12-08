function varargout = Matlab54602(varargin)
% MATLAB54602 M-file for Matlab54602.fig
%      MATLAB54602, by itself, creates a new MATLAB54602 or raises the existing
%      singleton*.
%
%      H = MATLAB54602 returns the handle to a new MATLAB54602 or the handle to
%      the existing singleton*.
%
%      MATLAB54602('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MATLAB54602.M with the given input arguments.
%
%      MATLAB54602('Property','Value',...) creates a new MATLAB54602 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Matlab54602_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Matlab54602_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Matlab54602

% Last Modified by GUIDE v2.5 05-Jul-2007 11:37:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Matlab54602_OpeningFcn, ...
    'gui_OutputFcn',  @Matlab54602_OutputFcn, ...
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


% --- Executes just before Matlab54602 is made visible.
function Matlab54602_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Matlab54602 (see VARARGIN)

% Choose default command line output for Matlab54602
handles.output = hObject;

handles.plotcolor{1}=get(handles.c1Text,'ForegroundColor');
handles.plotcolor{2}=get(handles.c2Text,'ForegroundColor');
handles.plotcolor{3}=get(handles.c3Text,'ForegroundColor');
handles.plotcolor{4}=get(handles.c4Text,'ForegroundColor');

set(handles.pts250RB,'Value',0);
set(handles.pts500RB,'Value',1);
set(handles.pts1000RB,'Value',0);
set(handles.pts2000RB,'Value',0);

set(handles.baud1200RB,'Value',0);
set(handles.baud2400RB,'Value',0);
set(handles.baud9600RB,'Value',0);
set(handles.baud19200RB,'Value',1);

initGui(handles);
handles=guidata(hObject);  %Reload handles (may be changed in initGui)

handles.channeldata=[];     %Placeholders (used later)
handles.timedata=[];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Matlab54602 wait for user response (see UIRESUME)
% uiwait(handles.matlab54602Fig);


% --- Outputs from this function are returned to the command line.
function varargout = Matlab54602_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


%Initialize the GUI
function initGui(handles)

axes(handles.scopeAx);  %Clear axes.
cla;

set(handles.savedataPB,'Enable','off'); %Disable "Save" button
set(handles.printPB,'Enable','off');    %Disable "Print" button
set(handles.tdivText,'Visible','off');
for i=1:4,                              %Turn off text for Volts/Div
    cStr=['c' num2str(i)];
    eval(['set(handles.' cStr 'Text,''Enable'',''off'')']);
    eval(['set(handles.' cStr 'vdivText,''Visible'',''off'')']);
end

% Update handles structure
guidata(handles.matlab54602Fig, handles);


% --- Radio button code for number of points.
function pts250RB_Callback(hObject, eventdata, handles)
set(handles.pts500RB,'Value',0); 
set(handles.pts1000RB,'Value',0);
set(handles.pts2000RB,'Value',0);

function pts500RB_Callback(hObject, eventdata, handles)
set(handles.pts250RB,'Value',0);
set(handles.pts1000RB,'Value',0);
set(handles.pts2000RB,'Value',0);

function pts1000RB_Callback(hObject, eventdata, handles)
set(handles.pts250RB,'Value',0);
set(handles.pts500RB,'Value',0);
set(handles.pts2000RB,'Value',0);

function pts2000RB_Callback(hObject, eventdata, handles)
set(handles.pts250RB,'Value',0);
set(handles.pts500RB,'Value',0);
set(handles.pts1000RB,'Value',0);


% --- Radio button code for baud rate.
function baud1200RB_Callback(hObject, eventdata, handles)
set(handles.baud2400RB,'Value',0);
set(handles.baud9600RB,'Value',0);
set(handles.baud19200RB,'Value',0);

function baud2400RB_Callback(hObject, eventdata, handles)
set(handles.baud1200RB,'Value',0);
set(handles.baud9600RB,'Value',0);
set(handles.baud19200RB,'Value',0);

function baud9600RB_Callback(hObject, eventdata, handles)
set(handles.baud1200RB,'Value',0);
set(handles.baud2400RB,'Value',0);
set(handles.baud19200RB,'Value',0);

function baud19200RB_Callback(hObject, eventdata, handles)
set(handles.baud1200RB,'Value',0);
set(handles.baud2400RB,'Value',0);
set(handles.baud9600RB,'Value',0);



% --- Executes on button press in exitPB.
function exitPB_Callback(hObject, eventdata, handles)
close(handles.matlab54602Fig);


% --- Show a warning dialog if no serial communication is established.
function myWarndlg()
w={'Warning...',...
    'Unable to establish communications with oscilloscope.',' ',...
    'Check that:'...
    '1) Baud rates are equal (On scope hit ''Print/Utility'' button,',...
    '   then ''I/O Menu'' soft button).',...
    '2) ''Handshake'' is set to DTR.',...
    '3) Serial port cable is connected from scope to computer.'};
warndlg(w,'No communication','modal');


% --- Executes on button press in getdataPB.  This function is the main
% function - it does practically everything.
function getdataPB_Callback(hObject, eventdata, handles)
%  clear any old open instruments
x=instrfind;  delete(x);

if get(handles.pts250RB,'Value'), numptsStr='250'; end;
if get(handles.pts500RB,'Value'), numptsStr='500'; end;
if get(handles.pts1000RB,'Value'), numptsStr='1000'; end;
if get(handles.pts2000RB,'Value'), numptsStr='2000'; end;
numpts=str2double(numptsStr);   %number of points to collect

if get(handles.baud1200RB,'Value'), baudrate=1200; end;
if get(handles.baud2400RB,'Value'), baudrate=2400; end;
if get(handles.baud9600RB,'Value'), baudrate=9600; end;
if get(handles.baud19200RB,'Value'), baudrate=19200; end;

%Open serial port
x=serial('COM1',...
    'baud',baudrate,...
    'FlowControl','hardware',...
    'RecordDetail','verbose',...
    'RecordName','myTest.txt',...
    'InputBufferSize',8000,...
    'Timeout',1);
fopen(x);

%Check that communications work by trying to get scope to identify itself.
if isempty(query(x,'*IDN?')),   
    beep;                       %Communications did not work.
    myWarndlg();
    initGui(handles)
    return
end

set(x,'Timeout',4); %Set timeout to 4 seconds (for slow I/O with much data)

% record(x,'on');           % Used for debugging (turn it off below).

hwaitbar=waitbar(0,'Download progress...'); % Create and display waitbar.

numactive=0;                %Counter for number of channels to collect.
for i=1:4,
    flushinput(x);          % Clear any characters in buffer.
    % Check status of each scope channel.
    if strfind(query(x,['STATUS? ' ['CHAN' num2str(i)]]),'ON'),
        c{i}.active=1;      % Channel has data to be collected.
        numactive=numactive+1;
    else
        c{i}.active=0;      % No data.
    end
end

tbr=str2double(query(x,'TIMEBASE:RANGE?'));
tbd=str2double(query(x,'TIMEBASE:DELAY?'));
t=((1:numpts)-numpts/2)*tbr/numpts+tbd;     %Time vector.

waitbar(2/(numactive+2),hwaitbar);          %update waitbar;

numcomplete=1;              % number of channels collected (for waitbar)
fprintf(x,['WAVEFORM:POINTS ' numptsStr]);  % Set number of points.
for i=1:4,
    ch=['CHAN' num2str(i)];  %Form string "CHANx" where x=1:4.
    if c{i}.active,
        fprintf(x,['WAVEFORM:SOURCE ' ch]); %Set sourece of data.
        flushinput(x);                      %Clear buffer.
        c{i}.range=str2double(query(x,[ch ':RANGE?']));     %Read range
        c{i}.offset=str2double(query(x,[ch ':OFFSET?']));   %Read offset
        fprintf(x,'WAVEFORM:DATA?');                        %Ask for data.
        y=fread(x,10);    %Remove first 10 characters (no info)
        c{i}.raw=fread(x,numpts);   %Read in the rest of data.
        % Scale the data to a voltage.
        c{i}.scaled=(c{i}.raw/256-0.5)*c{i}.range+c{i}.offset;
        waitbar((numcomplete+2)/(numactive+2),hwaitbar);  %update waitbar;
        numcomplete=numcomplete+1;
    end
end

% record(x,'off');      %Used for debugging.
fclose(x);  %Close the scope.
delete(x);  %Delete from memory.

%Now update display.  Start by clearing the axes,
axes(handles.scopeAx);
cla;

%... then display the time/div text.
set(handles.tdivText,'Visible','on');
set(handles.tdivText,'String',num2str(tbr/10));

%... then draw axes in middle of screen
plot([min(t) max(t)],128*[1 1],...
    'Color','k','Linestyle',':','Linewidth',1.5);       %Horizontal axis
hold on;
plot((min(t)+max(t))/2*[1 1],[0 255],...
    'Color','k','Linestyle',':','Linewidth',1.5);       %Vertical axis

%... then plot waveforms, and make text visible for active channels.
for i=1:4,                              
    cStr=['c' num2str(i)];
    if c{i}.active,
        eval(['set(handles.' cStr 'Text,''Enable'',''on'')']);
        eval(['set(handles.' cStr 'vdivText,''Visible'',''on'')']);
        eval(['set(handles.' cStr 'vdivText,'...
            '''String'',num2str(c{i}.range/8))']);
        plot(t,c{i}.raw,'Color',handles.plotcolor{i},'Linewidth',2);
        rawOffset=255*(0.5-c{i}.offset/c{i}.range);     %Location of ground
        plot(max(t),rawOffset,'marker','<',...          %Plot it.
            'MarkerEdgeColor',handles.plotcolor{i},...
            'MarkerFaceColor',handles.plotcolor{i});
    else
        eval(['set(handles.' cStr 'Text,''Enable'',''off'')']);
        eval(['set(handles.' cStr 'vdivText,''Visible'',''off'')']);
    end
end

%... then set axes to look like scope screen.
set(handles.scopeAx,'box','on',...
    'XLim',[min(t) max(t)],...
    'XTick',min(t):((max(t)-min(t))/10):max(t),...
    'XTickLabel','',...
    'XMinorTick','on',...
    'Xgrid','on',...
    'YLim',[0 255],...
    'YTick',0:32:255,...
    'YtickLabel','',...
    'YMinorTick','on',...
    'Ygrid','on');

set(handles.savedataPB,'Enable','on');  %Enable button for saving the data
set(handles.printPB,'Enable','on');     %Enable button for printing the data
handles.channeldata=c;  %Put data in handles for later retrieval.
handles.timedata=t;

close(hwaitbar);
guidata(handles.matlab54602Fig, handles);  %save changes to handles.


% --- Executes on button press in savedataPB.
function savedataPB_Callback(hObject, eventdata, handles)
[fname,pname]=uiputfile('*.mat','Save scope data');
if fname==0,    %File doesn't exist.
    beep;
    warndlg('Problem with filename.','Filname problem.','modal');
    return;
end;

for i=1:4,  %Get data from handles in "cdata" cell array.
    if handles.channeldata{i}.active,
        cdata{i}=handles.channeldata{i}.scaled;
    else
        cdata{i}=[];
    end
end
t=handles.timedata; %Save time in "t" variabl.
dstring=datestr(clock); %Save current data and time (may be useful to have)
save([pname fname],'cdata','t','dstring');  %Save all the info.

% --- Executes on button press in printPB.
function printPB_Callback(hObject, eventdata, handles)
set(handles.matlab54602Fig,'PaperPositionMode','auto')
set(handles.matlab54602Fig,'InvertHardcopy','off')
print -v


