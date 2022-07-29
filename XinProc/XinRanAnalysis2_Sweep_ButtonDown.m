function XinRanAnalysis2_Sweep_ButtonDown(varargin)

if nargin==0                % call from GUI
    H =         gcbo;
else 
    H =         varargin{1};
end

ButtonTag =     get(H,              'tag');
hFig =          gcf;
    
%% Update "Spec", "Tune", or "Temp", "Frme", "Pixl"
switch ButtonTag(1:4)
    % Update Label: [       Spec	Tune 	Frame	Pixel	Title Stat
    % Update Label:             Delay 	TempAmp	Play 	AmpSpec	VarSTD StTk 
    case 'Spec';    Updt =[ 1   1   1   0   0   0   0   0   0   0   0   0];
    case 'Dely';    Updt =[ 0   1   1   0   0   0   0   0   0   0   0   0];
    case 'Tune';    Updt =[ 0   0   1   0   0   0   0   0   0   0   0   0];  
    case 'Frme';    Updt =[ 0   0   0   1   0   0   0   0   0   0   0   0];
    case 'Temp';    Updt =[ 0   0   0   0   1   0   0   0   0   0   0   0];
    case 'Play';    Updt =[ 0   0   0   0   0   1   0   0   0   0   0   0];
    case 'Pixl';    Updt =[ 0   0   0   0   0   0   1   0   0   0   0   0];
    case 'AmpS';    Updt =[ 0   0   0   0   0   0   0   1   0   0   0   0];
    case 'Titl';    Updt =[ 0   0   0   0   0   0   0   0   1   0   0   0];
    case 'Vstd';    Updt =[ 0   0   0   0   0   0   0   0   0   1   0   0];
    case 'Stat';    Updt =[ 0   0   0   0   0   0   0   0   0   0   1   1];
    case 'StTk';    Updt =[ 0   0   0   0   0   0   0   0   0   0   0   1];
    otherwise;      Updt =[ 0   0   0   0   0   0   0   0   0   0   0   0];
end
	SpecUpdt=Updt(1);       DelyUpdt=Updt(2);       TuneUpdt=Updt(3);   
    TempAmpUpdt=Updt(4);    FrmeUpdt=Updt(5);       Play=Updt(6); 
    PixlUpdt=Updt(7);       AmpSUpdt=Updt(8);       TitlUpdt=Updt(9);
    VstdUpdt=Updt(10);      StatUpdt=Updt(11);      StTkUpdt=Updt(12);
%% Amp(litude of the) S(pectrum)
if AmpSUpdt
    hAxesSpec =     getappdata(hFig,	'hAxesSpec');
    hDotSpec =      getappdata(hFig,	'hDotSpec');
    YLimRange =     get(hAxesSpec,      'YTick');
    CurYLim =       get(hAxesSpec,      'YLim');
    YLimRange =     YLimRange(3:end);
    CurYLim =       CurYLim(2);
    CurYLimIdx =    find(YLimRange == CurYLim, 1);
    if CurYLimIdx == length(YLimRange)
        CurYLimIdx = 1;
    else
        CurYLimIdx = CurYLimIdx +1;
    end        
    set(hAxesSpec,	'YLim',     [0 YLimRange(CurYLimIdx)]);
    set(hDotSpec,   'YData',	YLimRange(CurYLimIdx));
end

%% Spec(trum sample number selection)
if SpecUpdt
    hDotSpec =          getappdata(hFig,	'hDotSpec');
    hTextSpecRepNum =	getappdata(hFig,	'hTextSpecRepNum');
    cQRepNum =          getappdata(hFig,	'cQRepNum');
    dFrmeTime =         getappdata(hFig,	'dFrmeTime');
    dSesDurTotal =      getappdata(hFig,	'dSesDurTotal');
    SpecUpDown =        getappdata(H,       'UpDown');  % Rep Num up/down
                                                        % Call from GUI
    try
        dPseudoDelayOri =   getappdata(hFig,    'dPseudoDelayOri');
        dPseudoDelayCur =   getappdata(hFig,    'dPseudoDelayCur'); 
    catch
        dAxesHist =     getappdata(hFig,   'hAxesHist');
        dPseudoDelayOri =   str2double(dAxesHist.XLabel.String(8:10));
        dPseudoDelayCur =   dPseudoDelayOri;
        setappdata(hFig,	'dPseudoDelayOri',	dPseudoDelayOri);
        setappdata(hFig,	'dPseudoDelayCur',	dPseudoDelayCur);
    end
    % update cQRepNum
    cQRepNum =      cQRepNum + SpecUpDown;
    tRepNumMax =    (dSesDurTotal/dFrmeTime)/2;
    if cQRepNum<1;          cQRepNum = 1;                   end
    if cQRepNum>tRepNumMax;	cQRepNum = floor(tRepNumMax);	end
    % update AxesSpec
    setappdata(hFig,        'cQRepNum',	cQRepNum);
    set(hDotSpec,           'XData',    double((cQRepNum-1))/dSesDurTotal);
    set(hTextSpecRepNum,	'string',   sprintf('rep#:%d', cQRepNum-1));   
end

%% Del(a)y (update)
if DelyUpdt
    hHistAll =          getappdata(hFig,	'hHistAll');
    hHistIn =           getappdata(hFig,	'hHistIn');
    hTextHistXLabel =   getappdata(hFig,	'hTextHistXLabel'); 
    hTextTuneXLabel =   getappdata(hFig,    'hTextTuneXLabel');  
    dPseudoDelayOri =   getappdata(hFig,    'dPseudoDelayOri');
    dPseudoDelayCur =   getappdata(hFig,    'dPseudoDelayCur'); 
    dTrlDurTotal =      getappdata(hFig,	'dTrlDurTotal');
    dPtQt_FFTAgl =      getappdata(hFig,	'dPtQt_FFTAgl');
    cQRepNum =          getappdata(hFig,	'cQRepNum');
    dPtIndex_ROIin =	getappdata(hFig,	'dPtIndex_ROIin');
    dSesName =  get(hFig, 'Name');
    
    switch ButtonTag(1:4)
        case 'Spec';    DelyUpDown =    0;
        case 'Dely';    DelyUpDown =	getappdata(H,	'UpDown');  % Delay up/down
                        dPseudoDelayCur = (round(dPseudoDelayCur/0.2)+DelyUpDown)*0.2;
            dDelayLimit = 9.6;
            if dPseudoDelayCur<0;           dPseudoDelayCur = dDelayLimit;	end
            if dPseudoDelayCur>dDelayLimit; dPseudoDelayCur = 0;            end
            hTextHistXLabel.String = sprintf('Phase, %3.1f s compensated', dPseudoDelayCur);
            hTextTuneXLabel.String = sprintf('Hue: %3.1f s compensated phase angle; Value: phase amplitude', dPseudoDelayCur);
            setappdata(hFig, 'dPseudoDelayCur', dPseudoDelayCur);
        otherwise
    end
    % update AxesHist
    tPhase = (dPseudoDelayOri-dPseudoDelayCur)/dTrlDurTotal*2*pi;
    tAngle = dPtQt_FFTAgl(:,cQRepNum);    
    if contains(lower(dSesName), 'down')    % Reverse the angle for DOWN cycle
        tAngle = 2*pi - tAngle;
    end 
        tAngle = mod(tPhase+tAngle, 2*pi);  % re-compensate the delay
    if contains(lower(dSesName), 'down')    % Reverse the angle for DOWN cycle
        tAngle = 2*pi - tAngle;
    end 
    hHistAll.Data =	tAngle;   
    hHistIn.Data =	tAngle(dPtIndex_ROIin);     
    drawnow;
       
	% update AxesTune  
    dPtQt_FFTAmp =      getappdata(hFig,	'dPtQt_FFTAmp');
    dQCycNum =          getappdata(hFig,	'dQCycNum');
    dTrlDurPreStim =    getappdata(hFig,	'dTrlDurPreStim');
    dTrlDurStim =       getappdata(hFig,	'dTrlDurStim');
    dTrlDurTotal =      getappdata(hFig,	'dTrlDurTotal'); 
            dRawHue =	tAngle/(2*pi);
        if cQRepNum == dQCycNum
            dRawHue =	(dRawHue -   dTrlDurPreStim  /dTrlDurTotal) / ...
                                (   dTrlDurStim     /dTrlDurTotal);
        end
            dRawVal =    dPtQt_FFTAmp(:,cQRepNum);
        setappdata(hFig,     'dRawHue',   dRawHue);
        setappdata(hFig,     'dRawVal',   dRawVal);
end

%% Tuning
if TuneUpdt
    hAxesTuneHueHid =	getappdata(hFig,	'hAxesTuneHueHid');
    hImageTune =		getappdata(hFig,    'hImageTune');
    dTrlDurStim =       getappdata(hFig,	'dTrlDurStim');
    dRawHue =	getappdata(hFig,	'dRawHue');
    dRawSat =	getappdata(hFig,	'dRawSat');
    dRawVal =	getappdata(hFig,	'dRawVal');

    HueMapOptions = getappdata(hImageTune,	'HueMapOptions');
    HueMapOrder =   getappdata(hImageTune,	'HueMapOrder');
    HueTempolate =	getappdata(hImageTune,	'HueTempolate');

%     SatParaRange =  getappdata(hImageTune,	'SatParaRange');
    SatParaOrder =  getappdata(hImageTune,	'SatParaOrder');
    SatValSync =    getappdata(hImageTune,	'SatValSync');
    SatGroundOut =  getappdata(hImageTune,	'SatGroundOut');
    SatGroundTime =	getappdata(hImageTune,	'SatGroundTime');

    ValLimRange =   getappdata(hImageTune,	'ValLimRange');
    ValLimOrder =   getappdata(hImageTune,	'ValLimOrder');
    ValLim =        getappdata(hImageTune,	'ValLim');
        ValLimRange =   [ValLimRange(1)*[1/4 sqrt(2)/4 1/2 sqrt(2)/2]  ValLimRange]; % extend the ValRange for NIR
		
    % What TUNE parameter has changed, if any
    switch ButtonTag(5:end)
        case 'ScalebarHue'  
%             HueMapOptions = {...
%                 'HSLuv',        'HSLuv',        'HSVadjusted';
%                 'Circular',     'Linear',       'Circular'};
%             HueMapOptions = {...
%                 'HSLuv',	'HSV30',	'HSV210',	'HSVadjusted';
%                 'Circular',	'Opposite',	'Opposite', 'Circular'};
            HueMapOptions = {...
                'HSLuv',	'HSV0',     'HSVadjusted';
                'Circular',	'Opposite',	'Circular'};
            HueMapOrder =   HueMapOrder + 1;
            if HueMapOrder> length(HueMapOptions)
                HueMapOrder = 1;
            end
            HueMap =        [   HueMapOptions{1, HueMapOrder}, '_',...
                                HueMapOptions{2, HueMapOrder}   ];
            HueTempolate =	HueRedist(HueMapOptions{1, HueMapOrder},...
                                      HueMapOptions{2, HueMapOrder});
            HueColorMap =   hsv2rgb([HueTempolate ones(length(HueTempolate),2)]);            
            setappdata(hImageTune,	'HueMapOptions',    HueMapOptions);
            setappdata(hImageTune,	'HueMapOrder',      HueMapOrder);
            setappdata(hImageTune,	'HueMap',           HueMap);
            setappdata(hImageTune,	'HueTempolate',     HueTempolate);
            setappdata(hImageTune,	'HueColorMap',      HueColorMap);
            colormap(hAxesTuneHueHid, HueColorMap);     caxis(hAxesTuneHueHid, [0 1]);   
            ylabel(H,	'\uparrow Onset                                                    Offset \uparrow',...
                        'FontSize',             8,...
                        'VerticalAlignment',    'Cap');    
        case 'ScalebarSat'
            SatParaRange =	[   0   0   0               0   2   1   1   1;
                                1   1   1               0   0   0   1   1;
                            	0   0.6 -dTrlDurStim/2  0   0   0   0.6 0];
            if nargin==0 
                SatParaOrder =  SatParaOrder + 1;
            else
                switch HueMapOrder
                    case 1; SatParaOrder =  6;
                    case 2; SatParaOrder =  5;
                    case 3; SatParaOrder =  6;
                end
            end
            if SatParaOrder> length(SatParaRange)
                SatParaOrder = 1;
            end
            SatValSync =    SatParaRange(1, SatParaOrder);  % 0:Sat=1,  1:Sat synched w/ Val,   2:Sat as Hue
            SatGroundOut =  SatParaRange(2, SatParaOrder);  % 0:No Side Cut,    1:Side Cut
            SatGroundTime =	SatParaRange(3, SatParaOrder);  % Side Ground Out Time
            setappdata(hImageTune,	'SatParaOrder',     SatParaOrder);
            setappdata(hImageTune,	'SatValSync',       SatValSync);
            setappdata(hImageTune,  'SatGroundOut',     SatGroundOut);
            setappdata(hImageTune,	'SatGroundTime',	SatGroundTime);
            switch sprintf('%d',[SatValSync SatGroundOut]) 
                case '00'; str = '                                                          everything \uparrow';
                case '10'; str = '\rightarrow sync w/ value \leftarrow';
                case '01'; str = ['\uparrow out of stim\pm', sprintf('%4.1fs range', abs(SatGroundTime)) '       wihtin the range \uparrow']; 
                case '11'; str = ['\uparrow out of stim\pm', sprintf('%4.1fs range', abs(SatGroundTime)) '  \rightarrow sync w/ value \leftarrow   ']; 
                case '20'; str = '\rightarrow replace hue to show phase \leftarrow';
                otherwise
            end
            hAxesTuneSatHid = getappdata(hFig,	'hAxesTuneSatHid');
            if isempty(hAxesTuneSatHid)
            	aa=findall(gcf,'Type','axes');  hAxesTuneSatHid = aa(4);
            end
            if SatValSync==2
                colormap(hAxesTuneSatHid,   hsv2rgb([1/3*ones(65,1) [  1:-1/16:1/16 ...
                                                                                    0:1/16:15/16 ...
                                                                                    1:-1/16:1/16 ...
                                                                                    0:1/16:1]'  1.0*ones(65,1)]) );
            else               
                colormap(hAxesTuneSatHid,   hsv2rgb([1/3*ones(65,1) (0:1/64:1)'    0.5*ones(65,1)]) );
            end          
                caxis(   hAxesTuneSatHid,   [0 1]); 
            ylabel(H,	str,...
                        'FontSize',             8,...
                        'VerticalAlignment',    'Cap');
        case 'ScalebarVal'
            ValLimOrder =   ValLimOrder + 1;
            if ValLimOrder> length(ValLimRange)
                ValLimOrder = 1;
            end
            ValLim =        ValLimRange(ValLimOrder);
            setappdata(hImageTune,	'ValLimOrder',  ValLimOrder);
            setappdata(hImageTune,	'ValLim',       ValLim);
            ylabel(H,	sprintf('0                       (old plots: %5.3f %%)        %5.3f %%',...
                        ValLim*sqrt(2)*100, ValLim*100), ...
                        'FontSize',             8,...
                        'VerticalAlignment',    'Cap');
        otherwise
            % no TUNE parameter change, change should be on SPEC
    end
    % Calculate and Update TUNE image
    PtOne_Hue =             min(max(dRawHue, 0), 1);            % HUE
    InHueTempolate =        linspace(0, 1, length(HueTempolate))';
    PtOne_Hue =             interp1q(InHueTempolate, HueTempolate, PtOne_Hue);
    switch SatValSync                                           % SATURATION
        case 2; PtOne_Sat =	min(max(abs(abs(dRawHue-0.5)*2-0.5)*2, 0), 1);
        case 1; PtOne_Sat =	min(dRawVal/ValLim,1);
        case 0; PtOne_Sat =	dRawSat;
    end
    if SatGroundOut
        PtOne_Sat(dRawHue>(1+SatGroundTime/dTrlDurStim)) =	0;
        PtOne_Sat(dRawHue<(0-SatGroundTime/dTrlDurStim)) =	0;
    end
    PtOne_Val =             min(dRawVal/ValLim,1);              % VALUE
    PtThree_TuneMap =       hsv2rgb([	PtOne_Hue,...           % IMAGE
                                        PtOne_Sat,...
                                        PtOne_Val]);
	SizeImageTune =         size(get(hImageTune, 'CData'));
    PhPwThree_TuneMap =     uint8(255*reshape(PtThree_TuneMap,...
                                SizeImageTune(1),...
                                SizeImageTune(2),...
                                SizeImageTune(3) ) );
    set(hImageTune,    'CData',        PhPwThree_TuneMap);
        if strcmp(ButtonTag, 'TuneScalebarHue')
            H2 = findobj(gcf, 'tag', 'TuneScalebarSat');
            XinRanAnalysis2_Sweep_ButtonDown(H2);
        end
    drawnow;
end
%% Temp(oral) Amp(litude)      
if TempAmpUpdt  
    % callback is from "hFig2AxesFrmeScalebar"
    hAxesFrme =     getappdata(hFig,	'hAxesFrme');
    hAxesTemp =     getappdata(hFig,	'hAxesTemp');
    hAxesPixl =     getappdata(hFig,	'hAxesPixl');
    dAxesTempYLims= getappdata(hFig,	'dAxesTempYLims'); 
    Tmax =          get(hAxesTemp,      'YLim');
    Tmax =          Tmax(2);
    TmaxIdx =       find(dAxesTempYLims==Tmax);
    TmaxIdx =       TmaxIdx + 1;
    if TmaxIdx > length(dAxesTempYLims)
        TmaxIdx =   1;
    end
    Tmax =          dAxesTempYLims(TmaxIdx);
    TmaxLabels =    {	sprintf('-%3.1f%%',Tmax*100),...
                        '0%',...
                        sprintf(' %3.1f%%',Tmax*100) };
    caxis(hAxesFrme,                Tmax*[-1 1]);
    set(H,          'Limits',       Tmax*[-1 1]);
    set(hAxesTemp,	'YLim',         Tmax*[-1 1]);
    set(hAxesPixl,	'YLim',         Tmax*[-1 1]);
    set(H,          'Ticks',        Tmax*[-1 0 1]);
    set(hAxesTemp,	'YTick',        Tmax*[-1 0 1]);
    set(hAxesPixl,	'YTick',        Tmax*[-1 0 1]);
    set(H,          'TickLabels',   TmaxLabels);
    set(hAxesTemp,	'YTickLabels',  TmaxLabels);
    set(hAxesPixl,	'YTickLabels',  TmaxLabels);
end
%% Frame
if FrmeUpdt
    % callback is either from	"T.H.hFig2AxesTempTextRight" or
    %                           "T.H.hFig2AxesTempTextLeft"
    hImageFrme =        getappdata(hFig,	'hImageFrme');
    hTextTemp =         getappdata(hFig,	'hTextTemp');
    hTextFrmeXLabel =   getappdata(hFig,	'hTextFrmeXLabel');
    hDotTemp =          getappdata(hFig,	'hDotTemp');
	dFrmeTime =         getappdata(hFig,	'dFrmeTime');
    dFptPhPw_NormTrlAdj =   getappdata(hFig,	'dFptPhPw_NormTrlAdj');
    cFrmeNum =      getappdata(hFig,	'cFrmeNum');   
    cPlayingNow =	getappdata(hFig,	'cPlayingNow');   
    FrmeUpDown =    getappdata(H,       'UpDown');
    % update cFrmeNum
    TrialTotalFrmeNum =	size(dFptPhPw_NormTrlAdj,1);
    cFrmeNum =          cFrmeNum + FrmeUpDown;
    if cFrmeNum<1;                   cFrmeNum = 1;                  end
    if cFrmeNum>TrialTotalFrmeNum;   cFrmeNum = TrialTotalFrmeNum;	end
    FrmeTime =          cFrmeNum * dFrmeTime;
    if cPlayingNow
        XLabelString =  sprintf( 'Amplitude @ %4.1f s, in adjusted polarity, playing',...
                            cFrmeNum*dFrmeTime );
    else
        XLabelString =  sprintf('Amplitude @ %4.1f s, in adjusted polarity, click to play',...
                            cFrmeNum*dFrmeTime );
    end
    % update AxesFrme GUI & data
    setappdata(hFig,        'cFrmeNum',	cFrmeNum);
    set(hImageFrme,         'CData',    squeeze(dFptPhPw_NormTrlAdj(cFrmeNum,:,:)));
    set(hTextFrmeXLabel,	'String',   XLabelString);
    set(hDotTemp,           'XData',    cFrmeNum);
    set(hTextTemp,          'string',   sprintf('Time: %4.1f s', FrmeTime));  
end
%% Playing
if Play
    % Video Playback
    cPlayingNow =	getappdata(hFig,	'cPlayingNow');
    cPlayingNow =	1 - cPlayingNow;
    setappdata(hFig,	'cPlayingNow',   cPlayingNow);
    if cPlayingNow
        hTextTempRight =	getappdata(hFig,	'hTextTempRight');
        dFrmeTime =         getappdata(hFig,	'dFrmeTime');
        dTrlDurTotal =      getappdata(hFig,    'dTrlDurTotal');
        dSoundWave =        getappdata(hFig,	'dSoundWave');
        hAP = audioplayer(dSoundWave, 100e3);        
        cFrmeNum =          0;  
        setappdata(hFig,	'hAudioPlayer',     hAP); 
        setappdata(hFig,	'cFrmeNum',         cFrmeNum);    
        pause(0.5);
        timebase = tic;
        hAP.play;
        while toc(timebase)<dTrlDurTotal && getappdata(hFig, 'cPlayingNow')
            if toc(timebase)>(cFrmeNum*dFrmeTime)
                XinRanAnalysis2_Sweep_ButtonDown(hTextTempRight);
                cFrmeNum = cFrmeNum + 1;
            end       
            pause(0.05);
        end
        hAP.pause;     
            cPlayingNow = 0;
            setappdata(hFig,	'cPlayingNow',   cPlayingNow);
                XinRanAnalysis2_Sweep_ButtonDown(hTextTempRight);
    else
        hAP = getappdata(hFig,	'hAudioPlayer');
        hAP.pause;        
    end
end
%% Pixel
if PixlUpdt
    PixelPosi =         get(gca,            'CurrentPoint');
    PixelPosi =         round(PixelPosi(1,1:2));    
    PhInd =             PixelPosi(2);    
    PwInd =             PixelPosi(1);
    hAxesPixl =         getappdata(hFig,	'hAxesPixl');
    hLinePixlAll =      getappdata(hFig,	'hLinePixlAll');
    hLinePixlErrorbar =	getappdata(hFig,	'hLinePixlErrorbar');
    if ~isempty(hLinePixlErrorbar)
       	hTextPixlStats =getappdata(hFig,	'hTextPixlStats');
        dStat =         getappdata(hFig,	'dStat');
    else
        hLinePixlMean =	getappdata(hFig,	'hLinePixlMean');
    end
    hLineSpecPixl =     getappdata(hFig,	'hLineSpecPixl');
    hTextPixl =         getappdata(hFig,	'hTextPixl');
    dFptCtPhPw_NormTrl= getappdata(hFig,	'dFptCtPhPw_NormTrl');
	dPtQt_FFTAmp =      getappdata(hFig,	'dPtQt_FFTAmp');
    PtInd =             PhInd + (PwInd-1)*size(dFptCtPhPw_NormTrl,3);
    dFptCt_NormTrlPixl =squeeze(dFptCtPhPw_NormTrl(:,:,PhInd,PwInd));
    dSem =              std(dFptCt_NormTrlPixl, 1, 2)/sqrt(size(dFptCt_NormTrlPixl,2));
%     [~,ANOVA_tbl,~] =   anova1(dFptCt_NormTrlPixl', 1:size(dFptCt_NormTrlPixl,1), 'off');
    for i = 1:length(hLinePixlAll)
        hLinePixlAll(i).YData =	dFptCt_NormTrlPixl(:,i);
    end
    hAxesPixl.Title.String =    sprintf('Pixel(%dH,%dW): temporal traces across reps',...
        PhInd,PwInd);
    hTextPixl.String =	{...
        sprintf('Across-all:      %5.2f%%', 100*std(reshape(dFptCtPhPw_NormTrl(:,:,PhInd,PwInd), 1, []))),...
        sprintf('Across-rep:    %5.2f%%',	100*std(mean(dFptCtPhPw_NormTrl(:,:,PhInd,PwInd), 2), 0, 1)),...
        sprintf('Across-frame:%5.2f%%',     100*std(mean(dFptCtPhPw_NormTrl(:,:,PhInd,PwInd), 1), 0, 2)),...
        'on STD'};
    hLineSpecPixl.YData =       dPtQt_FFTAmp(PtInd, :);
    if ~isempty(hLinePixlErrorbar)
        hLinePixlErrorbar.YData =           mean(dFptCt_NormTrlPixl,2);
        hLinePixlErrorbar.YNegativeDelta =  dSem;
        hLinePixlErrorbar.YPositiveDelta =  dSem;
        hTextPixlStats.String =	{...
            sprintf('one way ANOVA'),...
            sprintf('F = %g',	dStat.F_ANOVA(PhInd,PwInd)),...
            sprintf('p = %g',   dStat.p_ANOVA(PhInd,PwInd))   };
    else
        hLinePixlMean.YData =       mean(dFptCt_NormTrlPixl,2);
    end
       
    drawnow;
end
%% Title clipping
if TitlUpdt
    AxesH =             get(H,      'Parent');
    AxesPosiMatlab =    get(AxesH,  'Position');
    FigPosiMatlab =     get(gcf,    'Position');
    FigName =           get(gcf,    'Name');
    MoniPosiMatlab =    get(0,      'MonitorPosition');
    MoniNumMain =       find(MoniPosiMatlab(:,1) == 1);
    % -x -y are counted from the lowerleft corner of the WINDOWS MAIN DISPLAY
    %   MATLAB� sets the display information values for this property at startup.
    %   The values are static. If your system display settings change, 
    %   for example, if you plug in a new monitor, then the values do not update. 
    %   To refresh the values, restart MATLAB.
    switch ButtonTag(5:8)
        case 'Var1';    AxesPlus = [    -2  -56 54  17  ];  figclip = 1;
        case 'Var2';    AxesPlus = [    -2  -56 64  17  ];  figclip = 1;
        case 'Var3';    AxesPlus = [    -2  -56 64  17  ];  figclip = 1;
        case 'Temp';    AxesPlus = [    -58 -35 10  17  ];  figclip = 1;
        case 'Pixl';    AxesPlus = [    -58 -35 10  17  ];  figclip = 1;
        case 'Spec';    AxesPlus = [    -70 -35 10  17  ];  figclip = 1;
        case 'Tune';    AxesPlus = [    -5  -25 100 17  ];  figclip = 1;
        case 'TuIm';    AxesPlus = [    -3  -3  0   0   ];  figclip = 1;
        case 'Frme';    AxesPlus = [    -67 -25 0   17  ];  figclip = 1;
        case 'Hist';    AxesPlus = [    -55 -57 5   17  ];  figclip = 1;
        case 'Stat';    AxesPlus = [    -5  -25 70  17  ];  figclip = 1;
        case 'Tex1';                                        figclip = 0;
        case 'Tex2';    AxesPlus = [    -1  -1  -1  -1  ];  figclip = 1;
                        AxesPosiMatlab = [ 0 0 FigPosiMatlab(3:4)];
        case 'Tex3';    SesName =   strtok(FigName, '"');
                        SesName =   split(SesName, '_');
                        SesName =   join(SesName(1:5), '_');
                        clipboard('copy',   SesName{1});...
                                                            figclip = 0;  
        case 'Tex4';    [~, SoundName] =    strtok(FigName, '"');
                        [~, SoundName] =	strtok(SoundName, '"');
                        [SoundName, ~] =	strtok(SoundName, '"');
                        clipboard('copy',   SoundName);       
                                                            figclip = 0;     
        otherwise
    end
    if figclip
        AxesAdd =       AxesPlus;
        AxesAdd(3:4) =  AxesAdd(3:4)-AxesAdd(1:2);
        FigCutMatlab =  AxesPosiMatlab + AxesAdd;
        MoniCutMatlab = FigCutMatlab + [FigPosiMatlab(1:2) 0 0];
        MoniCutWin =    MoniCutMatlab;
        MoniCutWin(2) = MoniPosiMatlab(MoniNumMain,4) - MoniCutWin(2) - MoniCutWin(4);
        % The following function requires NirCmd
        % http://www.nirsoft.net/utils/nircmd2.html#using
        % download NirCmd, unzip, and put the .exe files into Windows/System32
        dos([ 'C:\Windows\System32\Nircmd.exe savescreenshot *clipboard* ', ...
            sprintf('%d ', MoniCutWin) ]);
        % The coordinates for Nircmd is: -x, -y, width, height
        %   -x, -y are counted from the upperleft corner of the WINDOWS MAIN DISPLAY
        
    else
    end
end
%% Variance STD update
if VstdUpdt
    AxesH =             get(H,              'Parent');
    hTitle =            get(AxesH,          'Title');
    hXLabel =           get(AxesH,          'XLabel');
    dVarSTDs =          getappdata(hFig,    'dVarSTDs');
    cVstdNum =          getappdata(hFig,    'cVstdNum');
    cVstdNum =  cVstdNum + 1;
    if cVstdNum > length(dVarSTDs)
        cVstdNum = 1;
    end
    set(H,          'cData',    log10(dVarSTDs{cVstdNum}.PhPw_Data));
    set(hTitle,     'String',   dVarSTDs{cVstdNum}.Title);
    set(hXLabel,    'String',   dVarSTDs{cVstdNum}.XLabelStr);
    setappdata(hFig,'cVstdNum', cVstdNum);
    drawnow;
end
%% Statistics Update
    dStTkOpt =      'Tick';
if StatUpdt
    dStTkOpt =      'Map';    
end
%% Statistics Colorbar Update
if StTkUpdt
    dStatTickAll =      [	1e-50 1e-30 1e-20 1e-10	1e-7	1e-5   1e-4     0.001   0.01    0.05    1];
    dPolarity =         getappdata(hFig,    'dPolarity');
    dStat =             getappdata(hFig,    'dStat');
    hImageStat =        getappdata(hFig,    'hImageStat');
    dCLimL10End =       10^hImageStat.Parent.CLim(1);
    dStatTickIdx =      find(dStatTickAll >= dCLimL10End, 1);
    typeStr =           hImageStat.Parent.XLabel.String;
    StrSeq =        {   'one-way ANOVA (each sample in the trial is a group)',...       1
                        '2-sided t-test (1st vs 3rd trial Qts)',...                     2
                        '1-sided t-test (1st vs 3rd trial Qts)',...                     3
                        '2-sided Wilcoxon signed-rank test (1st vs 3rd trial Qts)',...	4
                        '1-sided Wilcoxon signed-rank test (1st vs 3rd trial Qts)',...	5
                        '2-sided Sign-test (1st vs 3rd trial Qts)',...              	6
                        '1-sided Sign-test (1st vs 3rd trial Qts)',...              	7
                        };
%                     ,... 
%                         'Welch''s t-test (1st Qt vs 3rd Qt of the trial)'
    % locate the map type
    for i = 1:length(StrSeq)
        if strncmpi(typeStr, StrSeq{i}, 13)
            typeNum = i;
        end
    end 
    if strcmp(dStTkOpt, 'Map')  % whether switch the map type
            typeNum = typeNum + 1;
        if  typeNum > length(StrSeq)
            typeNum = 1;
        end
    end
    switch  typeNum
        case 1;	cData = log10(dStat.p_ANOVA);       dColormapEnd = 1;
        case 2; cData = log10(dStat.p_TTest);       dColormapEnd = 1;
        case 4; cData = log10(dStat.p_WSignRank);   dColormapEnd = 1;
        case 6; cData = log10(dStat.p_SignTest);    dColormapEnd = 1;
        case 3; cData = log10(min(dStat.p_TTestR, dStat.p_TTestL)).*...
                       	(-1+2*(   dStat.p_TTestR< dStat.p_TTestL))          *-dPolarity;
                                                    dColormapEnd = 2;
        case 5; cData = log10(min(dStat.p_WSignRankR, dStat.p_WSignRankL)).*...
                      	(-1+2*(   dStat.p_WSignRankR< dStat.p_WSignRankL))  *-dPolarity;
                                                    dColormapEnd = 2;
        case 7; cData = log10(min(dStat.p_SignTestR, dStat.p_SignTestL)).*...
                    	(-1+2*(   dStat.p_SignTestR< dStat.p_SignTestL))    *-dPolarity;
                                                    dColormapEnd = 2;
    end
    % locate the p-value range
    if strcmp(dStTkOpt, 'Tick')
        dStatTickIdx =  dStatTickIdx -1;
        if dStatTickIdx<1
            dStatTickIdx = length(dStatTickAll)-3;
        end
    end
        dCLimL10End =       log10(dStatTickAll(dStatTickIdx)/2);
        dStatTick =         dStatTickAll(dStatTickIdx:end);
        dStatTickL10 =      log10(dStatTick);
    if      dColormapEnd == 1
        dCLimL10 =          dCLimL10End*[1 0];
        dStatTickL10Edge =  [dCLimL10End dStatTickL10];
        if length(dStatTickL10Edge)>9;  dFontsize = max(round(80/length(dStatTickL10Edge)), 7);
        else;                           dFontsize = 9;
        end  
    elseif  dColormapEnd == 2
        dCLimL10 =          dCLimL10End*[1 -1];
        dStatTickL10Edge =  [dCLimL10End dStatTickL10(1:end-1) -fliplr(dStatTickL10(1:end-1)) -dCLimL10End];
        dStatTick =         [dStatTick(   1:end-1)	fliplr(dStatTick)];
        dStatTickL10 =      [dStatTickL10(1:end-1) -fliplr(dStatTickL10)];
        if length(dStatTickL10Edge)>14; dFontsize = max(round(120/length(dStatTickL10Edge)), 7);
        else;                           dFontsize = 9;
        end            
    end
        dStatTickLabel =	cellfun(@sprintf, ...
            repmat({'%g'}, 1, length(dStatTick)), num2cell(dStatTick),...
                    'UniformOutput', false);
	% colormap
    dStatCVecL10 =	linspace(dCLimL10(1), dCLimL10(end), 400);
    dStatCVecIdx =  discretize(dStatCVecL10, dStatTickL10Edge);
    if      dColormapEnd == 1;  dColormap = parula(length(dStatTickL10Edge)-1);
    elseif  dColormapEnd == 2;  dColormap = [0 0 0.5000; jet(256)];
                                dColormap = dColormap(...
                                    round(linspace(1, 257, (length(dStatTickL10Edge)-1)))...
                                                      ,:  );
    end
                                dColormap = dColormap(dStatCVecIdx,:);
	% update GUI
    set(hImageStat,                 'CData',    cData);
    set(hImageStat.Parent.XLabel,   'String',   StrSeq(typeNum));  
    set(hImageStat.Parent,          'CLim',     dCLimL10); 
    set(hImageStat.Parent,          'Colormap', dColormap);
    set(hImageStat.Parent.Colorbar, 'Ticks',        dStatTickL10); 
    set(hImageStat.Parent.Colorbar, 'TickLabels',	dStatTickLabel); 
    set(hImageStat.Parent.Colorbar, 'FontSize',     dFontsize); 
end