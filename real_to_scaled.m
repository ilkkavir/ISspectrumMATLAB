% real_to_scaled: calculates the scaled variable values from physical ones 
% GUISDAP v.1.60 96-05-27 Copyright Asko Huuskonen and Markku Lehtinen
%
% Parameters:
% physical: plasma parameters in physical units
% scaled: plasma parameters in scaled units
% See also: scaled_to_real
%function scaled=real_to_scaled(physical)
function scaled=real_to_scaled(physical)

global p_N0 p_m0 p_T0 p_om0 k_radar0

scaled=physical; % affects element 3 and also 6 (if specified on input)
scaled(:,1)=physical(:,1)/p_N0;
scaled(:,2)=physical(:,2)/p_T0;
ch=1;   % hyi hyi
scaled(:,4)=physical(:,4)/(p_om0(ch));
scaled(:,5)=physical(:,5)/(p_om0(ch)/k_radar0(ch));
