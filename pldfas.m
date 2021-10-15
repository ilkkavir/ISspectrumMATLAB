% pldfas.m : asymptotic formula for the plasma dispersion function
% GUISDAP v.1.60 96-05-27 Copyright Asko Huuskonen and Markku Lehtinen
%
% n is the order of the expansion
%
% res=pldfas(z,n)
%
  function res=pldfas(z,n)  
%
  if max(size(z))==0, res=[]; return, end 
  term=1;
  res=1;
  for i=1:n 
    term=term*(2*i-1)./(2*z.^2);
    res=res+term;
  end 
  res=res./z;
