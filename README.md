# ISspectrumMATLAB
This MATLAB package for for calculating incoherent scatter spectra was
extracted from the GUISDAP incoherent scatter analysis software.

####### installation ###########

Extract the files in the package ISspectrum_2020 to a directory and add it to your matlab
search path using the addpath command. For example, if the zip contects were extracted to your home
directory, use the command
>> addpath ~/ISspectrum_2020


####### ISspectrum #############
The function ISspectrum is a graphical user interface for the spectrum calculation routines.
Start the program by typing the command
>> ISspectrum
in the matlab command prompt. Use the command
>> help ISspectrum
to get more instructions

ISspectrum uses the GUISDAP function guisdap_spec to calculate the spectra. To calculate spectra
with parameters not allowed by the ISspectrum GUI, you can call the function guisdap_spec directly
from the matlab command prompt. Notice that there is no graphics available, you will need to also
plot the data by yourself.


########## guisdap_spec ###########

The main spectrum calculation routine is the function
guisdap_spec. User instructions are available with the standard MATLAB
help command:

>> help guisdap_spec


Example:
%
% electron density 3e11 m^-3
% electron temperature 1200 K
% electron bulk velocity 0 m/s
% electron-neutral collision frequency 0 s^-1
%
% ion composition 50 % 16u, 50% 30.5u
% ion temperature 1000 K
% ion bulk velocity 0 m/s
% ion-neutral collision frequency 0 s^-1
%
%
f=[-5000:5000];
elec=[3e11 1200 0 0];
