% =========================================================
% BMEG 330 Class Activity 3: Goniometer Test
% =========================================================
% Computes elbow flexion angle using 3D kinematic marker
% data and digitizer tip positions.
% Constructs local coordinate frames for upper and lower arm,
% relates marker and digitizer frames, and calculates joint
% angle for Trial 2 and Trial 5.
%
% Input:  Hardcoded marker and digitizer tip data
% Output: Flexion angle in degrees for Trial 2 and Trial 5
% =========================================================

clear; clc; close all;

%% ---------------- Raw Data ----------------
% Marker positions during digitizing trial
dataDigTrial1 = [-218.9863892 60.03144836 -1839.605469 -273.0874023 13.72027302 -1813.043457 -258.3425903 68.52529144 -1824.46936 -240.9143829 97.51029205 -1836.159546 -268.888031 123.4723511 -1827.14502 -303.5624084 100.5760422 -1810.240356];

% Digitizer tip locations during digitizing trial
dataTipD1 = [-311.6763611 3.260602951 -1798.617554];
dataTipD2 = [-294.3891602 -15.8750248 -1803.755981];
dataTipD3 = [-180.440567 112.00177 -1863.545288];
dataTipD4 = [-348.8101501 84.41236877 -1793.164307];
dataTipD5 = [-350.1513367 109.297287 -1792.363647];

% Angle trials
AngleTrial2 = [-218.880188 60.06882095 -1839.401489 -272.668335 13.83103466 -1812.121216 -258.1730957 68.57410431 -1824.121582 -240.9193726 97.49880981 -1836.155273 -268.9046631 123.4388199 -1827.172974 -303.5500488 100.5342026 -1810.225586];
AngleTrial3 = [-164.4012299 44.97359467 -1865.50647 -162.6697693 -31.04013252 -1865.500244 -193.7416077 16.20802116 -1852.755127 -240.8916473 97.57247925 -1836.258789 -268.8361511 123.5545044 -1826.963867 -303.543457 100.5893555 -1810.25708];
AngleTrial4 = [-128.9446259 69.87556458 -1881.964111 -83.69277191 11.91925144 -1901.280518 -134.9463806 27.35737801 -1879.008911 -240.8725586 97.53570557 -1836.25354 -268.8414612 123.5406494 -1826.97583 -303.5293274 100.5801392 -1810.242432];
AngleTrial5 = [-115.2871704 103.0109634 -1884.699463 -47.53772354 77.48399353 -1907.745361 -99.79878998 62.98815918 -1887.1698 -240.8661499 97.46425629 -1836.175171 -268.9093628 123.4664536 -1827.143799 -303.5409546 100.5401306 -1810.215942];
AngleTrial6 = [-117.2301483 126.3274384 -1887.637085 -46.76921845 126.1780396 -1916.019897 -90.43522644 93.77275085 -1895.798584 -240.8633423 97.45175934 -1836.194092 -268.901001 123.4629822 -1827.135132 -303.5386963 100.5346832 -1810.229736];

%% ---------------- Extract Markers and Digitizer Tips ----------------
% Body 1 (lower arm) markers
m5 = dataDigTrial1(:, 1:3).';
m6 = dataDigTrial1(:, 4:6).';
m7 = dataDigTrial1(:, 7:9).';

% Body 2 (upper arm) markers
m8  = dataDigTrial1(:, 10:12).';
m9  = dataDigTrial1(:, 13:15).';
m10 = dataDigTrial1(:, 16:18).';

% Digitizer tip positions
D1 = dataTipD1.';
D2 = dataTipD2.';
D3 = dataTipD3.';
D4 = dataTipD4.';
D5 = dataTipD5.';

%% ---------------- Body 1 (Lower Arm) Marker Frame ----------------
xL = m6 - m5;
yL = m7 - m5;
zL = cross(xL, yL);
yL = cross(zL, xL);  % reorthogonalise
iL = xL / norm(xL);
jL = yL / norm(yL);
kL = zL / norm(zL);

t_mat_L = eye(4);
t_mat_L(1:3, 1:3) = [iL, jL, kL];
t_mat_L(1:3, 4)   = m5;

%% ---------------- Body 1 (Lower Arm) Digitizer Frame ----------------
% z axis fixed into the page (lecture definition)
xDL = D2 - D1;          % hinge direction
zDL = [0; 0; -1];       % into the page
yDL = cross(zDL, xDL);
iDL = xDL / norm(xDL);
jDL = yDL / norm(yDL);
kDL = zDL / norm(zDL);

t_mat_DL = eye(4);
t_mat_DL(1:3, 1:3) = [iDL, jDL, kDL];
t_mat_DL(1:3, 4)   = D3;

% Relationship between marker and digitizer frame for body 1
T_MA_L = inv(t_mat_L) * t_mat_DL;

%% ---------------- Body 2 (Upper Arm) Marker Frame ----------------
xU = m9 - m8;
yU = m10 - m8;
zU = cross(xU, yU);
yU = cross(zU, xU);  % reorthogonalise
iU = xU / norm(xU);
jU = yU / norm(yU);
kU = zU / norm(zU);

