function varargout = MatlabTDS3014(varargin)
% %MATLABTDS3014 M-file for MatlabTDS3014.fig
%
%      Written by Noah Marks '11 and Erik Cheever
%
%      MATLABTDS3014, by itself, creates a new MATLABTDS3014 or raises the existing
%      singleton*.
% 
%      H = MATLABTDS3014 returns the handle to a new MATLABTDS3014 or the handle to
%      the existing singleton*.
%
%      MATLABTDS3014('Property','Value',...) creates a new MATLABTDS3014 using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to MatlabTDS3014_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      MATLABTDS3014('CALLBACK') and MATLABTDS3014('CALLBACK',hObject,...) call the
%      local function named CALLBACK in MATLABTDS3014.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MatlabTDS3014

% Last Modified by GUIDE v2.5 10-Aug-2009 13:10:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MatlabTDS3014_OpeningFcn, ...
                   'gui_OutputFcn',  @MatlabTDS3014_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before MatlabTDS3014 is made visible.
function MatlabTDS3014_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for MatlabTDS3014
handles.output = hObject;

for ch=1:4,
    chS=num2str(ch);
    handles.chanText(ch)=eval(['handles.c' chS 'Text']);
    handles.vDivText(ch)=eval(['handles.c' chS 'vdivText']);
    handles.coupling(ch)=eval(['handles.coupletext' chS]);
    handles.plotcolor{ch}=get(handles.chanText(ch),'ForegroundColor');
end

initGUI(handles);
handles=guidata(hObject);  %Reload handles (may be changed in initGui)

handles.channels=[];     %Placeholders (used later)
handles.timedata=[];
handles.offset=[];
handles.timeshift=[];
handles.numpoints=[];

handles.numCollect=500;

% Update handles structure
guidata(hObject, handles);
showAxes(handles);

% UIWAIT makes MatlabTDS3014 wait for user response (see UIRESUME)
% uiwait(handles.MatlabTDS3014fig);


% --- Outputs from this function are returned to the command line.
function varargout = MatlabTDS3014_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in getdataPB.
function getdataPB_Callback(hObject, eventdata, handles)
hwaitbar=waitbar(0,'Download Progress');
s=handles.serial;
set(s,'Timeout',10); %defines 10s as time for timeout

numCollect=str2num(query(s,'HOR:RECORD?'))

if numCollect==10000,
    numAdd=8;
else
    numAdd=7;
end
handles.numCollect=numCollect;

%Get time per div data, stores in handle, displays
handles.tdiv=str2num(query(s,'HOR:MAI:SCA?'));
divisionTime=handles.tdiv;
if divisionTime<1E-3,
    tMul=1E6;  tUnits='(uS)';
elseif divisionTime<1,
    tMul=1E3;  tUnits='(mS)';
else
    tMul=1; tUnits='(S)';
end
        

set(handles.tdivText,'String',num2str(handles.tdiv*tMul));
set(handles.tDiv_PANEL,'Title',['Time/Div ' tUnits]);
set(handles.tdivText,'Visible','on');

handles.channels.chanSelect=query(s,'SEL?'); %checks which chanels are active


waitbar(0.2,hwaitbar);
for ch=1:4,
    chS=num2str(ch);      %String representation of channel for cell data
    if handles.channels.chanSelect(ch*2-1)=='1',  % If channel is active.
        handles.channels.state(ch)=1; %stores that state
        handles.channels.scale(ch)=str2num(query(s,['CH' chS ':SCA?']));
        fprintf(s,['DAT:SOU CH' chS]);
        
        fprintf(s,'CURV?');
        [s1, cnt]=fread(s, 2*numCollect+numAdd); %fread is specifically for binary data
        %pulls and stores curve data
        handles.channels.wfmpre{ch}=query(s,'WFMPre?');
        s1=s1(numAdd:(end-1)); %Tuncates data from preamble and postamble
        s2=s1(1:2:end)*256+s1(2:2:end); %changes binary data to numbers using base 256
        handles.channels.wfmdat{ch}=s2-32768; %shifts to useful vertical scale
        
        
        %Turns on channel text and bolds it, along with the vertical
        %division
        set(handles.chanText(ch),'FontWeight','bold');
        set(handles.chanText(ch),'Enable','on');
        set(handles.vDivText(ch),'Visible','on');
        set(handles.vDivText(ch),'String',num2str(handles.channels.scale(ch)));
        
        %Checks and reports the coupling status to the display 
        chanelcoupling=query(s,['CH' chS ':COUP?']);
        set(handles.coupling(ch),'Visible','on');
        set(handles.coupling(ch),'string', chanelcoupling);
         
        
        handles.offset.vshift{ch}=str2num(query(s, ['CH' chS ':POS?'])); %Finds the vertical shift 
        %set(handles.MatlabTDS3014fig, 'CurrentAxes', handles.scopeAx); %this brings the axes to the front!!
        handles.channels.bytevoltconvert{ch}=str2num(query(s,'WFMP:YMU?'));
        handles.channels.vshiftvolts{ch}=handles.channels.scale(ch)*str2num(query(s, ['CH' chS ':POS?']));
        
        
    else
        %leaves everything blank and off
        handles.channels.state(ch)=0;
        handles.channels.scale(ch)=-inf;
        handles.channels.wfmpre{ch}=-inf;
        handles.channels.wfmdat{ch}=-inf;
 
        set(handles.chanText(ch),'FontWeight','light');
        set(handles.chanText(ch),'Enable','off');
        set(handles.vDivText(ch),'Visible','off');
        set(handles.vDivText(ch),'String',num2str(handles.channels.scale(ch)));
    end
    waitbar(0.2+ch/5,hwaitbar)
