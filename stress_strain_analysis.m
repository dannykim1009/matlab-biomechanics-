% =========================================================
% Trabecular Bone Stress-Strain Analysis
% =========================================================
% Imports compression test data for three bone samples,
% computes stress and strain, plots stress-strain curves,
% identifies linear regions, and calculates Young's modulus
% and ultimate stress for each sample.
%
% Input:  Lab 6 CSV files (columns 5 = displacement, 6 = force)
%         Force in Newtons, displacement in mm
% Output: Stress-strain plot with linear fits, E and UTS values
% =========================================================

clear; clc; close all;

%% Load data
data006 = readmatrix('Lab 6 - SMASH again!!!!006Data.csv');
data007 = readmatrix('Lab 6 - SMASH again!!!!007Data.csv');
data008 = readmatrix('Lab 6 - SMASH again!!!!008Data.csv');

%% Extract displacement (mm) and force (N)
disp006  = data006(:, 5);
force006 = data006(:, 6);
disp007  = data007(:, 5);
force007 = data007(:, 6);
disp008  = data008(:, 5);
force008 = data008(:, 6);

%% Sample dimensions
% 006: Healthy and Aligned
d006 = 33.3;  % diameter (mm)
h006 = 20.0;  % height (mm)
A006 = pi * (d006/2)^2;  % cross-sectional area (mm^2)

% 007: Healthy and Misaligned
d007 = 32.7;
h007 = 20.1;
A007 = pi * (d007/2)^2;

% 008: Cancerous
d008 = 32.7;
h008 = 19.9;
A008 = pi * (d008/2)^2;

fprintf('\n===== Sample Areas =====\n');
fprintf('Area 006 = %.2f mm^2\n', A006);
fprintf('Area 007 = %.2f mm^2\n', A007);
fprintf('Area 008 = %.2f mm^2\n', A008);

%% Stress and strain
% Stress (MPa) = Force (N) / Area (mm^2) — N/mm^2 = MPa
% Strain = Displacement (mm) / Height (mm) — dimensionless
strain006 = disp006 / h006;
stress006 = force006 / A006;

strain007 = disp007 / h007;
stress007 = force007 / A007;

strain008 = disp008 / h008;
stress008 = force008 / A008;

%% Ultimate stress
ult006 = max(stress006);
ult007 = max(stress007);
ult008 = max(stress008);

%% Young's Modulus — linear region identified visually from stress-strain plot
idx006 = strain006 > 0.01 & strain006 < 0.04;
idx007 = strain007 > 0.06 & strain007 < 0.09;
idx008 = strain008 > 0.01 & strain008 < 0.04;

p006 = polyfit(strain006(idx006), stress006(idx006), 1);
p007 = polyfit(strain007(idx007), stress007(idx007), 1);
p008 = polyfit(strain008(idx008), stress008(idx008), 1);

E006 = p006(1);  % MPa
E007 = p007(1);
E008 = p008(1);

%% Plot stress-strain curves with linear fits
figure;
plot(strain006, stress006, 'b', 'LineWidth', 2, 'DisplayName', '006 Aligned');
hold on;
plot(strain007, stress007, 'r', 'LineWidth', 2, 'DisplayName', '007 Misaligned Healthy');
plot(strain008, stress008, 'g', 'LineWidth', 2, 'DisplayName', '008 Cancer');

% Linear fit overlays
strain_fit006 = linspace(0.01, 0.04, 100);
strain_fit007 = linspace(0.06, 0.09, 100);
strain_fit008 = linspace(0.01, 0.04, 100);

plot(strain_fit006, polyval(p006, strain_fit006), 'b--', 'DisplayName', 'Linear Fit 006');
plot(strain_fit007, polyval(p007, strain_fit007), 'r--', 'DisplayName', 'Linear Fit 007');
plot(strain_fit008, polyval(p008, strain_fit008), 'g--', 'DisplayName', 'Linear Fit 008');

xlabel('Strain');
ylabel('Stress (MPa)');
title("Stress-Strain Curves — Trabecular Bone Samples");
legend('Location', 'best');
grid on;

%% Print results
fprintf('\n===== Mechanical Properties =====\n');
fprintf('Sample 006 (Aligned):            E = %.2f MPa  |  Ultimate Stress = %.2f MPa\n', E006, ult006);
fprintf('Sample 007 (Misaligned Healthy): E = %.2f MPa  |  Ultimate Stress = %.2f MPa\n', E007, ult007);
fprintf('Sample 008 (Cancer):             E = %.2f MPa  |  Ultimate Stress = %.2f MPa\n', E008, ult008);
fprintf('=================================\n');
