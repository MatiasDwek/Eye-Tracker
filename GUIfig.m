function varargout = GUIfig(varargin)
% GUIFIG MATLAB code for GUIfig.fig
%      GUIFIG, by itself, creates a new GUIFIG or raises the existing
%      singleton*.
%
%      H = GUIFIG returns the handle to a new GUIFIG or the handle to
%      the existing singleton*.
%
%      GUIFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIFIG.M with the given input arguments.
%
%      GUIFIG('Property','Value',...) creates a new GUIFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIfig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIfig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIfig

% Last Modified by GUIDE v2.5 12-Jun-2015 00:09:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIfig_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIfig_OutputFcn, ...
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


% --- Executes just before GUIfig is made visible.
function GUIfig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIfig (see VARARGIN)

% Choose default command line output for GUIfig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIfig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIfig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in push_start_tracking.
function push_start_tracking_Callback(hObject, eventdata, handles)
% hObject    handle to push_start_tracking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_start_cam.
function pushbutton_start_cam_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_start_cam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_mode_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mode as text
%        str2double(get(hObject,'String')) returns contents of edit_mode as a double


% --- Executes during object creation, after setting all properties.
function edit_mode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_dimensions_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dimensions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dimensions as text
%        str2double(get(hObject,'String')) returns contents of edit_dimensions as a double


% --- Executes during object creation, after setting all properties.
function edit_dimensions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dimensions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_eye_color_Callback(hObject, eventdata, handles)
% hObject    handle to edit_eye_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_eye_color as text
%        str2double(get(hObject,'String')) returns contents of edit_eye_color as a double


% --- Executes during object creation, after setting all properties.
function edit_eye_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_eye_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_pause.
function pushbutton_pause_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_exit.
function pushbutton_exit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in togglebutton_exit.
function togglebutton_exit_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_exit


% --- Executes on button press in togglebutton_pause.
function togglebutton_pause_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_pause


% --- Executes on button press in checkbox_sx.
function checkbox_sx_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_sx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_sx


% --- Executes on button press in checkbox_sy.
function checkbox_sy_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_sy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_sy



function edit_sx_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sx as text
%        str2double(get(hObject,'String')) returns contents of edit_sx as a double


% --- Executes during object creation, after setting all properties.
function edit_sx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_sy_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sy as text
%        str2double(get(hObject,'String')) returns contents of edit_sy as a double


% --- Executes during object creation, after setting all properties.
function edit_sy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
