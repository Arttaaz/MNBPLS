
function dt=calcul_dt(U,dx)
  dt=dx/max(abs(U));
endfunction

function vort=solveur_1D(vort, Ux, Nx, kappa, dt, dx)
    //----------------------------------------------
    //TODO implémenter une itération temporelle
    // de l'algo 1D codé dans le script dif-conf.sce
    //   vort = champ transporté (correspond à phi dans le sujet)
    //   Ux = vitesse sur la composante x
    //   Nx = nombre de points de discrétisation spatiale en x et y.
    //   kappa = constante de diffusion dynamique
    //   dt = pas de temps
    //   dx = pas d'espace
    //-----------------------------------------------

    M = zeros(Nx)
    N = zeros(Nx)

    for i = 1:Nx-1
       M(i, i+1) = -Ux(i)*(dt/(2*dx)) + (Ux(i).^2)*(dt.^2/(2*(dx.^2)))
       M(i, i) = 1 - 2*(Ux(i).^2)*((dt.^2)/(2*(dx.^2)))
       M(i+1, i) = Ux(i)*(dt/(2*dx)) + (Ux(i).^2)*(dt.^2/(2*(dx.^2)))
       N(i, i+1) = -kappa*(dt/(dx.^2))
       N(i+1, i) = -kappa*(dt/(dx.^2))
       N(i, i) = 1 + 2*kappa*(dt/(dx.^2))
    end

    M(1, Nx) = Ux(1)*(dt/(2*dx)) + (Ux(1).^2)*(dt.^2/(2*(dx.^2)))
    M(Nx, 1) = -Ux(Nx)*(dt/(2*dx)) + (Ux(Nx).^2)*(dt.^2/(2*(dx.^2)))
    M(Nx, Nx) = 1 - 2*(Ux(Nx).^2)*((dt.^2)/(2*(dx.^2)))
    N(1, Nx) = -kappa*(dt/(dx.^2))
    N(Nx, 1) = -kappa*(dt/(dx.^2))
    N(Nx, Nx) = 1 + 2*kappa*(dt/(dx.^2))

    vort = N \ (M*vort)

endfunction

function vort=solveur_2D(vort, Ux, Uy, Nx, Ny, kappa, dt, dx, dy)
    //----------------------------------------------
    //TODO implémenter une itération temporelle
    // de l'algo de splitting 2D utilisant l'algo 1D
    //   vort = champ 2D transporté (correspond à phi dans le sujet)
    //   Ux = vitesse sur la composante x
    //   Uy = vitesse sur la composante y
    //   (Nx, Ny) nombre de points de discrétisation spatiale en x et y.
    //   kappa = constante de diffusion dynamique
    //   dt    = pas de temps
    //   (dx, dy) pas d'espaces dans chaque direction
    //-----------------------------------------------
   for i= 1:Ny
    temp= vort(i,1:Nx)'
    vort(i,1:Nx) = solveur_1D(temp, Ux(i,1:Nx), Nx, kappa, dt, dx)';
   end
   // Itération sur les colonnes de vort
   for j=1:Nx
    vort(1:Ny,j) =solveur_1D(vort(1:Ny,j), Uy(1:Ny,j), Ny, kappa, dt, dy);
   end

endfunction