end
handles.channels;
close(hwaitbar);

showAxes(handles); %clears and resets axes for new data
for ch=1:4
    if handles.channels.chanSelect(ch*2-1)=='1',  % If channel is active.
        axes(handles.scopeAx);
        
        %plots ground for each chanel
        plot(0,.25*handles.offset.vshift{ch},'>', 'Color', handles.plotcolor{ch}, ...
             'MarkerSize',10, 'MarkerFaceColor', handles.plotcolor{ch});

        %Pulls and converts the y-position data from pixels to normed
        %voltages (on a -1 to 1 scale for all channels).
        voltsperdivision=handles.channels.scale(ch);
        values=handles.channels.wfmdat{ch};
        y=handles.channels.bytevoltconvert{ch}.*values./(4*voltsperdivision);
        handles.offset.withoutoffset{ch}=4*y*voltsperdivision; %formats data for later save
        plot(y,'color',handles.plotcolor{ch}); %plots and saves parameters of signal
    end
end

%Showing the Time Shift
handles.timeshift.state=query(s, 'HOR:DEL:STATE?'); %whether manual or delay setting is on
if str2num(handles.timeshift.state)*1==0 %if delay setting is off
    handles.timeshift.percentmove=str2num(query(s,'HOR:TRIG:POS?')); %done in percents, and shifted
    plot(numCollect*0.01*handles.timeshift.percentmove,1, 'rv', 'MarkerSize',8, 'MarkerFaceColor', 'r');
else %delay setting is on
    handles.timeshift.timemove=str2num(query(s,'Hor:Del:Tim?')); %done in terms of time
    plot((numCollect/2)-(handles.timeshift.timemove*numCollect/(10*divisionTime)), 1,'rv', 'MarkerSize',8, 'MarkerFaceColor', 'r');
end

%Once data is pulled, allows printing and saving.
set(handles.savedataPB,'Enable','on');
set(handles.printPB,'Enable','on');
hold off

% Update handles structure
guidata(handles.MatlabTDS3014fig, handles);



% --- Executes on button press in savedataPB.
function savedataPB_Callback(hObject, eventdata, handles)
%Get time per div data.
divisionTime=handles.tdiv; %pulls parameters from handles
numCollect=handles.numCollect; 
xstep=divisionTime*10/numCollect;
range=[-numCollect/2:1:numCollect/2-1]'; %To map the time onto the indicies of the data
xintermediate=xstep.*range; %creates a time vector

%Time Shift
if str2num(handles.timeshift.state)*1==0 %whether or not delay is used
    actualshift=5*divisionTime-divisionTime*0.1*handles.timeshift.percentmove; %done with percentages
else 
    actualshift=(handles.timeshift.timemove); %simple time shift
end
x=xintermediate+actualshift; %adding the shift to the time vector

for ch=1:4,
    if handles.channels.chanSelect(ch*2-1)=='1',  % If channel is active.  
        y=(handles.offset.withoutoffset{ch}-handles.channels.vshiftvolts{ch}); %defines the output vector and saves
        data{ch}=y;
    else 
        data{ch}=[];
    end
end

%User prompt for comment
comm=inputdlg('Enter Comment for Data File','Comment');
fileComment=[comm{1} '; Date:' datestr(clock)]; 

%User prompt to ssave
[fname,pname]=uiputfile('*.mat', 'Save Scope Data');
if fname==0,
    beep;
    warndlg('Problem with Filename.', 'Filename Problem.','modal');
    return;
