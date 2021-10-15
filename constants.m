% constants.m: script defining useful radar constants
% GUISDAP v.1.60 96-05-27 Copyright Asko Huuskonen and Markku Lehtinen
%
% See also: nat_const

k_radar0=2*pi*2*ch_fradar/v_lightspeed;
p_D0=sqrt(v_epsilon0*v_Boltzmann*p_T0/(p_N0*v_elemcharge^2));
p_om0=k_radar0*sqrt(2*v_Boltzmann*p_T0/(p_m0(1)*v_amu));
