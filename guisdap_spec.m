function s=guisdap_spec(f,el,io,ra)
% s=guisdap_spec(f,elec,ions,radar)
% Input: f frequency array					[-2000:2000]*10
%	elec array [N Temp vel coll]				[3e11 2000 0 0]
%	ions matrix [p Temp mass coll vel; ... ] (<4 ions)	[1 1000 16 0 0]
%	radar array [freq scatter_angle]			[930e6 pi]
% 	SI units (m-3,K,Hz,ms-1,...) except for ion mass (amu)
% Output: IS spectral components (m-3s)
global p_N0 p_T0 p_om0 k_radar0 pldfvv
elec=[3e11 2000 0 0];
ions=[1 1000 16 0 0;0 1000 30.5 0 0;0 1000 1 0 0];
radar=[930e6 pi];
if nargin>3 & ~isempty(ra), radar(1:length(ra))=ra; end
if nargin>2 & ~isempty(io), ions(1:size(io,1),1:size(io,2))=io; end
if nargin>1 & ~isempty(el), elec(1:length(el))=el; end
if nargin==0, f=[]; end
if isempty(f), f=[-2000:2000]*10; end

ch_fradar=radar(1);
p_T0=elec(2); p_N0=elec(1); p_m0=ions(1,3);
if isempty(pldfvv), load('pldfvv.mat'), end%spektri_init, end
nat_const
constants
scat_fac=sin(radar(2)/2);
k_radar=k_radar0*scat_fac;
kd2=k_radar^2*p_D0^2;
p_om=2*pi*f/(p_om0*scat_fac);

p=[ions;[1 elec(2) v_electronmass/v_amu elec(4) elec(3)]];
p=real_to_scaled(p)';

nin0=p(1,:)*elec(1); tit0=p(2,:); mim0=p(3,:)/p_m0;
psi=p(4,:)./sqrt(tit0./mim0)/scat_fac; vi=-p(5,:);

s=spec(nin0,tit0,mim0,psi,vi,kd2,p_om,pldfvv);
s=s*sqrt((p_m0/30.5)*(300/p_T0))*(p_N0/1e11);
s=s/k_radar*v_lightspeed*5.1823;

end

