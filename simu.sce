
// Domain size and discretization
Lx = 1.0
Ly = 1.0
Nx = 128
Ny = 128
dx = Lx/Nx
dy = Ly/Ny
X = linspace(0.0, Lx*(Nx-1)/Nx, Nx)
Y = linspace(0.0, Ly*(Ny-1)/Ny, Ny)

// Simulation parameters
T     = 1.50
nu    = 0.5e-4
rho   = 100.0
delta = 0.05


// Initialize vorticity
function [W] = init_vorticity(y,x)
   if y <= 0.5 then
      W = 2*%pi*delta*cos(2*%pi*x) - rho*(1 - tanh(rho*(y-0.25))^2)
   else
      W = 2*%pi*delta*cos(2*%pi*x) + rho*(1 - tanh(rho*(0.75 - y))^2)
   end
endfunction


// Plot and dump fields (at every steps of the simulation so that we can generate a video)
function plot_fields(W, Ux, Uy, iteration)
    fig = scf(0)
    clf()
    fig.color_map = [jetcolormap(64); whitecolormap(1)]
    fig.background = 65;
    cmm = [0,64]

    subplot(131)
    title("W(x,y)")
    colorbar(min(W), max(W), cmm)
    Sgrayplot(X, Y, W', colminmax=cmm)
    xlabel("x")
    ylabel("y")

    subplot(132)
    title("Ux(x,y)")
    colorbar(min(Ux), max(Ux), cmm)
    Sgrayplot(X, Y, Ux', colminmax=cmm)
    xlabel("x")
    ylabel("y")

    subplot(133)
    title("Uy(x,y)")
    colorbar(min(Uy), max(Uy), cmm)
    Sgrayplot(X, Y, Uy', colminmax=cmm)
    xlabel("x")
    ylabel("y")

    figname = sprintf("ite_%04d.png", iteration)
    xs2png(fig, figname)
endfunction

function f = champ(t, coords)
   x = Ux(coords(1), coords(2))
   y = Uy(coords(1), coords(2))
   f = [x, y]
endfunction

// Plot isocontours (only at t=0.80 and t=1.20)
function plot_isocontours(W, figname)
    if (t~=0.80) & (t~=1.20) then
        return
    end

    fig = scf(1)
    clf()

    // TODO: display the isocontours
    contourf(Y, X, W, -70:10:70)

    fig2 = scf(2)
    fchamp(champ, t, dx*(0:Nx-1), dy*(0:Ny-1))
    figname = sprintf("fchamp_%f.png", t)
    xs2png(fig2, figname)

    figname = sprintf("isocontours_%f.png", t)
    xs2png(fig, figname)
endfunction


// Load the Poisson solver and the advection-diffusion solver
dir  = get_absolute_file_path("simu.sce")
file = dir+"poisson/poisson.sce"
exec(file, -1)
file = dir+"diff/dif-conv-f.sce"
exec(file, -1)

// Figure setup (fig0 = fields, fig1 = isocontours)
figure(0, "position", [0,0,1400,400])
figure(1, "position", [0,0,800,800])

// Initialize vorticity and loop untill final time using adaptive timestep
t = 0.0
ite = 0
W = feval(Y, X, init_vorticity)
while t<T
    // TODO: compute velocity from vorticity
    [Ux, Uy] = poisson_curl_2d(W, Nx, Ny, Lx, Ly)
    Ux = real(Ux)
    Uy = real(Uy)

    // TODO: compute new timestep from stability criteria
    dt = min([calcul_dt(Ux, dx), calcul_dt(Uy, dy)])
    if (t<0.80) & (t+dt>0.80) then
        dt = 0.80-t
    elseif (t<1.20) & (t+dt>1.20) then
        dt = 1.20-t
    elseif (t+dt>T) then
        dt = T-t
    end

    printf("\niteration %i, from t=%f to t=%f", ite, t, t+dt)
    plot_fields(W,Ux,Uy,ite)
    plot_isocontours(W,t)

    // TODO: advection-diffusion on vorticity
    W = solveur_2D(W, Ux, Uy, Nx, Ny, nu, dt, dx, dy)
    // TODO: update t and ite
    t = t + dt
    ite = ite + 1
end
plot_fields(W,Ux,Uy,ite)
plot_isocontours(W,t)

printf("\nDone in %i iterations!\n", ite)
exit(0)

fiig = scf(2);
t = 0.8
fchamp()
figname = sprintf("fchamp_%f.png", t)
xs2png(fig, figname)
//400 itérations Q.13
//126 itérations Q.14
