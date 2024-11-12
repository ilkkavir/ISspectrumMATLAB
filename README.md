# ISspectrumMATLAB
This MATLAB package for calculating incoherent scatter spectra was
extracted from the [GUISDAP](https://gitlab.com/eiscat/guisdap9) incoherent scatter analysis software by Markku Lehtinen and Asko Huuskonen. 

The spectrum calculation is summarized by [Vallinkoski, 1989](https://eiscat.se/wp-content/uploads/2016/06/Error-Analysis-of-Incoherent-Scatter-Radar-Measurements.pdf) and GUISDAP is introduced by [Lehtinen and Huuskonen, 1996](https://doi.org/10.1016/0021-9169(95)00047-X).


####### installation ###########

Extract the files in the package ISspectrum_MATLAB to a directory and add it to your matlab
search path using the addpath command. For example, if the zip contects were extracted to your home
directory, use the command
>> addpath ~/ISspectrum_MATLAB


####### ISspectrum #############

The function ISspectrum is a graphical user interface for the spectrum calculation routines.
Start the program by typing the command
> ISspectrum

in the matlab command prompt. Use the command
> help ISspectrum

to get more instructions

ISspectrum uses the GUISDAP function guisdap_spec to calculate the spectra. To calculate spectra with parameters not allowed by the ISspectrum GUI, you can call the function guisdap_spec directly from the matlab command prompt. Notice that there is no graphics available, you will need to also plot the data by yourself.


########## guisdap_spec ###########

The main spectrum calculation routine is the function
guisdap_spec. User instructions are available with the standard MATLAB
help command

> help guisdap_spec


Example:

% electron density 3e11 m^-3

% electron temperature 1200 K

% electron bulk velocity 0 m/s

% electron-neutral collision frequency 0 s^-1

% ion composition 50 % 16u, 50% 30.5u

% ion temperature 1000 K

% ion bulk velocity 0 m/s

% ion-neutral collision frequency 0 s^-1

f=[-5000:5000];

elec=[3e11 1200 0 0];

ions=[.5 1000 16 0 0 ; .5 1000 30.5 0 0];

radar=[224e6 pi];

> s = guisdap_spec(f,elec,ions,radar);
> plot(f,s)




Routines for calculating the ion-neutral collision frequencies are also included, but these require the MATLAB aerospace toolbox. If you have the toolbox installed, you can use the function collisionFrequencies to calculate the ion-neutral collision frequencies.

Example:

% ion-neutral collision frequencies at 100 km altitude on 1 Jan 2017

%  21 UT at geographic latitude 70 deg and longitude 20 deg.

> out = collisionFrequencies( datetime(2017,1,1,21,0,0),70,20,100)


The output should be:
out =

  struct with fields:

    in1: 4.7480e+03
    in2: 7.6265e+03
     en: 4.5396e+04



Here out.in1 is for the molecular ions (a mixture of NO+ and O2+) and out.in2
for the O+ ions. out.en is the electron-neutral collision frequency.
