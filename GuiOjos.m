classdef GuiOjos < handle
    
    properties
        handles;
        cam;
    end
    
    methods
        function self=GuiOjos(cam)
            hfig=hgload('GUIfig.fig');
            self.handles=guihandles(hfig);
            set(self.handles.push_start_tracking,'Callback',@self.StartTracking)
            movegui(hfig,'center');
            
%             if ~exist('cam', 'class');
%                 try
%                     self.cam = webcam();
%                 catch
%                     msgbox('pls close active webcam');
%                 end
%             else
%                 self.cam = cam;
%             end
            self.cam = cam;
        end
        
        function StartTracking(self,varargin)
            mode = str2double(get(self.handles.edit_mode,'String'));
            dimension = str2double(get(self.handles.edit_dimensions,'String'));
            color = get(self.handles.edit_eye_color,'String');
            
            if find(strcmp(self.cam.availableResolutions, '640x480'))
                self.eyeTracking(self.cam,640,480, mode, dimension, color)
            else
                res = char(self.cam.availableResolutions(1));
                self.eyeTracking(self.cam,res(1 : strfind(res, 'x') - 1),res(strfind(res, 'x') + 1 : end), mode, dimension, color)
            end
        end
        
        function eyeTracking(self, cam,ResX,ResY,Mode,UnaDimension,EyeColor)
                %% Configuration
                %Sensibilidad de movimiento de los ojos
                if get(self.handles.checkbox_sx,'Value')
                    SensibilidadX=round(ResX/10);
                else
                    SensibilidadX=round(str2double(get(self.handles.edit_sx,'String')));
                end
                if get(self.handles.checkbox_sy,'Value')
                    SensibilidadY=round(ResY/10);
                else
                    SensibilidadY=round(str2double(get(self.handles.edit_sy,'String')));
                end
                %% Initialize
                [pjder,pjizq,ojo,centro,radio,videoFrame]=Autovalores(cam);
                Boxsize=ojo(1,3)*ojo(1,4); 
                circulo1(1:2)=centro(1,1:2);
                circulo2(1:2)=centro(2,1:2);
                circulo1(3)=radio(1);
                circulo2(3)=radio(2);
                
                %%Creo point trackers
                EyeTrackerder = vision.PointTracker('MaxBidirectionalError', 2);
                EyeTrackerizq = vision.PointTracker('MaxBidirectionalError', 2);
                
                %Cargar trackers
                pjder = pjder.Location;
                pjizq = pjizq.Location;
                initialize(EyeTrackerder, pjder, videoFrame);
                initialize(EyeTrackerizq, pjizq, videoFrame);
                lost=zeros(1,2);
                reAcquire=0;
                offsetx=zeros(1,2);
                offsety=zeros(1,2);
                
                
                Kalman=struct('posx',vision.KalmanFilter,'posy',vision.KalmanFilter,'radio',vision.KalmanFilter);
                
                Kalman(1).posx = vision.KalmanFilter(1,1,'StateCovariance',1,'ProcessNoise',10,'MeasurementNoise',100);
                
                Kalman(1).posy = vision.KalmanFilter(1,1,'StateCovariance',1,'ProcessNoise',4,'MeasurementNoise',200);
                
                Kalman(2).posx = vision.KalmanFilter(1,1,'StateCovariance',1,'ProcessNoise',10,'MeasurementNoise',100);
                
                Kalman(2).posy = vision.KalmanFilter(1,1,'StateCovariance',1,'ProcessNoise',4,'MeasurementNoise',200);
                
                Kalman(1).radio = vision.KalmanFilter(1,1,'StateCovariance',1,'ProcessNoise',2,'MeasurementNoise',10);
                Kalman(2).radio = vision.KalmanFilter(1,1,'StateCovariance',1,'ProcessNoise',2,'MeasurementNoise',10);
                
                KalmanPuntoRojoX = vision.KalmanFilter(1,1,'StateCovariance',1,'ProcessNoise',ResX,'MeasurementNoise',5000);
                KalmanPuntoRojoY = vision.KalmanFilter(1,1,'StateCovariance',1,'ProcessNoise',ResY,'MeasurementNoise',10000);
                
                notFound=0;
                Frame=0;
                offsetdistance=zeros(2,2);
                circulo1(1) = correct(Kalman(1).posx,circulo1(1));
                circulo1(2) = correct(Kalman(1).posy,circulo1(2));
                
                %% Main Loop
                while ~get(self.handles.togglebutton_exit,'Value')
                    if get(self.handles.togglebutton_pause, 'Value')
                        while 1
                            if ~get(self.handles.togglebutton_pause, 'Value') || get(self.handles.togglebutton_exit,'Value')
                                break;
                            end
                        end
                    end
                    % get the next frame
                    videoFrame = snapshot(cam);
                    [pjder,lost(1)]=SeguirFrame(videoFrame,EyeTrackerder,pjder);
                    [pjizq,lost(2)]=SeguirFrame(videoFrame,EyeTrackerizq,pjizq);
                    ojos(1,:)=boxojo(pjder);
                    ojos(2,:)=boxojo(pjizq);
                    
                    %Checkear si no perdió los puntos de trackeo
                    
                    %Checkear si la caja fija esta bien fijada
                    if Mode
                        offsetdistance=(ojos(1:2,1:2)-ojo(1:2,1:2));
                        if max(max(abs(offsetdistance)))>10
                            reAcquire=1;
                            disp('box lejos de ojo')
                        end
                    else
                        if  Boxsize> 3*ojos(1,3)*ojos(1,4);
                            reAcquire=1;
                        end
                    end
                
                    
                    if notFound==5
                        disp('muchas veces sin encontrar pupila')
                        reAcquire=1;
                    end
                    
                    if max(lost)
                        disp('perdio autovalores del ojo')
                        reAcquire=1;
                    end
                    
                    if reAcquire
                        disp('perdió algun ojo')
                        %Distracción
