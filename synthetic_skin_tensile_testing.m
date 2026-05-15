% =========================================================
% Synthetic Skin Tensile Testing Analysis
% =========================================================
% Processes cyclic tensile test data for two specimens:
% controlled displacement and controlled force.
% Plots stress-strain curves, stress relaxation, creep
% displacement, and maximum hold strain per cycle.
%
% Input:  RDJTest1Data.csv   — Controlled Displacement
%         RDJTest003Data.csv — Controlled Force
% Output: 4 figures + printed mechanical property summary
% =========================================================

clear; clc; close all;

%% ---------------- Specimen Geometry ----------------
% Using original dimensions for engineering stress/strain

% Controlled Displacement specimen
L0_disp        = 64.5;   % mm
smallWidth_disp = 3.60;   % mm
thickness_disp  = 1.3;    % mm
A0_disp         = smallWidth_disp * thickness_disp;  % mm^2

% Controlled Force specimen
L0_force        = 64.2;   % mm
smallWidth_force = 3.9;   % mm
thickness_force  = 1.6;   % mm
A0_force         = smallWidth_force * thickness_force;  % mm^2

numCycles = 10;

%% ---------------- Load Data ----------------
dispData  = readtable('RDJTest1Data.csv');
forceData = readtable('RDJTest003Data.csv');

%% ---------------- Extract Variables ----------------
% Controlled Displacement
tD      = dispData.Time_S;
FD      = dispData.Force_N;
dD      = dispData.Displacement_mm;
cycleD  = string(dispData.Cycle);

% Controlled Force
tF      = forceData.Time_S;
FF      = forceData.Force_N;
dF      = forceData.Displacement_mm;
cycleF  = string(forceData.Cycle);

%% ---------------- Engineering Stress / Strain ----------------
% Stress (MPa) = Force (N) / Area (mm^2)
% Strain = Displacement (mm) / Gauge Length (mm)
stressD = FD ./ A0_disp;
strainD = dD ./ L0_disp;

stressF = FF ./ A0_force;
strainF = dF ./ L0_force;

%% =========================================================
%% Figure 1: Stress-Strain Curve (single cycle)
%% =========================================================
selectedCycle = 1;  % use 1 for original, 10 for conditioned response
stretchLabel  = sprintf('%d-Stretch', selectedCycle);
stretchMask   = cycleD == stretchLabel;

strain_plot = strainD(stretchMask);
stress_plot = stressD(stretchMask);

% Sort by strain for clean left-to-right plotting
[strain_plot, idx] = sort(strain_plot);
stress_plot = stress_plot(idx);

% Light smoothing for cleaner presentation
stress_plot = smoothdata(stress_plot, 'movmean', 5);

figure('Color', 'w');
plot(strain_plot, stress_plot, 'LineWidth', 2.2);
xlabel('Engineering Strain (mm/mm)');
ylabel('Engineering Stress (MPa)');
title(sprintf('Skin Stress-Strain Curve (Cycle %d, Controlled Displacement)', selectedCycle));
grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.1);

%% =========================================================
%% Figure 2: Stress Relaxation (selected hold cycles)
%% =========================================================
cyclesRelax = [2 5];  % selected hold cycles to plot

figure('Color', 'w'); hold on;

for i = 1:length(cyclesRelax)
    c         = cyclesRelax(i);
    holdLabel = sprintf('%d-Hold', c);
    holdMask  = cycleD == holdLabel;

    if any(holdMask)
        tHold      = tD(holdMask);
        stressHold = stressD(holdMask);

        % Reset time to start at zero
        tHold = tHold - tHold(1);

        % Sort just in case
        [tHold, idx] = sort(tHold);
        stressHold   = stressHold(idx);

        % Light smoothing
        stressHold = smoothdata(stressHold, 'movmean', 3);

        plot(tHold, stressHold, 'LineWidth', 2.2);
    end
end

xlabel('Time During Hold (s)');
ylabel('Engineering Stress (MPa)');
title('Stress Relaxation During Controlled Displacement Holds');
legend('Cycle 2', 'Cycle 5', 'Location', 'best');
grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.1);

% Y-axis limits based on plotted cycles only
holdMaskAll = cycleD == "2-Hold" | cycleD == "5-Hold";
ymin_relax  = min(stressD(holdMaskAll));
ymax_relax  = max(stressD(holdMaskAll));
pad = 0.005;
ylim([ymin_relax - pad, ymax_relax + pad]);

hold off;

%% =========================================================
%% Figure 3: Displacement-Time Response (Controlled Force)
%% =========================================================
figure('Color', 'w');
plot(tF, dF, 'LineWidth', 2.0);
xlabel('Time (s)');
ylabel('Displacement (mm)');
title('Displacement-Time Response (Controlled Force)');
grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.1);

%% =========================================================
%% Figure 4: Maximum Hold Strain per Cycle (Controlled Force)
%% =========================================================
cycleNumbers   = (1:numCycles)';
peakHoldStrain = nan(numCycles, 1);

for c = 1:numCycles
    holdLabel = sprintf('%d-Hold', c);
    holdMask  = cycleF == holdLabel;

    if any(holdMask)
        peakHoldStrain(c) = max(strainF(holdMask));
    end
end

figure('Color', 'w');
plot(cycleNumbers, peakHoldStrain, '-o', 'LineWidth', 2.0, 'MarkerSize', 7);
xlabel('Cycle Number');
ylabel('Maximum Hold Strain (mm/mm)');
title('Maximum Hold Strain per Cycle (Controlled Force)');
grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.1);
xlim([1 numCycles]);

%% ---------------- Print Results ----------------
fprintf('\n===== Mechanical Properties =====\n');
fprintf('Controlled Displacement — A0: %.2f mm^2  |  L0: %.1f mm\n', A0_disp, L0_disp);
fprintf('Controlled Force        — A0: %.2f mm^2  |  L0: %.1f mm\n', A0_force, L0_force);
fprintf('Peak Hold Strain Cycle 1:   %.4f mm/mm\n', peakHoldStrain(1));
fprintf('Peak Hold Strain Cycle 10:  %.4f mm/mm\n', peakHoldStrain(end));
fprintf('Creep accumulation:         %.4f mm/mm\n', peakHoldStrain(end) - peakHoldStrain(1));
fprintf('=================================\n');
