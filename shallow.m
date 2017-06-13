clear;

Lx=10;
Ly=50;
dx=0.1;
dy=0.2;
nx=fix(Lx/dx);
ny=fix(Ly/dy);

x = linspace(0, Lx, nx);
y = linspace(0, Ly, ny);

T=100;

% video
% vidObj = VideoWriter('wave_boundaries.avi');
% open(vidObj);

%% variables
wn=zeros(nx,ny);

wn_past=wn;
wn_future=wn;

CFL=0.5;
c=1;
dt=CFL*dx/c;

% evaporation level for each time interval
evaporation_interval = 10;
% coefficient of evaporation
cevap = 0.1;
surface = 1;
% scaled from 0.0 to 1.0
evaporation = surface * cevap;

% Time
t=0;
% evaporation time counter
evaporation_index = 0;

while(t<T)
  wn_future(1,:) = wn(2,:) + ((CFL-1)/(CFL+1))*(wn_future(2,:)-wn(1,:));
  wn_future(end,:) = wn(end-1,:) + ((CFL-1)/(CFL+1))*(wn_future(end-1,:)-wn(end,:));
  wn_future(:,1) = wn(:,2)+((CFL-1)/(CFL+1))*(wn_future(:,2)-wn(:,1));
  wn_future(:,end) = wn(:,end-1) + ((CFL-1)/(CFL+1))*(wn_future(:,end-1)-wn(:,end));

   t=t+dt;
   wn_past=wn;
   wn=wn_future;

   % Initial waves
   wn(10,end)=dt^2*10*sin(10*pi*t/10);
   wn(30,end)=dt^2*20*cos(10*pi*t/10);
   wn(50,end)=dt^2*30*sin(5*pi*t/5);
   wn(70,end)=dt^2*20*cos(10*pi*t/10);
   wn(90,end)=dt^2*10*sin(10*pi*t/10);
   
   for i=2:nx-1
       for j=2:ny-1
          % waves
          wn_future(i,j) = 2*wn(i,j) - wn_past(i,j) ...
              + CFL^2 * (wn(i+1,j) + wn(i,j+1) - 4*wn(i,j) + wn(i-1,j) + wn(i,j-1));
          
          % evaporation
          if evaporation_index >= evaporation_interval
            wn_future(i,j) = wn_future(i,j)*(100-evaporation*100)/100;
            evaporation_index = 0;
          end
       end
   end
   
   clf;
   
   subplot(2,1,1);
   imagesc(y, x, wn);
   colorbar;
   caxis([-0.02 0.02]);
   title(['Time: ' num2str(t)]);
   
   subplot(2,1,2);
   mesh(x, y, wn');
   colorbar;
   caxis([-0.02 0.02]);
   axis([0 Lx 0 Ly -0.02 0.02]);
   colormap winter;
   pbaspect([1 5 2]);
   shg;
   pause(0.01)
   
   % video frame capturing
   % currFrame = getframe;
   % writeVideo(vidObj, currFrame);
   evaporation_index = evaporation_index + 1;
end

close(vidObj);