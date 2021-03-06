
// Retourne la fréquence d'échantillonage de la transformée de Fourier discrète
function [freqs]=fftfreq(N, L)
    // TODO: Calculer les fréquences d'échantillonage en fonction de L et de la parité de N
    if modulo(N,2) == 0 then
      p = int(N/2)
      freqs = ((2 * %i * %pi) / L) * cat(2, linspace(0, p-1, p), linspace(-p,-1, p))
   else
      p = int((N-1)/2)
      freqs = ((2 * %i * %pi) / L) * cat(2, linspace(0, p, p+1), linspace(-p,-1, p+1))
   end
endfunction


// Résolution de l'équation de Poisson en dimension 2 en utilisant la FFT
//    laplacien(psi) = f
// Entrée: f de taille (Ny,Nx) sur une domaine de taille (Ly,Lx)
// Sortie: psi, solution de l'équation
function [psi]=poisson_2d(f, Nx, Ny, Lx, Ly)
    kx = fftfreq(Nx, Lx)
    ky = fftfreq(Ny, Ly)
    psi_hat = zeros(Ny,Nx)
    f_hat = fft(f, "nonsymmetric")
    for p=1:Ny
        for q=1:Nx
             psi_hat(p,q) = f_hat(p,q)/(kx(q)^2 + ky(p)^2)
        end
    end
    psi_hat(1,1) = 0
    psi = real(ifft(psi_hat, "nonsymmetric"))
endfunction

// Résolution de l'équation de Poisson avec rot en dimension 2 en utilisant la FFT
//    laplacien(Ux) = -dW/dy
//    laplacien(Uy) = +dW/dx
// Entrée: champs de vorticité W de taille (Ny,Nx) sur un domaine de taille (Ly,Lx)
// Sortie: Ux et Uy, vitesses solution des équations
function [Ux,Uy]=poisson_curl_2d(W, Nx, Ny, Lx, Ly)
    // TODO: Calculer Ux et Uy à partir de la vorticité par FFT avec l'option 'nonsymmetric'
    W_hat = fft(W, "nonsymmetric")
    Ux_hat = zeros(Ny, Nx)
    Uy_hat = zeros(Ny, Nx)
    kx = fftfreq(Nx, Lx)
    ky = fftfreq(Ny, Ly)

    for i = 1:Ny
      for j = 1:Nx
         Ux_hat(i,j) = W_hat(i,j)*(-ky(i))/(kx(j)^2 + ky(i)^2)
         Uy_hat(i,j) = W_hat(i,j)*(kx(j))/(kx(j)^2 + ky(i)^2)
      end
    end
    Ux_hat(1,1) = 0
    Uy_hat(1,1) = 0

    Ux = ifft(Ux_hat, "nonsymmetric")
    Uy = ifft(Uy_hat, "nonsymmetric")

endfunction
