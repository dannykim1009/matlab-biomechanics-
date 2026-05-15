% =========================================================
% BMEG 330 Lab 1: Bone Drilling 3D Kinematics
% =========================================================
% Computes drill depth using 3D kinematic marker data.
% Constructs local coordinate frames from rigid body markers,
% builds homogeneous transformation matrices, and tracks
% probe position from drill entrance to exit.
%
% Authors: Danny Kim, Joy Oo, Advait Chiniwala, Rachael Moores
%
% Input:  6 XLSX files (3D and 6D marker position data)
%         18 = Probe Positioning, 19 = Drill Positioning,
%         20 = Drilled
% Output: Drill depth in mm
% =========================================================

clear; clc; close all;

%% File names
ProbePositioning_3d = "18_3d.xlsx";
ProbePositioning_6d = "18_6d.xlsx";
DrillPositioning_3d = "19_3d.xlsx";
DrillPositioning_6d = "19_6d.xlsx";
Drilled_3d          = "20_3d.xlsx";
Drilled_6d          = "20_6d.xlsx";

%% Load data
data1 = readtable(ProbePositioning_3d);
data2 = readtable(ProbePositioning_6d);
data3 = readtable(DrillPositioning_3d);
data4 = readtable(DrillPositioning_6d);
data5 = readtable(Drilled_3d);
data6 = readtable(Drilled_6d);

%% Average data for M1 at the origin - global
M1_originX = mean(data1{:,14});
M1_originY = mean(data1{:,15});
M1_originZ = mean(data1{:,16});

%% Average data for M2 at the origin - global
M2_originX = mean(data1{:,17});
M2_originY = mean(data1{:,18});
M2_originZ = mean(data1{:,19});

%% Average data for M3 at the origin - global
M3_originX = mean(data1{:,20});
M3_originY = mean(data1{:,21});
M3_originZ = mean(data1{:,22});

%% Average data for Probe at the origin - global
Probe_originX = mean(data2{:,5});
Probe_originY = mean(data2{:,6});
Probe_originZ = mean(data2{:,7});

%% Average data for M1 at the entrance
M1_entrX = mean(data3{:,14});
M1_entrY = mean(data3{:,15});
M1_entrZ = mean(data3{:,16});

%% Average data for M2 at the entrance
M2_entrX = mean(data3{:,17});
M2_entrY = mean(data3{:,18});
M2_entrZ = mean(data3{:,19});

%% Average data for M3 at the entrance
M3_entrX = mean(data3{:,20});
M3_entrY = mean(data3{:,21});
M3_entrZ = mean(data3{:,22});

%% Average data for M1 at the exit
M1_exitX = mean(data5{:,14});
M1_exitY = mean(data5{:,15});
M1_exitZ = mean(data5{:,16});

%% Average data for M2 at the exit
M2_exitX = mean(data5{:,17});
M2_exitY = mean(data5{:,18});
M2_exitZ = mean(data5{:,19});

%% Average data for M3 at the exit
M3_exitX = mean(data5{:,20});
M3_exitY = mean(data5{:,21});
M3_exitZ = mean(data5{:,22});

%% Creating column vectors of markers
M1_origin = [M1_originX; M1_originY; M1_originZ];
M2_origin = [M2_originX; M2_originY; M2_originZ];
M3_origin = [M3_originX; M3_originY; M3_originZ];

Probe_origin = [Probe_originX; Probe_originY; Probe_originZ];

M1_entr = [M1_entrX; M1_entrY; M1_entrZ];
M2_entr = [M2_entrX; M2_entrY; M2_entrZ];
M3_entr = [M3_entrX; M3_entrY; M3_entrZ];

M1_exit = [M1_exitX; M1_exitY; M1_exitZ];
M2_exit = [M2_exitX; M2_exitY; M2_exitZ];
M3_exit = [M3_exitX; M3_exitY; M3_exitZ];

%% Finding R matrix - cross products and normalising vectors

% Origin frame
x_origin = M3_origin - M2_origin;
y_origin = M1_origin - M2_origin;
z_origin = cross(x_origin, y_origin);
y_origin = cross(z_origin, x_origin);  % reorthogonalise
i_origin = x_origin / norm(x_origin);
j_origin = y_origin / norm(y_origin);
k_origin = z_origin / norm(z_origin);

% Entrance frame
x_entr = M3_entr - M2_entr;
y_entr = M1_entr - M2_entr;
z_entr = cross(x_entr, y_entr);
y_entr = cross(z_entr, x_entr);
i_entr = x_entr / norm(x_entr);
j_entr = y_entr / norm(y_entr);
k_entr = z_entr / norm(z_entr);

% Exit frame
x_exit = M3_exit - M2_exit;
y_exit = M1_exit - M2_exit;
z_exit = cross(x_exit, y_exit);
y_exit = cross(z_exit, x_exit);
i_exit = x_exit / norm(x_exit);
j_exit = y_exit / norm(y_exit);
k_exit = z_exit / norm(z_exit);

%% Build homogeneous transformation matrices (4x4)
% Standard form: [ R | t ]
%                [ 0 | 1 ]

% Origin
rot_mat_origin     = [i_origin, j_origin, k_origin];
t_mat_origin       = eye(4);
t_mat_origin(1:3, 1:3) = rot_mat_origin;
t_mat_origin(1:3, 4)   = M2_origin;  % translation = M2 position

% Entrance
rot_mat_entr     = [i_entr, j_entr, k_entr];
t_mat_entr       = eye(4);
t_mat_entr(1:3, 1:3) = rot_mat_entr;
t_mat_entr(1:3, 4)   = M2_entr;

% Exit
rot_mat_exit     = [i_exit, j_exit, k_exit];
t_mat_exit       = eye(4);
t_mat_exit(1:3, 1:3) = rot_mat_exit;
t_mat_exit(1:3, 4)   = M2_exit;

%% Finding probe local coordinate
% Homogeneous coordinates: append 1 at end
Probe_Global = [Probe_origin; 1];
Probe_Local  = t_mat_origin \ Probe_Global;  % equivalent to inv(t_mat_origin) * Probe_Global

%% Distance measure
% Initial position of probe in global frame (at drill entrance)
InitialFrame = t_mat_entr * Probe_Local;

% Final position of probe in global frame (at drill exit)
FinalFrame = t_mat_exit * Probe_Local;

% Drill depth — Euclidean distance between entrance and exit
DrillDepth = FinalFrame - InitialFrame;
DrillDepth = norm(DrillDepth(1:3));

%% Print results
fprintf('\n===== Drill Depth Results =====\n');
fprintf('Drill Depth (3D Kinematics): %.4f mm\n', DrillDepth);
fprintf('================================\n');