end
t=x;
save([pname fname], 't','data', 'fileComment');


% --- Executes on button press in printPB.
function printPB_Callback(hObject, eventdata, handles)
set(handles.MatlabTDS3014fig,'PaperPositionMode','auto')
set(handles.MatlabTDS3014fig, 'InvertHardcopy','off')
print -v


% --- Executes on button press in exitPB.
function exitPB_Callback(hObject, eventdata, handles)
close(handles.MatlabTDS3014fig);


% --- Executes on button press in helpbutton.
function helpbutton_Callback(hObject, eventdata, handles)
web('http://www.swarthmore.edu//NatSci/echeeve1/Ref/TDS4013/MatLabTDS4013.html','-browser')

function showAxes(handles)
%this function sets and clears the axes on the display, with the center
%lines in the middle as on the oscilloscope
cla(handles.scopeAx);
numPts=handles.numCollect;
set(handles.scopeAx, 'box','on',...
    'XLim', [0,numPts],...
    'Xgrid','on',...
    'XTick', [0:numPts/10:numPts],...
    'YLim', [-1,1],...
    'Ygrid', 'on',...
    'YTick', [-1:1/4:1],...
    'XMinorTick', 'on',...
    'YMinorTick', 'on',...
    'XTickLabel',{''},...
    'YTickLabel',{''}); 
hold on
plot([0 numPts], [0 0],'Color','k','Linewidth', 1.5); 
plot([numPts/2 numPts/2], [-1 1],'Color','k','Linewidth', 1.5);

function initGUI(handles)
openPorts=instrfind('Port','COM1');
if ~isempty(openPorts),
    fclose(openPorts); %Close all open serial connections
    delete(openPorts);
end

%Defines the serial connection needed.

s=serial('COM1',...
    'baud',38400,...
    'FlowControl','hardware',...
    'InputBufferSize',50000,...
    'Timeout',1,...
    'ReadAsyncMode','continuous');
fopen(s);

% Try to open, program fails at query if connection isn't made.
w={'Warning...',...
    'Unable to establish communications with oscilloscope.',' ',...
    'Check that:'...
    '1) Baud rates are equal (On scope hit ''Utility'' button,',...
    '   then ''System'' to get to I/O menu,',...
    '   then set parameters to default,'...
    '   then change baud rate to 38400), and'...
    '2) Serial port cable is connected from scope to computer, and'...
    '3) The oscilloscope is on.'};
warnHandle=warndlg(w,'Serial Comm. Error','on-modal');
idString=query(s,'ID?');
close(warnHandle);

if isempty(findstr(idString,'3014B')),
    beep;                       %Warning for if communications did not work.
    warndlg(w,'Serial Comm. Error','modal')
    close(handles.MatlabTDS3014fig);
    return
end

fprintf(s,'DAT:ENC RPB');       %Takes the data in 16 bit binary
fprintf(s,'DAT:WID 2');         %2 bytes of data
fprintf(s,['HOR:RECORD 500']);  %500 points
fprintf(s,'DAT:STAR 1');        %Start with first point
fprintf(s,['DAT:STOP 500']);    %End with 500th point

handles.serial=s;
%setting the text off pending data reception
set(handles.c1vdivText,'Visible','off');
set(handles.c2vdivText,'Visible','off');
set(handles.c3vdivText,'Visible','off');
set(handles.c4vdivText,'Visible','off');
set(handles.coupletext1,'Visible','off');
set(handles.coupletext2,'Visible','off');
set(handles.coupletext3,'Visible','off');
set(handles.coupletext4,'Visible','off');
set(handles.tdivText,'Visible','off');
set(handles.savedataPB,'Enable','off');
set(handles.printPB,'Enable','off');
set(handles.numPts500_RB, 'Value', 1);
set(handles.numPts10000_RB, 'Value', 0);
handles.numCollect=500;

% Update handles structure
guidata(handles.MatlabTDS3014fig, handles);



% --- Executes on button press in numPts500_RB.
function numPts500_RB_Callback(hObject, eventdata, handles)
s=handles.serial;
set(s,'Timeout',1); %defines 1s as time for timeout
fprintf(s,['HOR:RECORD 500']); 
fprintf(s,['DAT:STOP 500']);


% --- Executes on button press in numPts10000_RB.
function numPts10000_RB_Callback(hObject, eventdata, handles)
s=handles.serial;
set(s,'Timeout',1); %defines 1s as time for timeout
fprintf(s,['HOR:RECORD 10000']); 
fprintf(s,['DAT:STOP 10000']);

