Nx=200;
Nt=200;
kappa = [0.0001, 0.001, 0.01]
exec("my_cholesky.sce")

function y=phi_0(x)
   [s, v] = size(x)
   y = zeros(s,1)
   for i = 1:s
      if (x(i) >= 0) & (x(i) < 0.25) then
         y(i) = 0
      elseif (x(i) >= 0.25) & (x(i) < 0.375) then
         y(i) = 2*(x(i) - 0.25)
      elseif (x(i) >= 0.375) & (x(i) < 0.5) then
         y(i) = 2*(0.5 - x(i))
      elseif (x(i) >= 0.5) & (x(i) <= 1) then
         y(i) = 0
      end
   end
endfunction

function y=conv(x)
   y = 0.4*(x - 0.25)
endfunction

dx = 1/Nx
dt = 1/Nt
phi_i = phi_0((0:dx:((Nx-1)*dx))')
M = zeros(Nx)

for i = 1:Nx-1
   M(i, i+1) = -conv((i-1)*dx)*(dt/(2*dx)) + (conv((i-1)*dx).^2)*(dt.^2/(2*(dx.^2)))
   M(i, i) = 1 - 2*(conv((i-1)*dx).^2)*((dt.^2)/(2*(dx.^2)))
   M(i+1, i) = conv((i-1)*dx)*(dt/(2*dx)) + (conv((i-1)*dx).^2)*(dt.^2/(2*(dx.^2)))
end

M(1, Nx) = conv((0)*dx)*(dt/(2*dx)) + (conv((0)*dx).^2)*(dt.^2/(2*(dx.^2)))
M(Nx, 1) = -conv((Nx-1)*dx)*(dt/(2*dx)) + (conv((Nx-1)*dx).^2)*(dt.^2/(2*(dx.^2)))
M(Nx, Nx) = 1 - 2*(conv((Nx-1)*dx).^2)*((dt.^2)/(2*(dx.^2)))


for k = 1:3
   N = zeros(Nt)
   for i = 1:Nx-1
      N(i, i+1) = -kappa(k)*(dt/(dx.^2))
      N(i+1, i) = -kappa(k)*(dt/(dx.^2))
      N(i, i) = 1 + 2*kappa(k)*(dt/(dx.^2))
   end

   N(1, Nx) = -kappa(k)*(dt/(dx.^2))
   N(Nx, 1) = -kappa(k)*(dt/(dx.^2))
   N(Nx, Nx) = 1 + 2*kappa(k)*(dt/(dx.^2))

   fin=Nt;

   phi = phi_i
   for i=1:fin
       phi=my_cholesky(N,M*phi);
   end
   scf;
   plot(0:dx:((Nx-1)*dx), [phi_i phi]);
end
