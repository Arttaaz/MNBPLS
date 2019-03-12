
// Retourne la fréquence d'échantillonage de la transformée de Fourier discrète
function [freqs]=fftfreq(N, L)
    // TODO: Calculer les fréquences d'échantillonage en fonction de L et de la parité de N
endfunction


// Résolution de l'équation de Poisson en dimension 2 en utilisant la FFT
//    laplacien(psi) = f
// Entrée: f de taille (Ny,Nx) sur une domaine de taille (Ly,Lx)
// Sortie: psi, solution de l'équation
function [psi]=poisson_2d(f, Nx, Ny, Lx, Ly)
    kx = // TODO
    ky = // TODO
    psi_hat = zeros(Ny,Nx)
    f_hat = fft(f, "nonsymmetric")
    for p=1:Ny
        for q=1:Nx
            psi_hat(p,q) = // TODO 
        end
    end
    psi = real(ifft(psi_hat, "nonsymmetric"))
endfunction

// Résolution de l'équation de Poisson avec rot en dimension 2 en utilisant la FFT
//    laplacien(Ux) = -dW/dy
//    laplacien(Uy) = +dW/dx
// Entrée: champs de vorticité W de taille (Ny,Nx) sur un domaine de taille (Ly,Lx)
// Sortie: Ux et Uy, vitesses solution des équations
function [Ux,Uy]=poisson_curl_2d(W, Nx, Ny, Lx, Ly)
    // TODO: Calculer Ux et Uy à partir de la vorticité par FFT avec l'option 'nonsymmetric'
endfunction

