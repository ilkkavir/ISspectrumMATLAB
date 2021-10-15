% pldfi.m : Plasma dispersion function interpolation
% GUISDAP v.1.60 96-05-27 Copyright Asko Huuskonen and Markku Lehtinen
%
%
% res=pldfi(z)
%
  function res=pldfi(z)
% 
global pldfv path_GUP

if length(pldfv)==0,
   load('pldfv.mat')
%  load(canon(fullfile(path_GUP,'matfiles','pldfv')));
end

  accur=4;
  res=z;
  z=z(:);
  f1=find( abs(real(z)) >=3.9 | imag(z) <= -3.5 );
  f2=find( abs(real(z)) < 3.9 & imag(z) > -3.5 & imag(z) <0.0375 );
  f3=find( imag(z) >= 0.0375);
  if length(f1)>0, z(f1)=pldfas(z(f1),accur+2); end
  if length(f3)>0, fprintf('calculating pldf\n'),z(f3)=pldf(z(f3)); end
%
  if length(f2) >0,
    x=abs(real(z(f2)))/0.075+4;
    f1=find(real(z(f2)) < 0);
    y=-imag(z(f2))/0.075;
    p=x-floor(x)-sqrt(-1)*(y-round(y));
    x=floor(x)+61*round(y);         % index for linear pldfv table lookup
    if accur==4
      y=(p-1).*(p-2).*( (-p/3).*pldfv(x-1) + (p+1).*pldfv(x) );
      y=(y+p.*(p+1).*( (2-p).*pldfv(x+1) + ((p-1)/3).*pldfv(x+2)) )*.5;
    elseif accur==6
      p(find(abs(p-round(p))<=1e-99))=p(find(abs(p-round(p))<=1e-99))+2e-99;
      y=(pldfv(x+3)./(p-3)-pldfv(x-2)./(p+2))/10+pldfv(x+1)./(p-1);
      y=y+(pldfv(x-1)./(p+1)-pldfv(x+2)./(p-2))/2-pldfv(x)./p;
      y=y.*(p-3).*(p-2).*(p-1).*p.*(p+1).*(p+2)/12;
    end
    y(f1) = -conj( y(f1) );
    z(f2)=y;
  end                                % if length(f2) >0
  res(:)=z;