%                         videoFrame=insertShape(videoFrame,'FilledCircle',[ResX/2,ResY/2, 10],'Color','red');
%                         imshow(videoFrame)
                        %
                        [pjder,pjizq,ojo,centro,radio,videoFrame]=Autovalores(cam);
                        circulo1(3)=radio(1);
                        circulo2(3)=radio(2);
                        pjder = pjder.Location;
                        pjizq = pjizq.Location;
                        setPoints(EyeTrackerder, pjder)
                        setPoints(EyeTrackerizq, pjizq)
                        reAcquire=0;
                        if Mode
                            offsetx(1)=round(ojo(1,3)/2-centro(1,1)+ojo(1,1));
                            offsetx(2)=round(ojo(2,3)/2-centro(2,1)+ojo(2,1));
                            offsety(1)=round(ojo(1,4)/2-centro(1,2)+ojo(1,2));
                            offsety(2)=round(ojo(2,4)/2-centro(2,2)+ojo(2,2));
                            
                            SensibilidadX=round(ResX/ojo(1,3)*6);
                            if ~UnaDimension
                                SensibilidadY=round(ResY/ojo(1,4)*6);
                            end
                        else
                           Boxsize=ojo(1,3)*ojo(1,4); 
                        end
                        
                    end
                    
                    bojo1=boxojo(pjder);
                    bojo2=boxojo(pjizq);
                    pupa=encontramelapupila2(videoFrame,bojo1,circulo1(3));
                    if ~isempty(pupa)
                        circulo1=pupa;
                        pupa=encontramelapupila2(videoFrame,bojo2,circulo2(3));
                        if ~isempty(pupa)
                            circulo2=pupa;
                            notFound=0;
                        else
                            notFound=notFound+1;
                        end
                    else
                        notFound=notFound+1;
                    end
                    
                    Frame=Frame+1;
                    
                    
                        predict(Kalman(1).radio);
                        circulo1(3) = correct(Kalman(1).radio,circulo1(3));
                    
                        predict(Kalman(2).radio);
                        circulo2(3) = correct(Kalman(2).radio,circulo2(3));
                        
                    if Mode
                        predict(Kalman(1).posy);
                        circulo1(2) = correct(Kalman(1).posy,circulo1(2));
                        
                        
                        predict(Kalman(2).posx);
                        if distance(Kalman(2).posx,circulo2(1))<8 && Frame>50
                            circulo2(1) = correct(Kalman(2).posx,circulo2(1));
                        end
                        
                        predict(Kalman(2).posy);
                        circulo2(2) = correct(Kalman(2).posy,circulo2(2));
                        
                        if Mode==1
                            videoFrame = insertShape(videoFrame, 'Rectangle', bojo1,'Color','red');
                            videoFrame = insertShape(videoFrame, 'Rectangle', bojo2,'Color','red');
                            videoFrame = insertShape(videoFrame, 'Rectangle', ojo(1,:),'Color','yellow');
                            videoFrame = insertMarker(videoFrame, circulo1(1:2), '+','Color', 'red');
                            videoFrame = insertShape(videoFrame, 'Rectangle', ojo(2,:),'Color','yellow');
                            videoFrame = insertMarker(videoFrame, circulo2(1:2), '+','Color', 'red');
                        end
                        
                        puntoRojo(1,1)=ResX/2+(-sum(offsetdistance(1,:))+ojo(1,3)/2-circulo1(1)+ojo(1,1)-offsetx(1)+ojo(2,3)/2-circulo2(1)+ojo(2,1)-offsetx(2))*SensibilidadX/2;
                       
                        if Frame<10
                            puntoRojo=[ResX/2,ResY/2];
                        else
                            if UnaDimension
                                puntoRojo(1,2)=ResY/2;
                            else
                                puntoRojo(1,2)=ResY/2-(round(ojos(1,4)/2-circulo1(2)+ojos(1,2)-offsety(1))+round(ojos(2,4)/2-circulo2(2))+ojos(2,2)-offsety(2))*SensibilidadY/2;
                            end
                       
                        end
                        predict(KalmanPuntoRojoX);
                        puntoRojo(1)=correct(KalmanPuntoRojoX,puntoRojo(1));
                        
                        predict(KalmanPuntoRojoY);
                        puntoRojo(2)=correct(KalmanPuntoRojoY,puntoRojo(2));
                        
                        if Frame <10
                            videoFrame = insertShape(videoFrame,'FilledCircle', [ResX/2,ResY/2,15] , 'Color', 'green');
                        else
                            videoFrame = insertShape(videoFrame,'FilledCircle', [puntoRojo,15] , 'Color', 'green');
                        end
                    else
                        videoFrame = insertShape(videoFrame, 'FilledCircle', circulo1,'Color',EyeColor);
                        videoFrame = insertShape(videoFrame, 'FilledCircle', circulo2,'Color',EyeColor);
                        
                    end
                    
                   if Mode==2 
                    xlim([0,640])
                    ylim([0,480])
                    plot(puntoRojo(1),puntoRojo(2),'*')
                    hold on
                   else
                     imshow(videoFrame)
                   end
                end
                
                % Clean up
                 release(EyeTrackerder);
                 release(EyeTrackerizq);
                %msgbox('agregar en linea 205 cerrar gui, salu2');
                close all;
        end
    end
    
        
end

