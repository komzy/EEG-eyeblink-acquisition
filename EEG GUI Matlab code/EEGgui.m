function varargout = EEGgui(varargin)
% EEGGUI MATLAB code for EEGgui.fig
%      EEGGUI, by itself, creates a new EEGGUI or raises the existing
%      singleton*.
%
%      H = EEGGUI returns the handle to a new EEGGUI or the handle to
%      the existing singleton*.
%
%      EEGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EEGGUI.M with the given input arguments.
%
%      EEGGUI('Property','Value',...) creates a new EEGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EEGgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EEGgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EEGgui

% Last Modified by GUIDE v2.5 26-Jun-2015 22:30:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EEGgui_OpeningFcn, ...
                   'gui_OutputFcn',  @EEGgui_OutputFcn, ...
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


% --- Executes just before EEGgui is made visible.
function EEGgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EEGgui (see VARARGIN)

% Choose default command line output for EEGgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes EEGgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
clc;

% --- Outputs from this function are returned to the command line.
function varargout = EEGgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


    

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fid = fopen('E:\University\FYP\EEG Files and MATLAB C++ stuff\FYP eyeblink\4.txt','r');
global signal t fs limits value1 value2;
value1=0;
value2=0;
fs=1000;
signal = fscanf(fid,'%f');
fclose(fid);
t=0:1/fs:(length(signal)-1)/fs;
limits=[0 max(t)];
axes(handles.axes1);
cla reset;
plot(t,signal);
xlim(limits);
title('Raw Signal')
xlabel('Time');
ylabel('Amplitude');


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
 global original signal t value1 value2 PLF fs eyeblink limits;
 wo = 50/(fs/2); 
 bw = wo/35;
[b,a] = iirnotch(wo,bw);
load 'Eyeblink_final.mat'

value1 = get(hObject, 'Value');

if ((value1&&value2) == 1)
PLF=filter(b,a,eyeblink);
axes(handles.axes2);
plot(t,PLF);

elseif ((value1 || value2) == 0)
axes(handles.axes2);
cla reset;  

elseif value1==0
    if value2==1
        eyeblink=filter(Eyeblink_final,1,signal);
        axes(handles.axes2);
        plot(t,eyeblink); 
    end
    
elseif value1
PLF=filter(b,a,signal);
axes(handles.axes2);
plot(t,PLF);
end
xlim(limits);
title('Filtered Signal')
xlabel('Time');
ylabel('Amplitude');


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
 global original signal t value1 value2 PLF fs eyeblink limits;
load 'Eyeblink_final.mat'

wo = 50/(fs/2); 
bw = wo/35;
[b,a] = iirnotch(wo,bw);

value2 = get(hObject, 'Value');

if (value2 && value1)
eyeblink=filter(Eyeblink_final,1,PLF);
axes(handles.axes2);
plot(t,eyeblink); 

elseif ((value2 || value1) == 0)
axes(handles.axes2);
cla reset;  

elseif value2==0
    if value1==1
        PLF=filter(b,a,signal);
        axes(handles.axes2);
        plot(t,PLF); 
    end
    
elseif value2
axes(handles.axes2);
eyeblink=filter(Eyeblink_final,1,signal);
plot(t,eyeblink); 


end
xlim(limits);
title('Filtered Signal')
xlabel('Time');
ylabel('Amplitude');
% 
