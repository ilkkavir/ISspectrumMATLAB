function msispar = MSISparams(  time  , lat , lon , heights  )
%
% msispar = MSISparams(  time  , lat , lon , heights  )
%
% MSIS model parameters with the MATLAB Aerospace nrlmsise00.
% The model needs the apf107.dat file that can be downloaded from
% https://chain-new.chain-project.net/echaim_downloads/apf107.dat
%
% INPUT
%   time     time as MATLAB datetime
%   lat      latitude (deg)
%   lon      longitude (deg)
%   heights  heights in km
%
%
% OUTPUT:
%
% msispar, a list with elements
%
%  Tn    neutral temperature
%  nO    O number density
%  nO2   O2 number density
%  nN    N  number density
%  nN2   N2 number density
%  nAr   Ar number density
%  nH    H  number density
%  nHe   He number density
%  lat   latitude (deg)
%  lon   longitude (deg)
%  time  timestamp as matlab datetime
%  h     height (km)
%
% the last four are copied from the input
%
% IV 2017, 2018
%
% Copyright I Virtanen <ilkka.i.virtanen@oulu.fi>
% This is free software, licensed under GNU GPL version 2 or later

persistent apf107table


% first read the ap-indices and f017 values from file apf107.dat
% the table apf107table is a persistent variable, so it is enough
% to read the original file once.
%
% file format:
%
%  year(I3), month(I3), day(I3), 3-hour Ap indices for the UT
%  intervals (0-3), )3-6), )6-9), .., )18-21), )21-24(  in an array
%  of dimension 8 (8I3), daily Ap (I3), -11(I3),
%  F10.7 radio flux for the day (F5.1), 81-day average of F10.7
%  radio flux (F5.1), 365-day average of F10.7 centered on the date
%  of interest (F5.1). At start and end of the index file the
%  81-day and 365-day averages are calculated taking only the
%  available indices, e.g. for the first date the 81-day average is
%  only over 40 F10.7 values and over 41 values on the 2nd date.

if isempty(apf107table)
    apfline = 1;
    apf107fid = fopen('apf107.dat');
    while ~feof(apf107fid)
        apf107table(apfline,:)=sscanf(fgetl(apf107fid), '%3d%3d%3d%3d%3d%3d%3d%3d%3d%3d%3d%3d%3d%5f%5f%5f');
        apfline = apfline+1;
    end
    fclose(apf107fid);
end

% the two-digit year number use in the apf107 file...
ynum = mod( time.Year , 1000 );

% day-of-year
dayofyear = day( time , 'dayofyear' );

% second-of-day
secofday = ( (time.Hour*60) + time.Minute*60) + time.Second;

% the correct line from apf107table
apf107line = find( apf107table(:,1)==ynum & apf107table(:,2)== ...
                   time.Month & apf107table(:,3)==time.Day);

if ~isempty(apf107line)
% pick the f10.7 values
f107 = apf107table(apf107line,14);
f107a = apf107table(apf107line,15);

% daily ap
ap = apf107table(apf107line,12);

% pick the relevant part of the 3-hour ap indices
ap3 = apf107table(apf107line-3:apf107line,4:11)'; % everything we
                                                  % might need
ap3 = ap3(:); % convert into a vector (note the "'" in previous line)
ap3 = ap3(1:(end-(8-ceil(time.Hour/3)))); % remove extra from
                                                % the end
ap3 = ap3( end-19 : end); % remove extra from the beginning

% then form the aph input for atmosnrlmsise00
aph = [ap,ap3(end),ap3(end-1),ap3(end-2),ap3(end-3),mean(ap3(end-4: ...
                                                  end-11)),mean(ap3(end-12:end-19))];

[Tmsis,rhomsis] = atmosnrlmsise00( heights*1000,69.58646 , 19.22743, ...
                                   time.Year, dayofyear, secofday, f107a, f107,aph);

else
[Tmsis,rhomsis] = atmosnrlmsise00( heights*1000,69.58646 , 19.22743, ...
                                   time.Year, dayofyear, secofday);
end

msispar.nHe = rhomsis(:,1);
msispar.nO = rhomsis(:,2);
msispar.nN2 = rhomsis(:,3);
msispar.nO2 = rhomsis(:,4);
msispar.nAr = rhomsis(:,5);
msispar.nH = rhomsis(:,7);
msispar.nN = rhomsis(:,8);
msispar.Tn = Tmsis(:,2);
msispar.h = heights;
msispar.lat = lat;
msispar.lon = lon;
msispar.time = time;

end