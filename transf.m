% transf.m : transforms user parameters to spectrum parameters
% GUISDAP v.1.80 2002-01-27 Copyright EISCAT, Huuskonen&Lehtinen
%
% Parameters:
% p: plasma parameters in scaled units
% [nin0,tit0,mim0,psi,vi] : general spectrum parameters
%
% See also: spec, dirthe, real_to_scaled
%
% [nin0,tit0,mim0,psi,vi]=transf(p,p_m0)
%
function [nin0,tit0,mim0,psi,vi]=transf(p,p_m0)

nion=length(p_m0); nspec=nion+1;
% N/N0
nin0(nspec)=p(1);
nin0(2:nion)=p(1)*p(6:(4+nion));
nin0(1)=p(1)-sum(nin0(2:nion));
% T/T0
tit0(nspec)=p(2)*p(3);
tit0(1:nion)=p(2);
% m/m0
m0=p_m0(1);
me=9.1093897e-31/1.6605402e-27;	
mim0(nspec)=me/m0;
mim0(1:nion)=p_m0/m0;
% v/v0 v0=phase velocity om0/kscatt
vi(1:nspec)=p(5);
% psi
psi0=p(4);                   % psi0
psi(nspec)=psi0*0.35714;     % psie independently of Te/Ti
psi(1:nion)=psi0;            % psi2=psi1 for all temperatures
