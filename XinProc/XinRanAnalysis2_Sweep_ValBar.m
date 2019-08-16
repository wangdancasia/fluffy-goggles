function XinRanAnalysis2_Sweep_ValBar(varargin)

if nargin==0                % call from GUI
    H =         gcbo;
    ValLim =    getappdata(H, 'ValLim');
    ValLim =    ValLim*sqrt(2);
    if ValLim>0.05
        ValLim = 0.00025;
    end
else
    H =         varargin{1};
    ValLim =    varargin{2};
end

%% Get Data
RawHue =        getappdata(H, 'RawHue');
RawSat =        getappdata(H, 'RawSat');
RawVal =        getappdata(H, 'RawVal');
ImageH =        getappdata(H, 'ImageH');
PseudoH =       getappdata(H, 'PseudoH');
ImageCData =    getappdata(H, 'ImageCData');

% update image
    % HSV
    PtOne_Saturation =	min(RawSat/ValLim,1);
    PtOne_Value =       min(RawVal/ValLim,1);
    PtThree_TuneMap =	hsv2rgb([	RawHue,...
                                    PtOne_Saturation,...
                                    PtOne_Value]);
                            
    % HSLuv                        
%     PtOne_Hue =         350*RawHue;
%     PtOne_Saturation =	min(RawSat/ValLim,1)*100;
%     PtOne_Value =       min(RawVal/ValLim,1)*60;
%     PtThree_TuneMap =   zeros(length(PtOne_Hue), 3);
%     for i = 1:length(RawHue)
%         PtThree_TuneMap(i,1:3) = cell2mat(cell(py.hsluv.hsluv_to_rgb([...
%                     PtOne_Hue(i), PtOne_Saturation(i), PtOne_Value(i)])));
%     end                            
                            
                            
PhPwThree_TuneMap =  reshape(PtThree_TuneMap, size(ImageCData,1), size(ImageCData,2),3);
set(ImageH,...
                'CData',        PhPwThree_TuneMap);

% update Colorbar
caxis(PseudoH, [0 ValLim]);
ylabel(H,       ['0                                                             ',...
                sprintf('%5.3f %%',ValLim*100)],...
                'FontSize', 8);
%% Update Data            
setappdata(H,...
                'ValLim',       ValLim);
            
            
            %     R.PtOne_Saturation(R.PtOne_Hue>(1+0.6/S.TrlDurStim)) = 0;
%     R.PtOne_Saturation(R.PtOne_Hue<(0-0.6/S.TrlDurStim)) = 0;
    R.PtOne_Saturation(R.PtOne_Hue>1) = 0;
    R.PtOne_Saturation(R.PtOne_Hue<0) = 0;
    R.PtOne_Hue =      min(max(R.PtOne_Hue, 0), 1);
                            % limit the hue range as 0-HueLim  
                            % and according pixels' sat to be 0;
if contains(lower(S.SesSoundFile),  'sinusoidcycle')
    R.HueLim =         1.0;
else
    R.HueLim =         0.8;
end 
    R.PtOne_Hue =      R.PtOne_Hue * R.HueLim;
                            % CONTINUOUS or DIScontinous hue  

% % Construct the entire image       
% R.SaturationLim =       0.005;
% R.PtOne_Saturation =	min(R.PtOne_Saturation/R.SaturationLim,1);