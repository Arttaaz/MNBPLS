
// returns only T
function [T]=cholesky_fact(A)
   [m,n] = size(A)
   if (m~=n) then
     print(%io(2), "error, not a square matrix");
   else
      T = zeros(n);
      T(1,1) = sqrt(A(1,1));

      for j = 2:n
         T(j, 1) = A(1, j)/T(1, 1);
      end

      for i = 2:n
         T(i, i) = sqrt( A(i, i) - sum( T(i,1:i-1).^2 ) );
         for j = i+1:n
            T(j, i) = (A(i, j) - sum( T(i,1:i-1).*T(j,1:i-1) )) / T(i, i);
         end
      end
   end
endfunction

//A = T*transpose(T)
function [y]=up_sweep_cholesky(A,x)
  [m,n]=size(A);
  if (m~=n) then
    print(%io(2), "error, not a square matrix");
  else
     U = cholesky_fact(A)'
     y = zeros(n,1)

     y(n) = x(n) / U(n,n)               //init
     for i = (n-1):-1:1                 //from n-1 to 1
        y(i) = (x(i) - sum(U(i,(i+1):n)*y((i+1):n)))/U(i,i)
     end
  end
endfunction

function [y]=down_sweep_cholesky(A,x)
  [m,n]=size(A);
  if (m~=n) then
    print(%io(2), "error, not a square matrix");
  else
     L = cholesky_fact(A)
     y = zeros(n,1)

     y(1) = x(1) / L(1,1)               //init
     for i = 2:n                 //from 1 to n-1
        y(i) = (x(i) - sum(L(i,1:(i-1))*y(1:(i-1))))/L(i,i)
     end
  end
endfunction

function [U]=my_cholesky(N,S)
   Y = down_sweep_cholesky(N,S)
   U = up_sweep_cholesky(N,Y)
endfunction
