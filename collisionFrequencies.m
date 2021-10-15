function out = collisionFrequencies( time , lat , lon , heights )
%
% out = collisionFrequencies( time , lat , lon , heights )
%
% calculate ion-neutral and electron-neutral collision frequencies
% using MSIS model atmosphere using formulas of Shunck and Nagy (2009)
% and assuming Tn=Te.
%
% INPUT:
%  time      time as matlab datetime
%  lat       latitude (degrees)
%  lon       longitude (degrees)
%  heights   heights (km)
%
% OUTPUT:
%
%  out, a matlab struct with elements:
%
%  in1   ion-neutral collision frequency for the molecular ions
%        (NO+ and O2+)
%  in2   ion-neutral collision frequency for O+ ions
%  en    electron-neutral collision frequency
%
% IV 2018
%

% the MSIS data
msispar = MSISparams( time , lat , lon , heights );

% 30.5 u ions (75% NO+ and 25% O2+) 
out.in1 = .75 * (4.34e-16 * msispar.nN2 + 4.27e-16 * msispar.nO2 + 2.44e-16 * msispar.nO ) ...
          + .25 * ( 4.13e-16 * msispar.nN2 + 2.31e-16 * msispar.nO ...
                    + 2.59e-17 * msispar.nO2 .* sqrt(msispar.Tn) .* ( 1 - 0.073.*log10(msispar.Tn)).^2);

% O+ ions
out.in2 = 6.82e-16 * msispar.nN2 + 6.66e-16 * msispar.nO2 ...
          + .367e-17 * msispar.nO .* sqrt(msispar.Tn) .* ( 1 - 0.064.* log10(msispar.Tn)).^2;   

% electrons
out.en = 2.33e-17 * msispar.nN2 .* ( 1 - 1.21e-4 .* msispar.Tn ) .* msispar.Tn ...
         + 1.82e-16 .* msispar.nO2 .* ( 1 + 3.6e-2 .* sqrt(msispar.Tn)) .* sqrt(msispar.Tn) ...
         + 8.9e-17 * msispar.nO .* ( 1 + 5.7e-4 .* msispar.Tn ) .* sqrt(msispar.Tn);
end

