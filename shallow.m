Lx=10;
Ly=10;
dx=0.1;
dy=0.5;
nx=fix(Lx/dx);
ny=fix(Ly/dy);

x = linspace(0, Lx, nx);
y = linspace(0, Ly, ny);

T=10;

%% variables
wn=zeros(nx,ny);
wn_past=wn;
wn_future=wn;

CFL=0.5;
c=1;
dt=CFL*dx/c;


%%Time
t=0;

while(t<T)
   % wn(:, [1 end]) = 0;
   % wn([1 end], :) = 0;
   
   wn_future(1,:) = wn(2,:) + ((CFL-1)/(CFL+1))*(wn_future(2,:)-wn(1,:));
   wn_future(end,:) = wn(end-1,:) + ((CFL-1)/(CFL+1))*(wn_future(end-1,:)-wn(end,:));
   wn_future(:,1) = wn(:,2)+((CFL-1)/(CFL+1))*(wn_future(:,2)-wn(:,1));
   wn_future(:,end) = wn(:,end-1) + ((CFL-1)/(CFL+1))*(wn_future(:,end-1)-wn(:,end));
   
   t=t+dt;
   wn_past=wn;
   wn=wn_future;
   
   wn(50,1)=dt^2*10*sin(30*pi*t/20);
   
   for i=2:nx-1
       for j=2:ny-1
          wn_future(i,j) = 2*wn(i,j) - wn_past(i,j) ...
              + CFL^2 * (wn(i+1,j) + wn(i,j+1) - 4*wn(i,j) + wn(i-1,j) + wn(i,j-1));
          
       end
   end
   clf;
   subplot(2,1,1);
   imagesc(x, y, wn');
   colorbar;
   caxis([-0.02 0.02]);
   
   subplot(2,1,2);
   mesh(x, y, wn');
   colorbar;
   caxis([-0.02 0.02]);
   axis([0 Lx 0 Ly -0.05 0.05]);
   shg;
   pause(0.01);
   
end