t_mat_U = eye(4);
t_mat_U(1:3, 1:3) = [iU, jU, kU];
t_mat_U(1:3, 4)   = m8;

%% ---------------- Body 2 (Upper Arm) Digitizer Frame ----------------
% z axis fixed into the page (lecture definition)
xDU = D5 - D4;          % hinge direction
zDU = [0; 0; -1];       % into the page
yDU = cross(zDU, xDU);
iDU = xDU / norm(xDU);
jDU = yDU / norm(yDU);
kDU = zDU / norm(zDU);

t_mat_DU = eye(4);
t_mat_DU(1:3, 1:3) = [iDU, jDU, kDU];
t_mat_DU(1:3, 4)   = D3;

% Relationship between marker and digitizer frame for body 2
T_MA_U = inv(t_mat_U) * t_mat_DU;

%% =========================================================
%% Trial 2: Flexion Angle
%% =========================================================
% Extract markers for Trial 2
m5_2 = AngleTrial2(:, 1:3).';
m6_2 = AngleTrial2(:, 4:6).';
m7_2 = AngleTrial2(:, 7:9).';
m8_2 = AngleTrial2(:, 10:12).';
m9_2 = AngleTrial2(:, 13:15).';
m10_2 = AngleTrial2(:, 16:18).';

% Lower arm marker frame — Trial 2
xL2 = m6_2 - m5_2;
yL2 = m7_2 - m5_2;
zL2 = cross(xL2, yL2);
yL2 = cross(zL2, xL2);
iL2 = xL2 / norm(xL2);
jL2 = yL2 / norm(yL2);
kL2 = zL2 / norm(zL2);

t_mat_L2 = eye(4);
t_mat_L2(1:3, 1:3) = [iL2, jL2, kL2];
t_mat_L2(1:3, 4)   = m5_2;

% Upper arm marker frame — Trial 2
xU2 = m9_2 - m8_2;
yU2 = m10_2 - m8_2;
zU2 = cross(xU2, yU2);
yU2 = cross(zU2, xU2);
iU2 = xU2 / norm(xU2);
jU2 = yU2 / norm(yU2);
kU2 = zU2 / norm(zU2);

t_mat_U2 = eye(4);
t_mat_U2(1:3, 1:3) = [iU2, jU2, kU2];
t_mat_U2(1:3, 4)   = m8_2;

% Digitizer frames at Trial 2
t_mat_DL2 = t_mat_L2 * T_MA_L;
t_mat_DU2 = t_mat_U2 * T_MA_U;

% Joint angle — Trial 2
T_12_2    = inv(t_mat_DL2) * t_mat_DU2;
rot_joint_2 = T_12_2(1:3, 1:3);
theta_2   = atan2(rot_joint_2(1,2), rot_joint_2(2,2));
theta_deg_2 = rad2deg(theta_2);

fprintf('\n===== Flexion Angles =====\n');
fprintf('Flexion Angle for Trial 2: %.1f degrees\n', abs(theta_deg_2));

%% =========================================================
%% Trial 5: Flexion Angle
%% =========================================================
% Extract markers for Trial 5
m5_5  = AngleTrial5(:, 1:3).';
m6_5  = AngleTrial5(:, 4:6).';
m7_5  = AngleTrial5(:, 7:9).';
m8_5  = AngleTrial5(:, 10:12).';
m9_5  = AngleTrial5(:, 13:15).';
m10_5 = AngleTrial5(:, 16:18).';

% Lower arm marker frame — Trial 5
xL5 = m6_5 - m5_5;
yL5 = m7_5 - m5_5;
zL5 = cross(xL5, yL5);
yL5 = cross(zL5, xL5);
iL5 = xL5 / norm(xL5);
jL5 = yL5 / norm(yL5);
kL5 = zL5 / norm(zL5);

t_mat_L5 = eye(4);
t_mat_L5(1:3, 1:3) = [iL5, jL5, kL5];
t_mat_L5(1:3, 4)   = m5_5;

% Upper arm marker frame — Trial 5
xU5 = m9_5 - m8_5;
yU5 = m10_5 - m8_5;
zU5 = cross(xU5, yU5);
yU5 = cross(zU5, xU5);
iU5 = xU5 / norm(xU5);
jU5 = yU5 / norm(yU5);
kU5 = zU5 / norm(zU5);

t_mat_U5 = eye(4);
t_mat_U5(1:3, 1:3) = [iU5, jU5, kU5];
t_mat_U5(1:3, 4)   = m8_5;

% Digitizer frames at Trial 5
t_mat_DL5 = t_mat_L5 * T_MA_L;
t_mat_DU5 = t_mat_U5 * T_MA_U;

% Joint angle — Trial 5
T_12_5    = inv(t_mat_DL5) * t_mat_DU5;
rot_joint_5 = T_12_5(1:3, 1:3);
theta_5   = atan2(rot_joint_5(1,2), rot_joint_5(2,2));
theta_deg_5 = rad2deg(theta_5);

fprintf('Flexion Angle for Trial 5: %.1f degrees\n', abs(theta_deg_5));
fprintf('==========================\n');
