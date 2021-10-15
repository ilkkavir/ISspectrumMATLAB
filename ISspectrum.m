function [] = ISspectrum()
%
% ISspectrum()
%
% Incoherent scatter spectrum plotting GUI. The spectra are calculated with GUISDAP routines
% under assumptions typically used in incoherent scatter data analysis:
% - there are two ion species: molecular ion (mass 30.5 u) and atomix oxygen ion (16 u)
% - both ion species are in the same temperature
% - both ion species have the same ion-neutral collision frequnecy (in practice, non-zero collision
%   frequencies are reasonable only when there are only molecular ions
% - both ion species and electrons move with the same bulk velocity
%
% For more general spectrum calculation with more ion species and temperature, velocity, and collision
% frequency defined separately for each ion species and electrons, see the matlab function guisdap_spec. 
%
% Values of the plasma parameters, the frequnecy axis, and the radar carrier frequency can be
% adjusted either by using the sliders or by typing the values in the boxes. If you put too large or too small
% value in the box the slider will disappear. This is because the programmer was lazy. The slider will come
% back if a reasonable value is entered in the box. 
%
% The "Differential radar cross section" in the vertical axis is radar cross-section per unit volume per
% unit frequency. The unit is thus m^2 m^-3 (Hz)^-1 = m^-1 s
%
% The sigma_r written in the plot is integral of the differential radar cross section over the frequency axis,
% i.e. radar cross-section per unit volume, and its unit is m^2/m^-3 = m^-1. 
%
%
%
% IV 2020
%
    global v_electronradius


    Ne0 = 1e11;
    Te0 = 1000;
    Ti0 = 1000;
    Vi0 = 0;
    Coll0 = 2;
    Op0 = 1;
    fr0 = 930e6;
    fMax0 = 30000;

    nat_const;
    
    f = [-fMax0:10:fMax0];
    elec = [Ne0 Te0 Vi0 Coll0*0.35714];
    ions = [Op0 Ti0 16 Coll0 Vi0;
            1-Op0  Ti0 30.5 Coll0 Vi0];
    radar = [930e6 pi];
    
    params = speccalcclass({f,elec,ions,radar,[]});


    % screen size
    set(0,'units','pixels');
    scdims = get(0,'screensize');

    sch = scdims(4);
    scw = scdims(3);
    
    % dimensions
    figx = 1;
    figy = 1;
    figw = 600;
    figh = 880;
    hscale = 1;
    if sch <  figh*.9
        hscale = sch/figh*.9;
    end
    wscale = 1;
    if scw < figw*.9
        wscale = scw/figw*.9;
    end
    figh = figh*hscale;
    figw = figw*wscale;
    plotx = 60*wscale;
    ploty = 380*hscale;
    plotw = 500*wscale;
    ploth = 460*hscale;
    % uicontrols
    strW = 70*wscale;
    eboxX = 100*wscale;
    eboxW = 70*wscale;    
    slX = 180*wscale;
    slW = plotx + plotw - slX;
    slh = 30*hscale;
    dsly = 10*hscale;
    boxx = 20*wscale;


    % Plot different plots according to slider location.
    S.fh = figure('units','pixels',...
                  'position',[figx figy figw figh],...
                  'menubar','none',...
                  'name','IS spectrum',...
                  'numbertitle','off',...
                  'resize','off');    
    S.x = f/1000;  % For plotting.
    S.y = 4*pi*v_electronradius^2*guisdap_spec(params.value{1},params.value{2},params.value{3},params.value{4});
    S.ax = axes('unit','pix','position',[plotx ploty plotw ploth]);
    S.LN = plot(S.x,S.y,'r');
    S.str = text(.95*max(f)/1000,.95*max(S.y),['\sigma_r = ' num2str(sum(S.y)*10,'%0.2e') 'm^{-1}'],'horizontalalignment','right','fontsize',12);
    xlabel(S.ax,'Frequency [kHz]')
    ylabel(S.ax,'Differental radar cross-section [m^{-1}s]')

    
    grid on

    % Ne
    slNe = uicontrol('style','slide',...
                     'unit','pix',...
                     'position',[slX dsly slW slh],...
                     'min',1,'max',5e12,'val',Ne0,...
                     'sliderstep',[1e10 1e10]/5e12);
    boxNe = uicontrol('style','edit',...
                      'unit','pix',...
                      'position',[eboxX dsly eboxW slh],...
                      'string',num2str(Ne0,'%.1e'),...
                      'callback',{@box_call_Ne,S,params,slNe});
    set(slNe,'callback',{@sl_call_Ne,S,params,boxNe});
    strNe = uicontrol('style','text',...
                      'unit','pix',...
                      'position',[boxx dsly strW slh],...
                      'string','Ne [1/m3]');

    % Te
    slTe = uicontrol('style','slide',...
                     'unit','pix',...
                     'position',[slX 2*dsly+slh slW slh],...
                     'min',1,'max',10000,'val',Te0,...
                     'sliderstep',[100 1000]/10000);
    boxTe = uicontrol('style','edit',...
                      'unit','pix',...
                      'position',[eboxX 2*dsly+slh eboxW slh],...
                      'string',num2str(Te0,'%.0f'),...
                      'callback',{@box_call_Te,S,params,slTe});
    set(slTe,'callback',{@sl_call_Te,S,params,boxTe});
    strTe = uicontrol('style','text',...
                      'unit','pix',...
                      'position',[boxx 2*dsly+slh strW slh],...
                      'string','Te [K]');

    % Ti
    slTi = uicontrol('style','slide',...
                     'unit','pix',...
                     'position',[slX 3*dsly+2*slh slW slh],...
                     'min',1,'max',10000,'val',Ti0,...
                     'sliderstep',[100 1000]/10000);
    boxTi = uicontrol('style','edit',...
                      'unit','pix',...
                      'position',[eboxX 3*dsly+2*slh eboxW slh],...
                      'string',num2str(Ti0,'%.0f'),...
                      'callback',{@box_call_Ti,S,params,slTi});
    set(slTi,'callback',{@sl_call_Ti,S,params,boxTi});
    strTi = uicontrol('style','text',...
                      'unit','pix',...
                      'position',[boxx 3*dsly+2*slh strW slh],...
                      'string','Ti [K]');

    % Vi
    slVi = uicontrol('style','slide',...
                     'unit','pix',...
                     'position',[slX 4*dsly+3*slh slW slh],...
                     'min',-4000,'max',4000,'val',Vi0,...
                     'sliderstep',[10 100]/2000);
    boxVi = uicontrol('style','edit',...
                      'unit','pix',...
                      'position',[eboxX 4*dsly+3*slh eboxW slh],...
                      'string',num2str(Vi0,'%.0f'),...
                      'callback',{@box_call_Vi,S,params,slVi});
    set(slVi,'callback',{@sl_call_Vi,S,params,boxVi});
    strVi = uicontrol('style','text',...
                      'unit','pix',...
                      'position',[boxx 4*dsly+3*slh strW slh],...
                      'string','Vi [m/s]');

    % Coll
    slColl = uicontrol('style','slide',...
                       'unit','pix',...
                       'position',[slX 5*dsly+4*slh slW slh],...
                       'min',1,'max',1e5,'val',Coll0,...
                       'sliderstep',[1e2 1e2]/1e5);
    boxColl = uicontrol('style','edit',...
                        'unit','pix',...
                        'position',[eboxX 5*dsly+4*slh eboxW slh],...
                        'string',num2str(Vi0,'%.1e'),...
                        'callback',{@box_call_Coll,S,params,slColl});
    set(slColl,'callback',{@sl_call_Coll,S,params,boxColl});
    strColl = uicontrol('style','text',...
                        'unit','pix',...
                        'position',[boxx 5*dsly+4*slh strW slh],...
                        'string','Coll [1/s]');
    
    % composition
    slOp = uicontrol('style','slide',...
                     'unit','pix',...
                     'position',[slX 6*dsly+5*slh slW slh],...
                     'min',0,'max',1,'val',Op0,...
                     'sliderstep',[.01 .01]);
    boxOp = uicontrol('style','edit',...
                      'unit','pix',...
                      'position',[eboxX 6*dsly+5*slh eboxW slh],...
                      'string',num2str(Op0,'%.2f'),...
                      'callback',{@box_call_Op,S,params,slOp});
    set(slOp,'callback',{@sl_call_Op,S,params,boxOp});
    strOp = uicontrol('style','text',...
                      'unit','pix',...
                      'position',[boxx 6*dsly+5*slh strW slh],...
                      'string','[O+]');
    
    % radar frequency
    slfr = uicontrol('style','slide',...
                     'unit','pix',...
                     'position',[slX 7*dsly+6*slh slW slh],...
                     'min',1e7,'max',2e9,'val',fr0,...
                     'sliderstep',[1e7 1e7]/2e9);
    boxfr = uicontrol('style','edit',...
                      'unit','pix',...
                      'position',[eboxX 7*dsly+6*slh eboxW slh],...
                      'string',num2str(fr0,'%.2e'),...
                      'callback',{@box_call_fr,S,params,slfr});
    set(slfr,'callback',{@sl_call_fr,S,params,boxfr});
    strfr = uicontrol('style','text',...
                      'unit','pix',...
                      'position',[boxx 7*dsly+6*slh strW slh],...
                      'string','f0 [Hz]');
    
    % maximum frequency
    slfMax = uicontrol('style','slide',...
                       'unit','pix',...
                       'position',[slX 8*dsly+7*slh slW slh],...
                       'min',0,'max',1e5,'val',fMax0,...
                       'sliderstep',[1e3 1e3]/1e5);
    boxfMax = uicontrol('style','edit',...
                        'unit','pix',...
                        'position',[eboxX 8*dsly+7*slh eboxW slh],...
                        'string',num2str(fMax0,'%.2e'),...
                        'callback',{@box_call_fMax,S,params,slfMax});
    set(slfMax,'callback',{@sl_call_fMax,S,params,boxfMax});
    strfMax = uicontrol('style','text',...
                        'unit','pix',...
                        'position',[boxx 8*dsly+7*slh strW slh],...
                        'string','fmax [Hz]');


    % a button to freeze the current spectrum in the plot
    btnfreeze = uicontrol('style','pushbutton','unit','pix',...
                          'position',[slX+slW-60,9*dsly+8*slh,60,slh],...
                          'string','freeze',...
                          'callback',{@btn_call_freeze,S,params});
    % a button to clear the frozen curves
    btnclear = uicontrol('style','pushbutton','unit','pix',...
                          'position',[slX+slW-130,9*dsly+8*slh,60,slh],...
                          'string','clear',...
                          'callback',{@btn_call_clear,S,params});

end

function [] = sl_call_Ne(h, event, S , params , boxNe)
    global v_electronradius
    f = params.value{1};
    elec = params.value{2};
    ions = params.value{3};
    radar = params.value{4};
    elec(1) = get(h,'value');
    params.value = {f,elec,ions,radar,params.value{5}};
    S.y = 4*pi*v_electronradius^2*guisdap_spec(params.value{1},params.value{2},params.value{3},params.value{4});
    set(S.LN,'ydata',S.y)
    set(S.LN,'xdata',f/1000)

    set(boxNe,'string',num2str(get(h,'value'),'%.1e'))
    set(S.str,'string',['\sigma_r = ' num2str(sum(S.y)*10,'%0.2e') 'm^{-1}'],'position',[.95*max(f)/1000,.95*max(S.y)])
    
end

function [] = box_call_Ne(h, event, S , params , slNe )
    global v_electronradius
    f = params.value{1};
    elec = params.value{2};
    ions = params.value{3};
    radar = params.value{4};
    elec(1) = str2num(get(h,'string'));
    params.value = {f,elec,ions,radar,params.value{5}};
    S.y = 4*pi*v_electronradius^2*guisdap_spec(params.value{1},params.value{2},params.value{3},params.value{4});
    set(S.LN,'ydata',S.y)
    set(S.LN,'xdata',f/1000)

    set(slNe,'val',str2num(get(h,'string')));
    set(S.str,'string',['\sigma_r = ' num2str(sum(S.y)*10,'%0.2e') 'm^{-1}'],'position',[.95*max(f)/1000,.95*max(S.y)])
end

function [] = sl_call_Te(h, event, S , params , boxTe )
    global v_electronradius
    f = params.value{1};
    elec = params.value{2};
    ions = params.value{3};
    radar = params.value{4};
    elec(2) = get(h,'value');
    params.value = {f,elec,ions,radar,params.value{5}};
    S.y = 4*pi*v_electronradius^2*guisdap_spec(params.value{1},params.value{2},params.value{3},params.value{4});
    set(S.LN,'ydata',S.y)
    set(S.LN,'xdata',f/1000)

    set(boxTe,'string',num2str(get(h,'value'),'%.0f'))
    set(S.str,'string',['\sigma_r = ' num2str(sum(S.y)*10,'%0.2e') 'm^{-1}'],'position',[.95*max(f)/1000,.95*max(S.y)])

end

function [] = box_call_Te(h, event, S , params , slTe )
    global v_electronradius
    f = params.value{1};
    elec = params.value{2};
    ions = params.value{3};
    radar = params.value{4};
    elec(2) = str2num(get(h,'string'));
    params.value = {f,elec,ions,radar,params.value{5}};
    S.y = 4*pi*v_electronradius^2*guisdap_spec(params.value{1},params.value{2},params.value{3},params.value{4});
    set(S.LN,'ydata',S.y)
    set(S.LN,'xdata',f/1000)

    set(slTe,'val',str2num(get(h,'string')));
    set(S.str,'string',['\sigma_r = ' num2str(sum(S.y)*10,'%0.2e') 'm^{-1}'],'position',[.95*max(f)/1000,.95*max(S.y)])
end


function [] = sl_call_Ti(h, event, S , params , boxTi )
    global v_electronradius
    f = params.value{1};
    elec = params.value{2};
    ions = params.value{3};
    radar = params.value{4};
    ions(:,2) = get(h,'value');
    params.value = {f,elec,ions,radar,params.value{5}};
    S.y = 4*pi*v_electronradius^2*guisdap_spec(params.value{1},params.value{2},params.value{3},params.value{4});
    set(S.LN,'ydata',S.y)
    set(S.LN,'xdata',f/1000)
    
    set(boxTi,'string',num2str(get(h,'value'),'%.0f'))
    set(S.str,'string',['\sigma_r = ' num2str(sum(S.y)*10,'%0.2e') 'm^{-1}'],'position',[.95*max(f)/1000,.95*max(S.y)])
end

function [] = box_call_Ti(h, event, S , params , slTi )
    global v_electronradius
    f = params.value{1};
    elec = params.value{2};
    ions = params.value{3};
    radar = params.value{4};
    ions(:,2) = str2num(get(h,'string'));
    params.value = {f,elec,ions,radar,params.value{5}};
    S.y = 4*pi*v_electronradius^2*guisdap_spec(params.value{1},params.value{2},params.value{3},params.value{4});
    set(S.LN,'ydata',S.y)
    set(S.LN,'xdata',f/1000)

    set(slTi,'val',str2num(get(h,'string')));
    set(S.str,'string',['\sigma_r = ' num2str(sum(S.y)*10,'%0.2e') 'm^{-1}'],'position',[.95*max(f)/1000,.95*max(S.y)])
end


function [] = sl_call_Vi(h, event, S , params , boxVi )
    global v_electronradius
    f = params.value{1};
    elec = params.value{2};
    ions = params.value{3};
    radar = params.value{4};
    ions(:,5) = get(h,'value');
    elec(:,3) = get(h,'value');
    params.value = {f,elec,ions,radar,params.value{5}};
    S.y = 4*pi*v_electronradius^2*guisdap_spec(params.value{1},params.value{2},params.value{3},params.value{4});
    set(S.LN,'ydata',S.y)
    set(S.LN,'xdata',f/1000)

    set(boxVi,'string',num2str(get(h,'value'),'%.0f'))
    set(S.str,'string',['\sigma_r = ' num2str(sum(S.y)*10,'%0.2e') 'm^{-1}'],'position',[.95*max(f)/1000,.95*max(S.y)])
    
end


function [] = box_call_Vi(h, event, S , params , slVi )
    global v_electronradius
    f = params.value{1};
    elec = params.value{2};
    ions = params.value{3};
    radar = params.value{4};
    ions(:,5) = str2num(get(h,'string'));
    elec(:,3) = str2num(get(h,'string'));
    params.value = {f,elec,ions,radar,params.value{5}};
    S.y = 4*pi*v_electronradius^2*guisdap_spec(params.value{1},params.value{2},params.value{3},params.value{4});
    set(S.LN,'ydata',S.y)
    set(S.LN,'xdata',f/1000)

    set(slVi,'val',str2num(get(h,'string')));
    set(S.str,'string',['\sigma_r = ' num2str(sum(S.y)*10,'%0.2e') 'm^{-1}'],'position',[.95*max(f)/1000,.95*max(S.y)])
end

function [] = sl_call_Coll(h, event, S , params , boxColl)
    global v_electronradius
    f = params.value{1};
    elec = params.value{2};
    ions = params.value{3};
    radar = params.value{4};
    ions(:,4) = get(h,'value');
    elec(:,4) = get(h,'value')*0.35714;
    params.value = {f,elec,ions,radar,params.value{5}};
    S.y = 4*pi*v_electronradius^2*guisdap_spec(params.value{1},params.value{2},params.value{3},params.value{4});
    set(S.LN,'ydata',S.y)
    set(S.LN,'xdata',f/1000)

    set(boxColl,'string',num2str(get(h,'value'),'%.1e'))
    set(S.str,'string',['\sigma_r = ' num2str(sum(S.y)*10,'%0.2e') 'm^{-1}'],'position',[.95*max(f)/1000,.95*max(S.y)])
    
end


function [] = box_call_Coll(h, event, S , params , slColl )
    global v_electronradius
    f = params.value{1};
    elec = params.value{2};
    ions = params.value{3};
    radar = params.value{4};
    ions(:,4) = str2num(get(h,'string'));
    elec(:,4) = str2num(get(h,'string'));
    params.value = {f,elec,ions,radar,params.value{5}};
    S.y = 4*pi*v_electronradius^2*guisdap_spec(params.value{1},params.value{2},params.value{3},params.value{4});
    set(S.LN,'ydata',S.y)
    set(S.LN,'xdata',f/1000)

    set(slColl,'val',str2num(get(h,'string')));
    set(S.str,'string',['\sigma_r = ' num2str(sum(S.y)*10,'%0.2e') 'm^{-1}'],'position',[.95*max(f)/1000,.95*max(S.y)])
end

function [] = sl_call_Op(h, event, S , params , boxOp )
    global v_electronradius
    f = params.value{1};
    elec = params.value{2};
    ions = params.value{3};
    radar = params.value{4};
    ions(1,1) = get(h,'value');
    ions(2,1) = 1-get(h,'value');
    params.value = {f,elec,ions,radar,params.value{5}};
    S.y = 4*pi*v_electronradius^2*guisdap_spec(params.value{1},params.value{2},params.value{3},params.value{4});
    set(S.LN,'ydata',S.y)
    set(S.LN,'xdata',f/1000)

    set(boxOp,'string',num2str(get(h,'value'),'%.2f'))
    set(S.str,'string',['\sigma_r = ' num2str(sum(S.y)*10,'%0.2e') 'm^{-1}'],'position',[.95*max(f)/1000,.95*max(S.y)])
    
end

function [] = box_call_Op(h, event, S , params , slOp )
    global v_electronradius
    f = params.value{1};
    elec = params.value{2};
    ions = params.value{3};
    radar = params.value{4};
    ions(1,1) = str2num(get(h,'string'));
    ions(2,1) = 1-str2num(get(h,'string'));
    params.value = {f,elec,ions,radar,params.value{5}};
    S.y = 4*pi*v_electronradius^2*guisdap_spec(params.value{1},params.value{2},params.value{3},params.value{4});
    set(S.LN,'ydata',S.y)
    set(S.LN,'xdata',f/1000)

    set(slOp,'val',str2num(get(h,'string')));
    set(S.str,'string',['\sigma_r = ' num2str(sum(S.y)*10,'%0.2e') 'm^{-1}'],'position',[.95*max(f)/1000,.95*max(S.y)])
end

function [] = sl_call_fr(h, event, S , params , boxfr )
    global v_electronradius
    f = params.value{1};
    elec = params.value{2};
    ions = params.value{3};
    radar = params.value{4};
    radar(1) = get(h,'value');
    params.value = {f,elec,ions,radar,params.value{5}};
    S.y = 4*pi*v_electronradius^2*guisdap_spec(params.value{1},params.value{2},params.value{3},params.value{4});
    set(S.LN,'ydata',S.y)
    set(S.LN,'xdata',f/1000)

    set(boxfr,'string',num2str(get(h,'value'),'%.2e'))
    set(S.str,'string',['\sigma_r = ' num2str(sum(S.y)*10,'%0.2e') 'm^{-1}'],'position',[.95*max(f)/1000,.95*max(S.y)])
    
end

function [] = box_call_fr(h, event, S , params , slfr )
    global v_electronradius
    f = params.value{1};
    elec = params.value{2};
    ions = params.value{3};
    radar = params.value{4};
    radar(1) = str2num(get(h,'string'));
    params.value = {f,elec,ions,radar,params.value{5}};
    S.y = 4*pi*v_electronradius^2*guisdap_spec(params.value{1},params.value{2},params.value{3},params.value{4});
    set(S.LN,'ydata',S.y)
    set(S.LN,'xdata',f/1000)

    set(slfr,'val',str2num(get(h,'string')));
    set(S.str,'string',['\sigma_r = ' num2str(sum(S.y)*10,'%0.2e') 'm^{-1}'],'position',[.95*max(f)/1000,.95*max(S.y)])
end

function [] = sl_call_fMax(h, event, S , params , boxfMax )
    global v_electronradius
    f = params.value{1};
    elec = params.value{2};
    ions = params.value{3};
    radar = params.value{4};
    fmax = get(h,'value');
    f = -fmax:10:fmax;
    params.value = {f,elec,ions,radar,params.value{5}};
    S.y = 4*pi*v_electronradius^2*guisdap_spec(params.value{1},params.value{2},params.value{3},params.value{4});
    set(S.LN,'ydata',S.y)
    set(S.LN,'xdata',f/1000)

    set(boxfMax,'string',num2str(get(h,'value'),'%.2e'))
    set(S.str,'string',['\sigma_r = ' num2str(sum(S.y)*10,'%0.2e') 'm^{-1}'],'position',[.95*max(f)/1000,.95*max(S.y)])
    
end

function [] = box_call_fMax(h, event, S , params , slfMax )
    global v_electronradius
    f = params.value{1};
    elec = params.value{2};
    ions = params.value{3};
    radar = params.value{4};
    fmax = str2num(get(h,'string'));
    f = -fmax:10:fmax;
    params.value = {f,elec,ions,radar,params.value{5}};
    S.y = 4*pi*v_electronradius^2*guisdap_spec(params.value{1},params.value{2},params.value{3},params.value{4});
    set(S.LN,'ydata',S.y)
    set(S.LN,'xdata',f/1000)

    set(slfMax,'val',str2num(get(h,'string')));
    set(S.str,'string',['\sigma_r = ' num2str(sum(S.y)*10,'%0.2e') 'm^{-1}'],'position',[.95*max(f)/1000,.95*max(S.y)])
end

function [] = btn_call_freeze( h , event , S , params )
    global v_electronradius
    f = params.value{1};
    elec = params.value{2};
    ions = params.value{3};
    radar = params.value{4};
    params.value = {f,elec,ions,radar,params.value{5}};
    S.y = 4*pi*v_electronradius^2*guisdap_spec(params.value{1},params.value{2},params.value{3},params.value{4});
    hold on
    hfrzn = plot(f/1000,S.y);
    hfrzn  = [params.value{5} hfrzn];
    params.value = {f,elec,ions,radar,hfrzn};
end

function [] = btn_call_clear( h , event , S , params )
    delete(params.value{5})
    f = params.value{1};
    elec = params.value{2};
    ions = params.value{3};
    radar = params.value{4};
    params.value = {f,elec,ions,radar,[]};
    
end