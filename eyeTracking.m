function eyeTracking(cam,ResX,ResY,Mode,UnaDimension,EyeColor)

%% Configuration
%Sensibilidad de movimiento de los ojos
 SensibilidadX=round(ResX/10);
 SensibilidadY=round(ResY/10);
%% Initialize
[pjder,pjizq,ojo,centro,radio,videoFrame]=Autovalores(cam);

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
buffersize=3;
buff=zeros(buffersize,2);

pasabajos=zeros(2,3);
pasabajos2=zeros(2,2);

Kalman=struct('posx',vision.KalmanFilter,'posy',vision.KalmanFilter,'radio',vision.KalmanFilter);

    Kalman(1).posx = vision.KalmanFilter(1,1,'StateCovariance',1,'ProcessNoise',100,'MeasurementNoise',10000);

    Kalman(1).posy = vision.KalmanFilter(1,1,'StateCovariance',1,'ProcessNoise',100,'MeasurementNoise',10000);

    Kalman(2).posx = vision.KalmanFilter(1,1,'StateCovariance',1,'ProcessNoise',100,'MeasurementNoise',10000);

    Kalman(2).posy = vision.KalmanFilter(1,1,'StateCovariance',1,'ProcessNoise',100,'MeasurementNoise',10000);

Kalman(1).radio = vision.KalmanFilter(1,1,'StateCovariance',1,'ProcessNoise',5,'MeasurementNoise',1);
Kalman(2).radio = vision.KalmanFilter(1,1,'StateCovariance',1,'ProcessNoise',5,'MeasurementNoise',1);


    KalmanPuntoRojoX = vision.KalmanFilter(1,1,'StateCovariance',1,'ProcessNoise',100,'MeasurementNoise',10);
    KalmanPuntoRojoY = vision.KalmanFilter(1,1,'StateCovariance',1,'ProcessNoise',100,'MeasurementNoise',10000);
                
notFound=0;
Frame=0;
            
%% Main Loop
while 1
    % get the next frame
    videoFrame = snapshot(cam);
    [pjder,lost(1)]=SeguirFrame(videoFrame,EyeTrackerder,pjder);
    [pjizq,lost(2)]=SeguirFrame(videoFrame,EyeTrackerizq,pjizq);
    ojos(1,:)=boxojo(pjder);
    ojos(2,:)=boxojo(pjizq);
    
    %Checkear si no perdió los puntos de trackeo
    
    %Checkear si la caja fija esta bien fijada
    if Mode
        maxidistance=max(max(abs(ojo(1:2,1:2)-ojos(1:2,1:2))));
        if maxidistance>6
            reAcquire=1;
            disp('box lejos de ojo')
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
        if Frame>100
            saveas(gcf,'PuntoRojoposX.fig')
        end
        Frame=0;
        disp('perdió algun ojo')
        %Distracción
        videoFrame=insertShape(videoFrame,'FilledCircle',[ResX/2,ResY/2, 10],'Color','red');
        imshow(videoFrame)
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
        Frame=1+Frame;
        if Mode
            
             predict(Kalman(1).posx);
             circulo1(1) = correct(Kalman(1).posx,circulo1(1));
             
             predict(Kalman(1).posy);
             circulo1(2) = correct(Kalman(1).posy,circulo1(2));
%              
%              pasabajos(:,1:end-1)=pasabajos(:,2:end);
%              %Filtro Pasabajos
%              pasabajos(:,end)=circulo1(1:2);
%              circulo1(1:2)=mean(pasabajos,2);
             
             predict(Kalman(1).radio);
             circulo1(3) = correct(Kalman(1).radio,circulo1(3));
            
             predict(Kalman(2).posx);
             circulo2(1) = correct(Kalman(2).posx,circulo2(1));
             
             predict(Kalman(2).posy);
             circulo2(2) = correct(Kalman(2).posy,circulo2(2));
%             
%              pasabajos2(:,1:end-1)=pasabajos2(:,2:end);
              %Filtro Pasabajos
%              pasabajos2(:,end)=circulo2(1:2);
%              circulo2(1:2)=mean(pasabajos2,2);
            
            predict(Kalman(2).radio);
            circulo2(3) = correct(Kalman(2).radio,circulo2(3));
            
            
            videoFrame = insertShape(videoFrame, 'Rectangle', bojo1,'Color','red');
            videoFrame = insertShape(videoFrame, 'Rectangle', bojo2,'Color','red');

            videoFrame = insertShape(videoFrame, 'Rectangle', ojo(1,:),'Color','yellow');
            videoFrame = insertMarker(videoFrame, circulo1(1:2), '+','Color', 'red');
            videoFrame = insertShape(videoFrame, 'Rectangle', ojo(2,:),'Color','yellow');
            videoFrame = insertMarker(videoFrame, circulo2(1:2), '+','Color', 'red');

            puntoRojo(1,1)=ResX/2+(ojo(1,3)/2-circulo1(1)+ojo(1,1)-offsetx(1)+ojo(2,3)/2-circulo2(1)+ojo(2,1)-offsetx(2))*SensibilidadX/2;
          
            if UnaDimension
                puntoRojo(1,2)=ResY/2;
            else
                puntoRojo(1,2)=ResY/2-((round(ojos(1,4)/2-circulo1(2)+ojos(1,2)-offsety(1))+round(ojos(2,4)/2-circulo2(2))+ojos(2,2)-offsety(2)))*SensibilidadY/2;
            end
            
            puntoRojo=round(puntoRojo);
                  predict(KalmanPuntoRojoX);
                  puntoRojo(1)=correct(KalmanPuntoRojoX,puntoRojo(1));
                  
                  predict(KalmanPuntoRojoY);
                  puntoRojo(2)=correct(KalmanPuntoRojoY,puntoRojo(2));
         
              
            videoFrame = insertShape(videoFrame,'FilledCircle', [puntoRojo,10] , 'Color', 'green');
        
        else
            videoFrame = insertShape(videoFrame, 'FilledCircle', circulo1,'Color',EyeColor);
            videoFrame = insertShape(videoFrame, 'FilledCircle', circulo2,'Color',EyeColor);
            
        end
        
        %xlim([0,640])
        %ylim([0,480])
        %plot(puntoRojo(1),puntoRojo(2),'*')
        %hold on
        
        
    imshow(videoFrame)
end

% Clean up
clear(cam);
release(videoPlayer);
release(EyeTrackerder);
release(PupileTrackerder);
release(EyeTrackerizq);
release(PupileTrackerizq);
end

