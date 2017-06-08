% cueBeam_linear_array_basic
% Basic probe for the tutorial
% Copyright Jerzy Dziewierz, University of Strathclyde, 2008-2013
%match to steel like a tap tap player
% note, all units SI system

% load cueBeamCore into matlab
import_cueBeamPy;

% set up specimen
environment.wave_velocity = 5600; % m/s, steel

% Specifications
% beam angle 
deg_angle = 61; % fixed
% Side lobe level 

% set up beam parameters
beam.alpha_rotation = -deg2rad(deg_angle); % steer angle (fixed)
beam.focal_distance = 32e-3; % mm (fixed)
beam.display_limit_db = -30; % for display purposes only

% set up probe element locations.
probe = []; % reset probe description
probe.frequency = 5e6; % Hz, all other 
probe.n = 16; % number of elements (fixed)
probe.d = 0.7e-3; % element pitch
probe.e = probe.d-0.2e-3; % element width
probe.W = 10e-3; % passive aperture size
probe.apodisationtype = cueBeam.ApodisationType.None; % NOTE! press "tab" or see ApodisationType.m for available types.
probe.apodisationParameter1 = 0.5; % used with cueBeamApodisation.RaisedCosine as base level
probe.apodisationParameter2 = 0.7; % used with cueBeamApodisation.RaisedCosine as raise power

% set simulation options
simulation.lambert_map_density = 1e-3; % pixel size for lambert map
simulation.xy_resolution = 0.5e-3; % pixel size for XZ plot
simulation.xy_z_extent = 100e-3; % size of the computation field
simulation.xy_z0 = 3e-3;% note: do not start z0 from zero, 
% because the decibel range plots will be overwhelmed by amplitude of the sound close to the elements.
simulation.xy_x_extent = 50e-3; % x-extent of the computation field

simulation.verbose = true; % display comments
simulation.doplots = true; % display plots. If disabled, results are still stored in probe and beam data structures
% enable to produce report grade figures
simulation.doprints = false; % exports figures for report, requires  simulation.doplots=true, disable to make script go faster
simulation.papersize = 16; % cm

% note, might be slow on some computers
simulation.do3Dplot1 = true; % create a 3D view
simulation.do3DBeam = false; % export 3D beam shape to Voreen format. Note that due to high computation demand, this will only work on CUDA-enabled computers. Networked cuda is not enabled.
                            % for example outputs from this command, see the "Gallery of beam simulation examples.doc"
% note that Z-section of beam does only make sense if beam.alpha_rotation=0
simulation.doXZBeamSection = true;
simulation.XZBeamSection_Z = beam.focal_distance;

simulation.doLambertSection = true; 
simulation.lambert_radius = beam.focal_distance;

% !!!NOTE: Thec "spot size" or "resolution" depends on how one defines it!
% use the metric that fits YOUR application best.
% access the XZ and Lambert images from beam.beam_img_xz and img_lambert

simulation.prefix='probe1_'; % folder and file name for the saved files
simulation.LineSmoothing=false; % to make plots nicer, doesn't work on all systems 

% -----------------------------------
% launch the simulation script
cueBeam.process_linear_array;
% -----------------------------------

% save result
result=[];
result.environment=environment;
result.probe=probe;
result.beam=beam;
result.simulation=simulation;
save(simulation.prefix,'result');
% explore result
result