clear;

Lx=10;
Ly=100;
dx=0.1;
dy=0.1;
nx=fix(Lx/dx);
ny=fix(Ly/dy);

x = linspace(0, Lx, nx);
y = linspace(0, Ly, ny);

T=200;

% video
% ten vide�o writer nie umie chyba nadpisywa� plik�w, zawsze musi mie� now�
% nazw�
vidObj = VideoWriter('wave_boundaries.avi');
open(vidObj);

%% variables
% za t� macierz mo�na podstawi� t� 0-1 w kszta�cie S np, to by by�o fajne
wn=zeros(nx,ny);

% 0 - teren niedost�pny
% 1 - rzeka
% 2 - brzeg/granica
terrain_map = [
[0,2,1,1,1,1,2,0,0,0]
[0,0,2,1,1,1,2,0,0,0]
[0,0,0,2,1,1,1,2,0,0]
[0,0,0,0,2,1,1,1,2,0]
[0,0,0,2,1,1,1,2,0,0]
[0,0,2,1,1,1,2,0,0,0]
[2,1,1,1,2,0,0,0,0,0]
[0,2,1,1,2,0,0,0,0,0]
[0,2,1,1,1,2,0,0,0,0]
[0,0,2,1,1,1,2,0,0,0]
];

wn_past=wn;
wn_future=wn;

CFL=0.5;
c=1;
dt=CFL*dx/c;


%%Time
t=0;

while(t<T)
   % odbijanie fale od kraw�dzi
   % wn(:, [1 end]) = 0;
   % wn([1 end], :) = 0;
   
   % chyba te� odbijanie tylko bardziej pro

   wn_future(1,:) = wn(2,:) + ((CFL-1)/(CFL+1))*(wn_future(2,:)-wn(1,:));
   wn_future(end,:) = wn(end-1,:) + ((CFL-1)/(CFL+1))*(wn_future(end-1,:)-wn(end,:));
   wn_future(:,1) = wn(:,2)+((CFL-1)/(CFL+1))*(wn_future(:,2)-wn(:,1));
   wn_future(:,end) = wn(:,end-1) + ((CFL-1)/(CFL+1))*(wn_future(:,end-1)-wn(:,end));

   t=t+dt;
   wn_past=wn;
   wn=wn_future;
   
   % tutaj si� tworzy fala inicjuj�ca
   %for i=1:10
     %wn(i*10,end-1)=dt^2*20*sin(30*pi*t/20);
   %end
   
   % tutaj si� tworzy fala inicjuj�ca
   wn(50,1)=dt^2*5*sin(30*pi*t/40);
    
   for i=2:nx-1
       for j=2:ny-1
          if terrain_map(fix(j/100)+1,fix(i/10)+1)==1
              wn_future(i,j) = 2*wn(i,j) - wn_past(i,j) ...
                  + CFL^2 * (wn(i+1,j) + wn(i,j+1) - 4*wn(i,j) + wn(i-1,j) + wn(i,j-1));
          end
       end
   end
   
   clf;
   subplot(2,1,1);
   imagesc(y, x, wn);
   colorbar;
   caxis([-0.02 0.02]);
   
   subplot(2,1,2);
   mesh(x, y, wn');
   colorbar;
   caxis([-0.02 0.02]);
   axis([0 Lx 0 Ly -0.02 0.02]);
   shg;
   pause(0.01);
   
   % video
   currFrame = getframe;
   writeVideo(vidObj, currFrame);
end

close(vidObj);