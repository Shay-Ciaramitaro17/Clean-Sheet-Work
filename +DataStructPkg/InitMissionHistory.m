function [Aircraft] = InitMissionHistory(Aircraft)
%
% [Aircraft] = InitMissionHistory(Aircraft)
% written by Paul Mokotoff, prmoko@umich.edu
% last updated: 12 dec 2024
%
% Initialize all arrays to zeros in the mission history for both SI and
% English units (although only SI units are currently used).
%
% INPUTS:
%     Aircraft - aircraft structure with non-existant mission history.
%                size/type/units: 1-by-1 / struct / []
%
% OUTPUTS:
%     Aircraft - aircraft structure with initialized  mission history.
%                size/type/units: 1-by-1 / struct / []
%


%% INITIALIZE VARIABLES FOR MISSION HISTORY %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get the number of points in the mission profile
npnt = Aircraft.Mission.Profile.SegEnd(end);

% get the number of components in the propulsion architecture
ncomp = length(Aircraft.Specs.Propulsion.PropArch.Arch);

% get the number of sources and transmitters
nsrc = length(Aircraft.Specs.Propulsion.PropArch.SrcType);
ntrn = length(Aircraft.Specs.Propulsion.PropArch.TrnType);

% create array of zeros to initialize the history
ZeroScalar = zeros(     npnt, 1);
ZeroChars  = repmat("", npnt, 1);

% array of zeros for the sources and transmitters
ZeroSrc = zeros(npnt, nsrc);
ZeroTrn = zeros(npnt, ntrn);

% array of zeros for the propulsion system components
ZeroComps = zeros(npnt, ncomp);

% array of zeros for energy/power/thrust splits
ZeroOperUps = zeros(npnt, max(1, Aircraft.Settings.nargOperUps));
ZeroOperDwn = zeros(npnt, max(1, Aircraft.Settings.nargOperDwn));

% performance sub-structure
Performance = struct("Time", ZeroScalar, ...
                     "Dist", ZeroScalar, ...
                     "TAS" , ZeroScalar, ...
                     "EAS" , ZeroScalar, ...
                     "RC"  , ZeroScalar, ...
                     "Alt" , ZeroScalar, ...
                     "Acc" , ZeroScalar, ...
                     "FPA" , ZeroScalar, ...
                     "Mach", ZeroScalar, ...
                     "Rho" , ZeroScalar, ...
                     "Ps"  , ZeroScalar) ;
                 
% propulsion sub-structure
Propulsion = struct("TSFC"    , ZeroTrn, ...
                    "ExitMach", ZeroTrn, ...
                    "FanDiam" , ZeroTrn, ...
                    "MDotAir" , ZeroTrn, ...
                    "MDotFuel", ZeroTrn) ;
                
% weights sub-structure
Weight = struct("CurWeight", ZeroScalar, ...
                "Fburn"    , ZeroScalar) ;
            
% power sub-structure
Power = struct("TV"      , ZeroScalar , ...
               "Req"     , ZeroScalar , ...
               "LamUps"  , ZeroOperUps, ...
               "LamDwn"  , ZeroOperDwn, ...
               "SOC"     , ZeroSrc    , ...
               "Pav"     , ZeroComps  , ...
               "Preq"    , ZeroComps  , ...
               "Tav"     , ZeroComps  , ...
               "Treq"    , ZeroComps  , ...
               "Pout"    , ZeroComps  , ...
               "Tout"    , ZeroComps  , ...
               "Voltage" , ZeroSrc    , ...
               "Current" , ZeroSrc    , ...
               "Capacity", ZeroSrc    ) ;
    
% energy sub-structure
Energy = struct("KE"      , ZeroScalar, ...
                "PE"      , ZeroScalar, ...
                "E_ES"    , ZeroSrc    , ...
                "Eleft_ES", ZeroSrc    ) ;

% assemble structures into cohesive structure
MissionVars = struct("Performance", Performance, ...
                     "Propulsion" , Propulsion , ...
                     "Weight"     , Weight     , ...
                     "Power"      , Power      , ...
                     "Energy"     , Energy     ) ;
                 

%% INITIALIZE MISSION HISTORY %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize the mission history and segments flown
Aircraft.Mission.History = struct("SI"     , MissionVars, ...
                                  "EE"     , MissionVars, ...
                                  "Segment", ZeroChars  ) ;
                              
% ----------------------------------------------------------

end
