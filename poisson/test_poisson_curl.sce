
// Initialise f(x,y)
function [w]=init_field(y,x)
    w = 8*%pi^2*cos(2*%pi*x) * cos(2*%pi*y)
endfunction


// Solution de référence du problème laplacien(psi(x,y)) = f(x,y)
function [Ux]=solution_ux(y,x)
    Ux = (-2*%pi)*cos(2*%pi*x)*sin(2*%pi*y)
endfunction

function [Uy]=solution_uy(y,x)
   Uy = (2*%pi)*sin(2*%pi*x)*cos(2*%pi*y)
endfunction

// Affichage de la fonction f, de la solution de référence et
// de la solution obtenue, ainsi que de l'erreur commise
// F   = f(x,y)         -- fonction testée
// Ref = Psi_alpha(x,y) -- solution analytique
// Psi = Psi_star(x,y)  -- solution du solveur
function plot_error(W, Ux_ref, Ux, Uy_ref, Uy)
    fig = gcf()
    subplot(421)
    title("W")
    plot3d(Y, X, W)
    subplot(423)
    title("Ref Ux")
    plot3d(Y, X, Ux_ref)
    colorbar()
    subplot(425)
    title("Ux")
    plot3d(Y, X, Ux)
    colorbar()
    subplot(427)
    title("1e14 * Err Ux")
    plot3d(Y, X, 1e14*abs(Ux_ref - Ux))
    colorbar()
    subplot(424)
    title("Ref Uy")
    plot3d(Y, X, Uy_ref)
    colorbar()
    subplot(426)
    title("Uy")
    plot3d(Y, X, Uy)
    colorbar()
    subplot(428)
    title("1e14 * Err Uy")
    plot3d(Y, X, 1e14*abs(Uy_ref - Uy))
    colorbar()
    xs2png(fig, "poisson_error2.png")
endfunction


// Fonction de test pour le solveur de Poisson
function test_poisson(Lx, Ly, Nx, Ny)
    printf("::Testing poisson operator::")
    printf("\n  Domain size:    [%0.2f, %0.2f]", Lx, Ly)
    printf("\n  Discretization: [%i, %i]", Nx, Ny)

    // X[i] = i*dx avec dx = Lx/Nx et i=0..Nx-1
    // Y[i] = j*dy avec dy = Ly/Ny et j=0..Ny-1
    X = linspace(0.0, Lx*(Nx-1)/Nx, Nx)
    Y = linspace(0.0, Ly*(Ny-1)/Ny, Ny)

    printf("\n\n  Initializing field F(x,y).")
    W   = feval(Y, X, init_field)

    printf("\n  Initializing reference solution Ref(x,y).")
    Ux_ref = feval(Y, X, solution_ux)
    Uy_ref = feval(Y, X, solution_uy)

    dir  = get_absolute_file_path("test_poisson_curl.sce")
    file = dir+"poisson.sce"
    printf("\n\n  Loading poisson_2d function from file %s%s%s.", char(39), file, char(39))
    exec(file, -1)

    printf("\n\n  Computing Poisson solution Psi(x,y).")
    [Ux, Uy] = poisson_curl_2d(W, Nx, Ny, Lx, Ly)

    printf("\n  Computing error |Psi-Ref|(x,y).")
    Err_ux = abs(Ux-Ux_ref)
    Err_uy = abs(Uy-Uy_ref)

    file = pwd()+"/poisson_error2.png"
    printf("\n\n  Plotting everything to %s%s%s.", char(39), file, char(39))
    plot_error(W, Ux_ref, Ux, Uy_ref, Uy)

    printf("\n\n")
    mErr_ux = max(Err_ux)
    mErr_uy = max(Err_uy)
    max_error = 1e-12

    if (mErr_ux > max_error) & (mErr_uy > max_error) then
        printf("  Maximal error is %.10ef, TEST FAILURE (max_error=%.10ef).\n", max(mErr_ux, mErr_uy), max_error)
        exit(1)
    else
        printf("  Maximal error is only %.10ef, TEST SUCCESS.\n", max(mErr_ux, mErr_uy))
        exit(0)
    end
endfunction


// Taille du domaine
Lx = 1.0
Ly = 1.0

// Discretisation du domaine
Nx = 64
Ny = 32

test_poisson(Lx, Ly, Nx, Ny)
