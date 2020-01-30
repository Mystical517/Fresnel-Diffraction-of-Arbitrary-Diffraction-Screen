function varargout = untitled5(varargin)
% UNTITLED5 MATLAB code for untitled5.fig
%      UNTITLED5, by itself, creates a new UNTITLED5 or raises the existing
%      singleton*.
%
%      H = UNTITLED5 returns the handle to a new UNTITLED5 or the handle to
%      the existing singleton*.
%
%      UNTITLED5('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED5.M with the given input arguments.
%
%      UNTITLED5('Property','Value',...) creates a new UNTITLED5 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled5_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled5_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled5

% Last Modified by GUIDE v2.5 26-Jun-2019 23:42:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled5_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled5_OutputFcn, ...
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


% --- Executes just before untitled5 is made visible.
function untitled5_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled5 (see VARARGIN)

% Choose default command line output for untitled5
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled5 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled5_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% ѡ��������
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn,fi]=uigetfile('*.jpg','ѡ��ͼƬ');
imdata=imread([pn fn]);
lev=graythresh(imdata);%ȷ����ֵ����ֵ
global I;
I=im2bw(imdata,lev);%�ܷ�ǿ����չ��n*n
%set(handles.axes1,'userdata',I);
axes(handles.axes1);
imshow(I)
title('��ֵ��������������ɫ����͸��');


function calculate(handles)
global I;
global x;
global y;
global G;
global N;
disp(N);
L=get(handles.slider3,'Value');%�����߶�
set(handles.edit3,'String',num2str(L)); 
lamda_o=get(handles.slider2,'Value');% �������䲨��;
set(handles.edit2,'String',num2str(lamda_o)); 
lamda=lamda_o/1e6;%��λת��Ϊmm
k=2*pi/lamda;
z=get(handles.slider1,'Value');%�������
set(handles.edit1,'String',num2str(z)); 
disp(L(1));
dx=L/N;
dxx=lamda*z/N;
z1=50*sqrt(2*(L/2)^2);%����,���������佨�����
z2=50*(2*(L/2)^2)/lamda;%Զ�������ź̷����佨�����
disp('��������������');
disp((z>z1));
disp('���ź̷���������')
disp((z>z2));
disp(z2);
disp((dx^2<dxx));

if (dx^2<dxx)%����������
%T-FFT�㷨
%IR�㷨
[x,y]=meshgrid(linspace(-L/2,L/2,N));%�ռ���
h=exp((1j*k*(x.^2+y.^2))/(2*z)); %������Ӧ����
H=fft2(fftshift(h))*dx.^2;
B=fft2(fftshift(I));
G=(exp(1j*k*z)/(1j*lamda*z))*ifftshift(ifft2(H.*B));
else
fx=-1/(2*dx):1/L:1/(2*dx)-1/L;%Ƶ��������
[FX,FY]=meshgrid(fx,fx);
%D-FFT��TF
h=exp(-1j*pi*lamda*z*(FX.^2+FY.^2))*exp(1j*k*z);
H=fftshift(h);
B=fft2(fftshift(I));
G=ifftshift(ifft2(H.*B));
end
axes(handles.axes2);
imshow(log(1+abs(G)),[]);
%imshow(abs(G));
title('����ͼ��');
clear;



% ��ʾ��ǿ�ֲ�
function pushbutton2_Callback(hObject, eventdata, handles)
global G;
global x;
global y;
figure('NumberTitle', 'off', 'Name', '����ǿ�ȷֲ�');
meshz(x,y,abs(G));
title('����ǿ�ȷֲ�');

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
calculate(handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
calculate(handles);





% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Message='��������������ݴ�ѧ�����ѧ�뼼��ѧԺ2018������һ��¼�������,�����������ο���';
h = msgbox(Message,'���ڱ����');

% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global G;
T=num2str(clock); %clock��¼��ǰ����ʱ�䣬ת�����ַ�����ʽ
T(find(isspace(T))) =[]; %ȥ��T�еĿո� 
Tl=length(T); %����T�ĳ���
Time=T(1:(Tl-6)); %ȥ��T�ж�������֣��õ����ں�ʱ��Ľ�����ʽ
filename=strcat(Time,'����ͼ��.jpg'); %���ɱ����ļ���·�����ļ���
imwrite(log(1+abs(G)),filename);

% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
calculate(handles);

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%edit�������slider������calculate
function edit3_Callback(hObject, eventdata, handles)
set(handles.slider3,'value',str2num(get(hObject,'string')));
calculate(handles);
function edit2_Callback(hObject, eventdata, handles)
set(handles.slider2,'value',str2num(get(hObject,'string')));
calculate(handles);
function edit1_Callback(hObject, eventdata, handles)
set(handles.slider1,'value',str2num(get(hObject,'string')));
calculate(handles);



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global N;
N=str2double(get(handles.edit4,'String'));%���ò�����
str=strcat('ͼ��Ҫ��',num2str(N),'*',num2str(N),'����');
set(handles.text13,'String',str);
disp(N);
% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
