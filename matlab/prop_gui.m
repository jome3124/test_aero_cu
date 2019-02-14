function varargout = prop_gui(varargin)
% PROP_GUI MATLAB code for prop_gui.fig
%      PROP_GUI, by itself, creates a new PROP_GUI or raises the existing
%      singleton*.
%
%      H = PROP_GUI returns the handle to a new PROP_GUI or the handle to
%      the existing singleton*.
%
%      PROP_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROP_GUI.M with the given input arguments.
%
%      PROP_GUI('Property','Value',...) creates a new PROP_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before prop_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to prop_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help prop_gui

% Last Modified by GUIDE v2.5 14-Feb-2019 16:22:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @prop_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @prop_gui_OutputFcn, ...
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


% --- Executes just before prop_gui is made visible.
function prop_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to prop_gui (see VARARGIN)

% Choose default command line output for prop_gui
handles.output = hObject;
handles.s = serial('COM3');
fopen(handles.s);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes prop_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = prop_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pre_launch_button.
function pre_launch_button_Callback(hObject, eventdata, handles)
% hObject    handle to pre_launch_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fprintf(handles.s, 'b');
gather_data(handles.s);


% --- Executes on button press in launch_rocket_button.
function launch_rocket_button_Callback(hObject, eventdata, handles)
% hObject    handle to launch_rocket_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fprintf(handles.s, 'r');


% --- Executes on button press in reset_button.
function reset_button_Callback(hObject, eventdata, handles)
% hObject    handle to reset_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fprintf(handles.s, 'f');
fclose(handles.s);


% --- Executes on button press in initialize_button.
function initialize_button_Callback(hObject, eventdata, handles)
% hObject    handle to initialize_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gather_data(handles.s);
