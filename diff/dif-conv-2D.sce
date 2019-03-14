
dx=Lx/Nx;
dy=Ly/Ny;

exec("dif-conv-f.sce")

maillage_x=linspace(0,(Nx-1)/Nx*Lx,Nx)';
maillage_y=linspace(0,(Ny-1)/Ny*Ly,Ny)';

cx=zeros(Ny,Nx); //composante x de la vitesse de convection
cy=zeros(Ny,Nx); //composante y de la vitesse de convection

phi=zeros(Ny,Nx);   //fonction à calculer
phi_i=zeros(Ny,Nx); //condtion initiale

//------------------------------------------
//TODO remplir les tableaux cx cy phi phi_i
//------------------------------------------
for i=1:Ny
   for j=1:Nx
      u = conv(dy*(j-1), dx*(i-1));
      cx(i,j) = u(2);
      cy(i, j) = u(1);
      phi_i(i, j) = phi_0((i-1)*dy,(j-1)*dx);
   end
end

phi = phi_i

dt=min(calcul_dt(cx,dx),calcul_dt(cy,dy));
Nt=floor(Tf/dt);
for k=1:Nt
    //-----------------
    // TODO
    //----------------
    phi = solveur_2D(phi, cx, cy, Nx, Ny, nu, dt, dx, dy)
end
