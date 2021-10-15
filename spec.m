% spec.m: Incoherent scatter spectrum calculation
% GUISDAP v.1.80 02-01-27 Copyright EISCAT, Huuskonen&Lehtinen
%
% See also: dirthe, transf
%
% function s=spec(nin0,tit0,mim0,psi,vi,kd2,om,pldfvv);
function s=spec(nin0,tit0,mim0,psi,vi,kd2,om,pldfvv);

  j=sqrt(-1);
  npar=length(mim0); nion=npar-1;
  nom=length(om);
  oma=zeros(length(om),npar);
  gam=sqrt(mim0./tit0);
  for i=1:nion+1,
    oma(:,i)=(om-vi(i))*gam(i);
    ua(:,i)=oma(:,i)-j*psi(i)/sqrt(tit0(i));
  end;
  ua=pldfi(ua);
  for i=1:nion+1,
    ua(:,i)=ua(:,i)./(j-(psi(i)/sqrt(tit0(i))*ua(:,i)));
    ya(:,i)=j+oma(:,i).*ua(:,i);
  end;
  s=(abs(ya(:,npar)*(nin0(npar)/tit0(npar))).^2).*...
                 (real(ua(:,1:nion))*...
                 (gam(1:nion).*nin0(1:nion))' );
  s=s+(abs(j*kd2+ya(:,1:nion)*(nin0(1:nion)./tit0(1:nion))').^2).*...
                  real(ua(:,npar)*...
                  (gam(npar)*nin0(npar)) );
  s=(s./(abs(j*kd2+(ya*(nin0./tit0)')).^2))/pi;
