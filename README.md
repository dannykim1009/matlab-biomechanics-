# Biomechanics Data Analysis — MATLAB Projects
Danny Kim · Biomedical Engineering, UBC

## About
A collection of MATLAB scripts developed during undergraduate 
biomedical engineering coursework. Projects cover mechanical 
property analysis, viscoelastic material testing, and 3D 
kinematics — applied to real experimental datasets.

## Projects

**Trabecular Bone Stress-Strain Analysis**
Processes compression test data for three bone samples (healthy 
aligned, healthy misaligned, cancerous). Computes stress and strain 
from force-displacement data, identifies linear regions, calculates 
Young's modulus and ultimate stress, and plots stress-strain curves 
with linear region fits.
Input: CSV files (force and displacement columns)

**Synthetic Skin Tensile Testing**
Analyses cyclic tensile test data for two specimens under controlled 
displacement and controlled force conditions. Plots stress-strain 
curves, stress relaxation during holds, creep displacement over time, 
and maximum hold strain per cycle. Quantifies creep accumulation 
across 10 cycles.
Input: CSV files (time, force, displacement, cycle label columns)

**Bone Drilling 3D Kinematics**
Computes drill depth from optical motion capture marker data. 
Constructs local coordinate frames using cross products, builds 
homogeneous transformation matrices, and tracks probe position 
from drill entrance to exit across three measurement frames.
Input: XLSX files (3D marker position data)

**Goniometer Elbow Flexion Angle Analysis**
Computes elbow flexion angle using 3D kinematic marker and 
digitizer tip data. Constructs local coordinate frames for upper 
and lower arm, relates marker and digitizer frames, and calculates 
joint flexion angle for multiple trials.
Input: Hardcoded marker and digitizer position data

## Skills demonstrated
Stress-strain analysis · Young's modulus calculation · 
Viscoelastic material testing · 3D kinematics · Hom
